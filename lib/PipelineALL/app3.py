from flask import Flask, request, jsonify
from newFullPipeline import process_video,extract_hands,handle_null,extract_frames, initialize_pose_model, process_folder, make_predictions
import joblib
import newFullPipeline
import pandas as pd
import mediapipe as mp
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
import shutil



app = Flask(__name__)
config = {
        'volley': {'frames': 15, 'model_path': r"models\RF15VH.pkl"},
        'smash': {'frames': 65, 'model_path': r"models\xgboostS65N.pkl"},
        'ready': {'frames': 20, 'model_path': r"models\svm20R.pkl"},
        'lob': {'frames': 55, 'model_path': r"models\RF55LH.pkl"}
    }
def cleanup_temporary_files(video_path, frames_folder):
    try:
        os.remove(video_path)
    except FileNotFoundError:
        pass

    try:
        shutil.rmtree(frames_folder)
    except OSError as e:
        print(f"Error: {frames_folder} : {e.strerror}")

@app.route('/summarize-video', methods=['POST'])
def summarize_video_endpoint():
    # Receive video file from request
    video_file = request.files['video']
    video_path = "temp_video.mp4"
    video_file.save(video_path)

    # Specify the output frames folder
    folder_path = "videoFrames"
    output_csv_path = "videoCSV.csv"

    # Extract frames from the video
    extract_frames(video_path, folder_path)

    # Initialize pose model
    pose_model = initialize_pose_model()

    # Process frames folder and save poses to CSV
    process_folder(folder_path, output_csv_path, pose_model,video_path)  # Pass video_path to process_folder

    # Load the XGBoost model from the .pkl file
    model_path = "Dataset/models/xgboost_model.pkl"
    loaded_model = joblib.load(model_path)

    # Load CSV data for inference
    csv_data = pd.read_csv(output_csv_path)
    csv_data_processed = preprocess_input_data(csv_data)

    # Make predictions using the loaded model and CSV row data
    predictions = make_predictions(loaded_model, csv_data_processed)

    # Convert predictions from NumPy array to list
    predictions_list = predictions.tolist()

    # Close pose model
    pose_model.close()

    return jsonify({'summary': predictions_list})

@app.route('/ready-video', methods=['POST'])
def ready_video_endpoint():
    # Receive video file from request
    video = request.files['video']
    video_path = "temp_video.mp4"
    video.save(video_path)

    # Specify the output frames folder
    output_frames_folder = r"frames"
    #output_csv_path = "videoCSV.csv"

    model_type = 'ready'
    num_frames = config[model_type]['frames']
    model_path = config[model_type]['model_path']
    try:

        # Extract frames from the video
        extract_frames(video_path, output_frames_folder, num_frames)

        # Initialize pose model
        pose_model = initialize_pose_model()
        #mp_pose = mp.solutions.pose

        # Process frames folder and save poses to CSV
        csv_data = process_folder(output_frames_folder, pose_model, num_frames)


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

        predictions = make_predictions(loaded_model, csv_data)


        # Convert predictions from NumPy array to list
        predictions_list = predictions.tolist()

        # Close pose model
        #process_video(video, pose_model, pose_model, predictions + 1)
        pose_model.close()
        # Delete temporary files
        cleanup_temporary_files(video_path, output_frames_folder)
        print("Predictions:", predictions + 1)

        return jsonify({'summary': predictions_list})
    except Exception as e:
        print(f"Error processing video: {str(e)}")
        cleanup_temporary_files(video_path, output_frames_folder)
        return jsonify({'error': f"Error processing video: {str(e)}"}), 500

