"""Adapted from 201 AutoGarage/python_backend/train_model.py (60dd5336a2ad).

Keeps its six features, two RF regressors, 100 trees and seed 42.
Uses independent preprocessors and records reproducible holdout metrics.
Ten example rows demonstrate integration, not production model accuracy.
"""
import hashlib
import json
import os
from pathlib import Path
import joblib
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder

FEATURES = ['car_brand', 'car_model', 'car_year', 'service_type', 'mileage', 'component_count']

def pipeline():
    return Pipeline([
        ('preprocessor', ColumnTransformer([
            ('cat', OneHotEncoder(handle_unknown='ignore'), ['car_brand','car_model','service_type']),
            ('num', 'passthrough', ['car_year','mileage','component_count']),
        ])),
        ('regressor', RandomForestRegressor(n_estimators=100, random_state=42, n_jobs=1)),
    ])

def train(data_path=None, output_dir=None):
    source = Path(data_path or Path(__file__).with_name('dataset_bengkel.csv'))
    output = Path(output_dir or os.getenv('MODEL_DIR', 'saved_models'))
    output.mkdir(parents=True, exist_ok=True)
    data = pd.read_csv(source)
    x = data[FEATURES]
    train_ids, test_ids = train_test_split(data.index, test_size=.2, random_state=42)
    digest = hashlib.sha256(source.read_bytes()).hexdigest()
    report = {'model_version':'autogarage-rf-v1-'+digest[:12],
              'dataset_sha256':digest, 'rows':len(data), 'train_rows':len(train_ids),
              'holdout_rows':len(test_ids), 'features':FEATURES, 'seed':42,
              'source_commit':'60dd5336a2ad90443bad4a5f471de5ffb498da1d',
              'limitation':'10 example rows; holdout metrics do not establish real-world accuracy',
              'metrics':{}}
    for target, name in [('estimated_cost','model_cost'),('estimated_duration','model_duration')]:
        evaluation = pipeline().fit(x.loc[train_ids], data.loc[train_ids,target])
        prediction = evaluation.predict(x.loc[test_ids])
        report['metrics'][target] = {'holdout_mae':float(mean_absolute_error(data.loc[test_ids,target],prediction))}
        final = pipeline().fit(x, data[target])
        joblib.dump(final, output/f'{name}.pkl')
    (output/'manifest.json').write_text(json.dumps(report, indent=2))
    print(json.dumps(report,indent=2))
    return report

if __name__ == '__main__':
    train()
