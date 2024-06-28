import os
import cv2
import mediapipe as mp
import pandas as pd
import xgboost as xgb
import numpy as np
import joblib
import re

def extract_frames(input_video_path, output_folder, num_frames):
    print("extract frames start")
    print(input_video_path)
    cap = cv2.VideoCapture(input_video_path)
    total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    print(total_frames)
    step = max(total_frames // num_frames, 1)
    print(step)
    os.makedirs(output_folder, exist_ok=True)
    frame_count = 0

    for i in range(0, num_frames * step, step):
        cap.set(cv2.CAP_PROP_POS_FRAMES, i)
        ret, frame = cap.read()
        if not ret:
            break
        output_filename = os.path.join(output_folder, f"frame_{frame_count}.jpg")
        cv2.imwrite(output_filename, frame)
        frame_count += 1
        if frame_count >= num_frames:
            break

    cap.release()
    if frame_count < num_frames:
        print(f"Warning: Only {frame_count} frames extracted from {input_video_path}.")
    print("extract frames finish")


def initialize_pose_model():
    mp_pose = mp.solutions.pose
    return mp_pose.Pose()

def process_image_with_pose(image, pose_model):
    image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    results = pose_model.process(image_rgb)
    return results.pose_landmarks

def extract_landmarks_x_y(landmarks):
    if landmarks:
        landmarks_x = [lmk.x for lmk in landmarks.landmark]
        landmarks_y = [lmk.y for lmk in landmarks.landmark]
        return landmarks_x, landmarks_y
    return [], []

def process_folder(folder_path, output_csv_path, pose_model, video_path, num_frames):
    landmark_names = [f"Frame_{frame_index}_{landmark}_{coord}"
                     for frame_index in range(num_frames)
                     for landmark in range(33)
                     for coord in ["X", "Y"]]
    
    csv_columns = landmark_names

    csv_data = []
    folder_landmarks_x = []
    folder_landmarks_y = []

    for frame_index, frame_name in enumerate(sorted(os.listdir(folder_path))):
        frame_path = os.path.join(folder_path, frame_name)
        if frame_name.endswith((".jpg", ".jpeg", ".png")):
            image = cv2.imread(frame_path)
            landmarks = process_image_with_pose(image, pose_model)
            landmarks_x, landmarks_y = extract_landmarks_x_y(landmarks)
            folder_landmarks_x.extend(landmarks_x)
            folder_landmarks_y.extend(landmarks_y)

    csv_data.append(folder_landmarks_x + folder_landmarks_y)
    df = pd.DataFrame(csv_data, columns=csv_columns)
    df.to_csv(output_csv_path, index=False)
    print(f"Processing for folder {os.path.basename(folder_path)} finished.")

def fill_na_with_median(df):
    for column in df:
        if df[column].isnull().values.any():
            df[column] = df[column].fillna(df[column].median())
    return df

def extract_hand_landmarks(df):
    pattern = r'Frame_\d{1,2}(1[1-9]|20|21|22)(X|Y)'

    # Select columns that match the pattern
    selected_columns = [col for col in df.columns if re.search(pattern, col)]

    # Keep the first two columns and the selected columns
    selected_columns = df.columns[:2].tolist() + selected_columns

    # Filter the DataFrame to keep only the selected columns
    df = df[selected_columns]

    return df

def preprocess_input_data(data, model_type):    
    if model_type in ['volley', 'smash']:
        data = extract_hand_landmarks(data)
    
    if model_type in ['ready', 'lob', 'smash']:
        data = fill_na_with_median(data)
   
    return data

def make_predictions(model, input_data):
    predictions = model.predict(input_data)
    return predictions

def process_video(video_path, pose_model, mp_pose, predictions=None):
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
    config = {
        'ready': {'frames': 20, 'model_path': r"models\ready.joblib"},
        'lob': {'frames': 31, 'model_path': r"models\lob.pkl"},
        'volley': {'frames': 15, 'model_path': r"models\volley.pkl"},
        'smash': {'frames': 65, 'model_path': r"models\smash.pkl"},
    }
    #smash volley error lob ready right
    video_path = r"videos\AL1 (1).mp4"
    folder_path = "videoFrames"
    output_csv_path = "videoCSV.csv"

    # Change model_type based on the video
    model_type = 'smash'  # or 'lob', 'volley', 'smash'

    num_frames = config[model_type]['frames']
    model_path = config[model_type]['model_path']

    extract_frames(video_path, folder_path, num_frames)
    pose_model = initialize_pose_model()
    mp_pose = mp.solutions.pose
    process_folder(folder_path, output_csv_path, pose_model, video_path, num_frames)

    csv_data = pd.read_csv(output_csv_path)
    csv_data_processed = preprocess_input_data(csv_data, model_type)

    loaded_model = joblib.load(model_path)
    predictions = make_predictions(loaded_model, csv_data_processed)

    print("Predictions:", predictions + 1)
    process_video(video_path, pose_model, mp_pose, predictions + 1)