@app.route('/lob-video', methods=['POST'])
def lob_video_endpoint():
    # Receive video file from request
    video = request.files['video']
    video_path = "temp_video.mp4"
    video.save(video_path)

    # Specify the output frames folder
    output_frames_folder = r"frames"
    #output_csv_path = "videoCSV.csv"

    model_type = 'lob'
    num_frames = config[model_type]['frames']
    model_path = config[model_type]['model_path']

    try:

        # Extract frames from the video
        extract_frames(video_path, output_frames_folder, num_frames)

        # Initialize pose model
        pose_model = initialize_pose_model()
        #mp_pose = mp.solutions.pose

        # Process frames folder and save poses to CSV
        csv_data = process_folder(output_frames_folder, pose_model, num_frames)


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

        predictions = make_predictions(loaded_model, csv_data)


        # Convert predictions from NumPy array to list
        predictions_list = predictions.tolist()

        # Close pose model
        #process_video(video, pose_model, pose_model, predictions + 1)
        pose_model.close()
        # Delete temporary files
        cleanup_temporary_files(video_path, output_frames_folder)
        print("Predictions:", predictions + 1)

        return jsonify({'summary': predictions_list})
    except Exception as e:
        print(f"Error processing video: {str(e)}")
        cleanup_temporary_files(video_path, output_frames_folder)
        return jsonify({'error': f"Error processing video: {str(e)}"}), 500


@app.route('/volley-video', methods=['POST'])
def volley_video_endpoint():
    # Receive video file from request
    video = request.files['video']
    video_path = "temp_video.mp4"
    video.save(video_path)

    # Specify the output frames folder
    output_frames_folder = r"frames"
    #output_csv_path = "videoCSV.csv"

    model_type = 'volley'
    num_frames = config[model_type]['frames']
    model_path = config[model_type]['model_path']

    try:

        # Extract frames from the video
        extract_frames(video_path, output_frames_folder, num_frames)

        # Initialize pose model
        pose_model = initialize_pose_model()
        #mp_pose = mp.solutions.pose

        # Process frames folder and save poses to CSV
        csv_data = process_folder(output_frames_folder, pose_model, num_frames)


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

        predictions = make_predictions(loaded_model, csv_data)


        # Convert predictions from NumPy array to list
        predictions_list = predictions.tolist()

        # Close pose model
        #process_video(video, pose_model, pose_model, predictions + 1)
        pose_model.close()
        # Delete temporary files
        cleanup_temporary_files(video_path, output_frames_folder)
        print("Predictions:", predictions + 1)

        return jsonify({'summary': predictions_list})
    except Exception as e:
        print(f"Error processing video: {str(e)}")
        cleanup_temporary_files(video_path, output_frames_folder)
        return jsonify({'error': f"Error processing video: {str(e)}"}), 500


@app.route('/smash-video', methods=['POST'])
def smash_video_endpoint():
    # Receive video file from request
    video = request.files['video']
    video_path = "temp_video.mp4"
    video.save(video_path)

    # Specify the output frames folder
    output_frames_folder = r"frames"
    #output_csv_path = "videoCSV.csv"

    model_type = 'smash'
    num_frames = config[model_type]['frames']
    model_path = config[model_type]['model_path']

    try:

        # Extract frames from the video
        extract_frames(video_path, output_frames_folder, num_frames)

        # Initialize pose model
        pose_model = initialize_pose_model()
        #mp_pose = mp.solutions.pose

        # Process frames folder and save poses to CSV
        csv_data = process_folder(output_frames_folder, pose_model, num_frames)


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

        predictions = make_predictions(loaded_model, csv_data)


        # Convert predictions from NumPy array to list
        predictions_list = predictions.tolist()

        # Close pose model
        #process_video(video, pose_model, pose_model, predictions + 1)
        pose_model.close()
        # Delete temporary files
        cleanup_temporary_files(video_path, output_frames_folder)
        print("Predictions:", predictions + 1)

        return jsonify({'summary': predictions_list})
    except Exception as e:
        print(f"Error processing video: {str(e)}")
        cleanup_temporary_files(video_path, output_frames_folder)
        return jsonify({'error': f"Error processing video: {str(e)}"}), 500



# Placeholder for /estimate-pose endpoint
@app.route('/estimate-pose', methods=['POST'])
def estimate_pose_endpoint():
    # Placeholder for function implementation
    return jsonify({'message': 'Estimate pose endpoint not implemented yet'})

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True)
