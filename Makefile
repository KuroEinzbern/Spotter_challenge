include .env

ifeq ($(OS),Windows_NT)
    SHELL := bash.exe
    PYTHON := venv/Scripts/python
else
    SHELL := bash
    PYTHON := venv/bin/python
endif

.PHONY:install download_datasets data train predict_validation local_deploy publish_model

install:
	python -m venv venv
	$(PYTHON) -m pip install -r models_requirements.txt
	python -c "import os, shutil; shutil.copy('.env.example', '.env') if not os.path.exists('.env') else print('.env already exists')"

download_datasets:
	$(PYTHON) src/challenge_spotter/download_data.py

data:
	$(PYTHON) src/challenge_spotter/make_data.py

train:
	$(PYTHON) src/challenge_spotter/train.py

predict_validation:
	$(PYTHON) src/challenge_spotter/predict.py

test: 
	$(PYTHON) -m pytest tests/


local_deploy:
	docker build --build-arg MODEL_VERSION=$(MODEL_VERSION) -t predicting-transportation-costs .
	docker run --rm -p 8000:8000 predicting-transportation-costs

publish_model:
	$(PYTHON) src/challenge_spotter/publish_model.py