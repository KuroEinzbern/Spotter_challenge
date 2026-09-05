from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent

DATA_DIR = PROJECT_ROOT / "data/"
NOTEBOOKS_DIR= PROJECT_ROOT / "notebooks/"
CONFIG_PATH= PROJECT_ROOT / "config.yaml"