from flask import Flask, request, jsonify
from pipelineVisual import extract_frames, initialize_pose_model, process_folder, preprocess_input_data, make_predictions
import joblib
import pandas as pd
import mediapipe as mp


app = Flask(__name__)

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


# Placeholder for /estimate-pose endpoint
@app.route('/estimate-pose', methods=['POST'])
def estimate_pose_endpoint():
    # Placeholder for function implementation
    return jsonify({'message': 'Estimate pose endpoint not implemented yet'})

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=True)
