from flask import Flask, request, jsonify
from flask_cors import CORS
import pandas as pd
import joblib
import os

app = Flask(__name__)
CORS(app)

# Load Trained Models
MODEL_COST_PATH = 'saved_models/model_cost.pkl'
MODEL_DURATION_PATH = 'saved_models/model_duration.pkl'

model_cost = None
model_duration = None

if os.path.exists(MODEL_COST_PATH) and os.path.exists(MODEL_DURATION_PATH):
    model_cost = joblib.load(MODEL_COST_PATH)
    model_duration = joblib.load(MODEL_DURATION_PATH)
    print("✅ Models loaded successfully.")
else:
    print("⚠️ Saved models not found. Please run train_model.py first.")

def generate_recommendation(service_type, mileage, component_count):
    recommendations = []
    if service_type == 'Tune Up':
        recommendations.append("Disarankan melakukan pemeriksaan filter udara & pembersihan throttle body")
    elif service_type == 'Servis Rutin':
        recommendations.append("Pemeriksaan tekanan angin & penggantian oli mesin berkala")
    elif service_type == 'AC Service':
        recommendations.append("Pembersihan evaporator dan ganti freon AC")
    else:
        recommendations.append("Pemeriksaan umum kondisi komponen kendaraan")

    if mileage > 50000:
        recommendations.append("Cek kondisi kampas rem dan minyak rem")
    if component_count > 3:
        recommendations.append("Gunakan suku cadang orisinal untuk daya tahan lebih lama")

    return " • ".join(recommendations)

@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        "status": "online",
        "service": "201 Auto Garage ML API",
        "algorithm": "Random Forest Regression"
    }), 200

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()

        car_brand = data.get('car_brand', 'Toyota')
        car_model = data.get('car_model', 'Avanza')
        car_year = int(data.get('car_year', 2018))
        service_type = data.get('service_type', 'Tune Up')
        mileage = int(data.get('mileage', 75000))
        component_count = int(data.get('component_count', 3))

        input_df = pd.DataFrame([{
            'car_brand': car_brand,
            'car_model': car_model,
            'car_year': car_year,
            'service_type': service_type,
            'mileage': mileage,
            'component_count': component_count
        }])

        if model_cost and model_duration:
            pred_cost = float(model_cost.predict(input_df)[0])
            pred_duration = float(model_duration.predict(input_df)[0])
        else:
            # Fallback estimation if model files not present
            pred_cost = 350000 + (component_count * 150000)
            pred_duration = 2.5 + (component_count * 0.3)

        # Round cost to nearest 5000
        estimated_cost = round(pred_cost / 5000) * 5000
        estimated_duration = round(pred_duration, 1)
        recommendation = generate_recommendation(service_type, mileage, component_count)

        return jsonify({
            "estimated_cost": estimated_cost,
            "estimated_duration": estimated_duration,
            "recommendation": recommendation,
            "status": "success"
        }), 200

    except Exception as e:
        return jsonify({
            "error": str(e),
            "status": "failed"
        }), 400

if __name__ == '__main__':
    print("🚀 Starting 201 Auto Garage Random Forest API Server on port 5000...")
    app.run(host='0.0.0.0', port=5000, debug=True)
