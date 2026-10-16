import os
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
import joblib

# 1. Generate Dataset for 201 Auto Garage
np.random.seed(42)
n_samples = 1000

brands = ['Toyota', 'Honda', 'Daihatsu', 'Mitsubishi', 'Suzuki', 'Nissan']
models_map = {
    'Toyota': ['Avanza', 'Innova', 'Yaris', 'Fortuner', 'Calya'],
    'Honda': ['Jazz', 'HR-V', 'CR-V', 'Brio', 'Civic'],
    'Daihatsu': ['Xenia', 'Terios', 'Ayla', 'Sigra'],
    'Mitsubishi': ['Xpander', 'Pajero'],
    'Suzuki': ['Ertiga', 'XL7', 'Swift'],
    'Nissan': ['Grand Livina', 'Serena']
}
services = ['Servis Rutin', 'Tune Up', 'AC Service', 'Ganti Ban', 'Kaki-kaki', 'Overhaul Mesin']

data = []
for _ in range(n_samples):
    brand = np.random.choice(brands)
    model = np.random.choice(models_map[brand])
    year = np.random.randint(2012, 2026)
    service = np.random.choice(services)
    mileage = np.random.randint(10000, 180000)
    components = np.random.randint(1, 8)

    # Base cost logic
    base_cost = {
        'Servis Rutin': 150000,
        'Tune Up': 350000,
        'AC Service': 250000,
        'Ganti Ban': 450000,
        'Kaki-kaki': 600000,
        'Overhaul Mesin': 2500000
    }[service]

    base_duration = {
        'Servis Rutin': 1.0,
        'Tune Up': 2.5,
        'AC Service': 1.5,
        'Ganti Ban': 0.8,
        'Kaki-kaki': 3.0,
        'Overhaul Mesin': 8.0
    }[service]

    # Modifiers
    brand_multiplier = 1.2 if brand in ['Honda', 'Mitsubishi'] else 1.0
    age = 2026 - year
    age_multiplier = 1.0 + (age * 0.02)
    mileage_multiplier = 1.0 + ((mileage / 100000) * 0.05)

    cost = (base_cost + (components * 120000)) * brand_multiplier * age_multiplier * mileage_multiplier
    duration = base_duration + (components * 0.3) + (age * 0.1)

    # Add noise
    cost += np.random.normal(0, 15000)
    duration += np.random.normal(0, 0.2)

    data.append({
        'car_brand': brand,
        'car_model': model,
        'car_year': year,
        'service_type': service,
        'mileage': mileage,
        'component_count': components,
        'estimated_cost': max(100000, round(cost, -3)),
        'estimated_duration': max(0.5, round(duration, 1))
    })

df = pd.DataFrame(data)

# 2. Train Models
X = df[['car_brand', 'car_model', 'car_year', 'service_type', 'mileage', 'component_count']]
y_cost = df['estimated_cost']
y_duration = df['estimated_duration']

categorical_features = ['car_brand', 'car_model', 'service_type']
numerical_features = ['car_year', 'mileage', 'component_count']

preprocessor = ColumnTransformer(
    transformers=[
        ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_features),
        ('num', 'passthrough', numerical_features)
    ]
)

model_cost_pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('regressor', RandomForestRegressor(n_estimators=100, random_state=42))
])

model_duration_pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('regressor', RandomForestRegressor(n_estimators=100, random_state=42))
])

model_cost_pipeline.fit(X, y_cost)
model_duration_pipeline.fit(X, y_duration)

# 3. Save Models
os.makedirs('python_backend/saved_models', exist_ok=True)
joblib.dump(model_cost_pipeline, 'python_backend/saved_models/model_cost.pkl')
joblib.dump(model_duration_pipeline, 'python_backend/saved_models/model_duration.pkl')

print("✅ Model Random Forest Regression berhasil dilatih dan disimpan ke python_backend/saved_models/")
