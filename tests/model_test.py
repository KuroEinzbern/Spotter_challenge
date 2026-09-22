import pandas as pd
import challenge_spotter.config as cfg
import challenge_spotter.auxiliars as aux
import joblib
from sklearn.metrics import mean_absolute_error


def test_minimun_performance_expected_on_MAE():
    model = joblib.load(cfg.MODEL_PATH)
    df_test = pd.read_parquet(cfg.DATA_DIR / "test.parquet")
    X,Y = aux.prepare_data(df_test)
    predictions = model.predict(X)
    assert mean_absolute_error(y_true=Y, y_pred=predictions) < 160
