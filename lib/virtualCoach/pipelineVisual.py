import os
import cv2
import mediapipe as mp
import pandas as pd
import xgboost as xgb
import numpy as np
import joblib

def extract_frames(input_video_path, output_folder, num_frames=31):
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

def process_folder(folder_path, output_csv_path, pose_model,video_path):
    """Process frames in a folder and save poses to CSV."""
    num_frames = 31
    landmark_names = [f"Frame_{frame_index}_{landmark}_{coord}"
                     for frame_index in range(num_frames)
                     for landmark in range(33)
                     for coord in ["X", "Y"]]
    
    csv_columns = ["Video", "Class"] + landmark_names
    csv_data = []

    # Extract class label (second letter of video name)
    class_label = os.path.basename(video_path)[1] if len(os.path.basename(video_path)) >= 2 else ""

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
    csv_data.append([os.path.basename(video_path), class_label] + folder_landmarks_x + folder_landmarks_y)

    # Save data to CSVs
    df = pd.DataFrame(csv_data, columns=csv_columns)
    df.to_csv(output_csv_path, index=False)
    print(f"Processing for folder {os.path.basename(folder_path)} finished.")





# Function to preprocess input data for inference
def preprocess_input_data(data):
    # Drop the first two columns
    data_without_first_two_columns = data.iloc[:, 2:]
    
    # Add any other preprocessing steps here based on how the model was trained
    # Ensure that the input data has the same features and format as the training data
    return data_without_first_two_columns

# Function to make predictions using the loaded XGBoost model
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
            mp.solutions.drawing_utils.draw_landmarks(frame, results.pose_landmarks, mp_pose.POSE_CONNECTIONS)

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
    # Specify the input videos folder
    video_path = "Dataset\graduation_videos\m1 (5).mp4"
    # Specify the output frames folder
    folder_path = "videoFrames"
    output_csv_path = "videoCSV.csv"

    extract_frames(video_path, folder_path)

    pose_model = initialize_pose_model()
    mp_pose = mp.solutions.pose

    process_folder(folder_path, output_csv_path, pose_model)

    # Example: Load CSV data for inference
    csv_data = pd.read_csv(output_csv_path)
    csv_data_processed = preprocess_input_data(csv_data)
    #print(csv_data_processed.shape)

    # Load the XGBoost model from the .pkl file
    model_path = r"Dataset\models\xgboost_model.pkl"
    loaded_model = joblib.load(model_path)

    # Make predictions using the loaded model and CSV row data
    predictions = make_predictions(loaded_model, csv_data_processed)

    print("Predictions:", predictions+1)

    # Display video with pose estimation and predictions in tab title
    process_video(video_path, pose_model, mp_pose,predictions+1)
    pose_model.close()



        
