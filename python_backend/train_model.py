import os
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.metrics import mean_absolute_percentage_error, r2_score, mean_squared_error, mean_absolute_error
from sklearn.model_selection import train_test_split
import joblib

CSV_PATH = 'dataset_bengkel.csv'
SAVED_MODELS_DIR = 'saved_models'

def load_or_create_dataset():
    if os.path.exists(CSV_PATH):
        print(f"📊 Membaca data murni dari file: {CSV_PATH}")
        df = pd.read_csv(CSV_PATH)
    else:
        print("⚠️ File dataset_bengkel.csv tidak ditemukan. Membuat file template baru...")
        # Template sample
        data = [
            {'car_brand': 'Toyota', 'car_model': 'Avanza', 'car_year': 2018, 'service_type': 'Tune Up', 'mileage': 75000, 'component_count': 5, 'estimated_cost': 1150000, 'estimated_duration': 3.8},
            {'car_brand': 'Toyota', 'car_model': 'Avanza', 'car_year': 2020, 'service_type': 'Servis Rutin', 'mileage': 35000, 'component_count': 2, 'estimated_cost': 250000, 'estimated_duration': 1.2},
            {'car_brand': 'Honda', 'car_model': 'Jazz', 'car_year': 2019, 'service_type': 'Tune Up', 'mileage': 50000, 'component_count': 4, 'estimated_cost': 950000, 'estimated_duration': 3.0},
            {'car_brand': 'Honda', 'car_model': 'HR-V', 'car_year': 2021, 'service_type': 'AC Service', 'mileage': 28000, 'component_count': 3, 'estimated_cost': 450000, 'estimated_duration': 2.0},
            {'car_brand': 'Daihatsu', 'car_model': 'Xenia', 'car_year': 2017, 'service_type': 'Servis Rutin', 'mileage': 85000, 'component_count': 3, 'estimated_cost': 300000, 'estimated_duration': 1.5},
        ]
        df = pd.DataFrame(data)
        df.to_csv(CSV_PATH, index=False)

    return df

def train_random_forest():
    df = load_or_create_dataset()

    print(f"✅ Total data murni yang dimuat: {len(df)} baris")

    # Features & Targets
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

    # Pipelines
    model_cost_pipeline = Pipeline([
        ('preprocessor', preprocessor),
        ('regressor', RandomForestRegressor(n_estimators=100, random_state=42))
    ])

    model_duration_pipeline = Pipeline([
        ('preprocessor', preprocessor),
        ('regressor', RandomForestRegressor(n_estimators=100, random_state=42))
    ])

    # If dataset has enough rows, perform train-test split for evaluation
    if len(df) >= 10:
        X_train, X_test, y_cost_train, y_cost_test, y_dur_train, y_dur_test = train_test_split(
            X, y_cost, y_duration, test_size=0.2, random_state=42
        )

        model_cost_pipeline.fit(X_train, y_cost_train)
        model_duration_pipeline.fit(X_train, y_dur_train)

        # Cost Evaluation
        y_cost_pred = model_cost_pipeline.predict(X_test)
        mape_cost = mean_absolute_percentage_error(y_cost_test, y_cost_pred) * 100
        r2_cost = r2_score(y_cost_test, y_cost_pred)
        rmse_cost = np.sqrt(mean_squared_error(y_cost_test, y_cost_pred))

        # Duration Evaluation
        y_dur_pred = model_duration_pipeline.predict(X_test)
        mape_dur = mean_absolute_percentage_error(y_dur_test, y_dur_pred) * 100
        r2_dur = r2_score(y_dur_test, y_dur_pred)

        print("\n📈 === METRIK HASIL EVALUASI MODEL RANDOM FOREST ===")
        print(f"• MAPE (Akurasi Error Biaya)  : {mape_cost:.2f}%")
        print(f"• R-Squared (R² Biaya)       : {r2_cost:.4f}")
        print(f"• RMSE (Akar Error Biaya)    : Rp {rmse_cost:,.0f}")
        print(f"• MAPE (Akurasi Error Durasi) : {mape_dur:.2f}%")
        print("===================================================\n")

    # Fit full dataset for final deployment
    model_cost_pipeline.fit(X, y_cost)
    model_duration_pipeline.fit(X, y_duration)

    # Save models
    os.makedirs(SAVED_MODELS_DIR, exist_ok=True)
    joblib.dump(model_cost_pipeline, os.path.join(SAVED_MODELS_DIR, 'model_cost.pkl'))
    joblib.dump(model_duration_pipeline, os.path.join(SAVED_MODELS_DIR, 'model_duration.pkl'))

    print(f"💾 Model Random Forest berhasil disimpan ke folder '{SAVED_MODELS_DIR}/'")

if __name__ == '__main__':
    train_random_forest()
