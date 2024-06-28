import os
import cv2
import numpy as np
import mediapipe as mp
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from xgboost import XGBClassifier
from sklearn.svm import SVC
import joblib
import re

def extract_frames(input_video_path, output_folder, num_frames):
    # Open the video file
    cap = cv2.VideoCapture(input_video_path)

    # Get basic information about the video
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))

    # Calculate the step to ensure exactly num_frames frames are extracted
    step = max(total_frames // num_frames, 1)  # Ensure step is at least 1

    # Create the output folder if it doesn't exist
    os.makedirs(output_folder, exist_ok=True)

    # Loop through frames and save exactly num_frames frames
    frame_count = 0
    for i in range(0, num_frames * step, step):
        # Read the frame
        cap.set(cv2.CAP_PROP_POS_FRAMES, i)
        ret, frame = cap.read()

        # Ensure the frame was successfully read
        if not ret:
            break

        # Create the output filename based on the frame index
        output_filename = os.path.join(output_folder, f"frame_{frame_count}.jpg")

        # Save the frame
        cv2.imwrite(output_filename, frame)

        frame_count += 1
        if frame_count >= num_frames:
            break

    # Release the video capture object
    cap.release()

    # Check if the desired number of frames were extracted
    if frame_count < num_frames:
        print(f"Warning: Only {frame_count} frames extracted from {input_video_path}.")
        # Optionally, you can take appropriate action (e.g., log the issue or handle it in a specific way)

def initialize_pose_model():
    """Initialize the MediaPipe Pose model."""
    mp_pose = mp.solutions.pose
    return mp_pose.Pose()

def process_image_with_pose(image, pose_model):
    """Process an image using the provided pose model."""
    # Convert the image to RGB (MediaPipe uses RGB format)
    image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    
    # Process the image with MediaPipe Pose
    results = pose_model.process(image_rgb)
    return results.pose_landmarks

def extract_landmarks_x_y(landmarks):
    """Extract x and y coordinates from the pose landmarks."""
    if landmarks:
        landmarks_x = [lmk.x for lmk in landmarks.landmark]
        landmarks_y = [lmk.y for lmk in landmarks.landmark]
        return landmarks_x, landmarks_y
    return [], []

def process_folder(folder_path, pose_model,num_frames):
    """Process each frame in a folder and save poses to CSV."""
    landmark_names = [f"Frame_{frame_index}_{landmark}_{coord}"
                     for frame_index in range(num_frames)
                     for landmark in range(33)
                     for coord in ["X", "Y"]]
    
#     csv_columns = ["Video", "Class"] + landmark_names
    csv_columns = landmark_names

    csv_data = []        

    # Initialize lists to store landmark coordinates for each frame in the folder
    folder_landmarks_x = []
    folder_landmarks_y = []

    for frame_index, frame_name in enumerate(sorted(os.listdir(folder_path))):
        frame_path = os.path.join(folder_path, frame_name)

        if frame_name.endswith((".jpg", ".jpeg", ".png")):
            # Read the image
            image = cv2.imread(frame_path)

            # Process the image with the pose model
            landmarks = process_image_with_pose(image, pose_model)
            landmarks_x, landmarks_y = extract_landmarks_x_y(landmarks)

            # Append landmarks to the folder_landmarks lists
            folder_landmarks_x.extend(landmarks_x)
            folder_landmarks_y.extend(landmarks_y)

    # Add folder data to the CSV list
    csv_data.append(folder_landmarks_x + folder_landmarks_y)

    # Save data to CSV
    df = pd.DataFrame(csv_data, columns=csv_columns)
    return df
    # df.to_csv(output_csv_path, index=False)
    # df
    # df.info()
    print(f"Processing finished.")
def handle_null(df):
    for column in df:
        if df[column].isnull().values.any():
            df[column] = df[column].fillna(df[column].median())
    return df
def extract_hands(df):

    # Define the pattern to match the desired columns
    pattern = r'Frame_\d{1,2}_(1[1-9]|20|21|22)_(X|Y)'

    # Select columns that match the pattern
    selected_columns = [col for col in df.columns if re.search(pattern, col)]

    # Keep the first two columns and the selected columns
    selected_columns = df.columns[:2].tolist() + selected_columns

    # Filter the DataFrame to keep only the selected columns
    df = df[selected_columns]
    pattern = r'Frame_0_0_(X|Y)'

    # Select columns that do NOT match the pattern
    selected_columns = [col for col in df.columns if not re.search(pattern, col)]

    # Filter the DataFrame to keep only the selected columns
    df_filtered = df[selected_columns]
    # Now df contains only the first two columns and the columns matching the specified pattern
    # df_filtered.to_csv('landmarks_outputH.csv', index=False)
    return df_filtered
def make_predictions(model, input_data):
    
    # Make predictions directly with the DataFrame
    predictions = model.predict(input_data)

    return predictions

def process_video(video_path, pose_model, mp_pose,predictions=None):
    """Process video frames and display pose information."""
    video_capture = cv2.VideoCapture(video_path)

    while video_capture.isOpened():
        ret, frame = video_capture.read()
        if not ret:
            break

        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = pose_model.process(rgb_frame)

        if results.pose_landmarks:
            mp.solutions.drawing_utils.draw_landmarks(frame, results.pose_landmarks, mp.solutions.pose.POSE_CONNECTIONS)

        if predictions is not None:
            predicted_class = predictions
            tab_title = f'Pose Estimation - Predicted Class: {predicted_class}'
            cv2.setWindowTitle('Pose Estimation', tab_title)

        cv2.imshow('Pose Estimation', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    video_capture.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    config = {
        'volley': {'frames': 15, 'model_path': r"models\RF15VH.pkl"},
        'smash': {'frames': 65, 'model_path': r"models\xgboostS65N.pkl"},
        'ready': {'frames': 20, 'model_path': r"models\svm20R.pkl"},
        'lob': {'frames': 55, 'model_path': r"models\RF55LH.pkl"}
    }

    video = r'videos\ar1 (1).mp4'
    output_frames_folder = r"frames"

    model_type = 'ready'  # or 'lob', 'volley', 'smash'

    num_frames = config[model_type]['frames']
    extract_frames(video, output_frames_folder,num_frames)
    # Initialize the pose model
    pose_model = initialize_pose_model()

    # Process the main folder
    csv_data = process_folder(output_frames_folder, pose_model, num_frames)

    # Close the pose model
    # csv_data = pd.read_csv(output_csv_path)
    if model_type in ['volley','lob']:        
        #output_hands_csv_path = r"landmarks_outputH.csv"
        csv_data = extract_hands(csv_data)
        # Example: Load CSV data for inference
        #csv_data = pd.read_csv(output_hands_csv_path)
    if model_type in ['volley','lob','ready']:        
        #output_hands_csv_path = r"landmarks_outputH.csv"
        csv_data = handle_null(csv_data)
        # Example: Load CSV data for inference
        #csv_data = pd.read_csv(output_hands_csv_path)
    # Load the XGBoost model from the .pkl file
    model_path = config[model_type]['model_path']
    loaded_model = joblib.load(model_path)

    # Make predictions using the loaded model and CSV row data
    predictions = make_predictions(loaded_model, csv_data)

    print("Predictions:", predictions+1)
    process_video(video, pose_model, pose_model, predictions + 1)
    pose_model.close()
