# Transportation Cost Prediction

End-to-end Machine Learning project developed for transportation cost prediction.

The project covers the complete Machine Learning workflow, including **Exploratory Data Analysis (EDA), data preprocessing, feature engineering, model experimentation, hyperparameter optimization, model evaluation and validation**.

The final solution also implements the engineering and deployment components required to serve the model as a production-like application, including a **FastAPI REST API, Docker containerization, model versioning, automated testing and CI/CD**.

The project separates application code, data and model artifacts, allowing trained models to be versioned independently from the source code and deployed through an automated pipeline.

## Tech Stack

**Machine Learning:** Python, Pandas, NumPy, Scikit-learn, XGBoost, LightGBM, Optuna

**API:** FastAPI, Pydantic

**Testing:** Pytest

**MLOps & Infrastructure:** Docker, GNUMake, Git, GitHub Actions, Hugging Face, Render

## Project Structure

The project follows the `src` layout:

```text
.
├── data/
├── models/
├── notebooks/
├── src/
│   └── challenge_spotter/
│       ├── api/
│       ├── config.py
│       ├── download_data.py
│       ├── make_data.py
│       ├── train.py
│       ├── predict.py
│       └── publish_model.py
├── tests/
├── Dockerfile
├── Makefile
└── pyproject.toml
```

## Installation and Configuration

The project uses a Python virtual environment.

The `make install` command creates the virtual environment and installs the project dependencies defined in `pyproject.toml`

 The `.env` file is used for local configuration and is not committed to the repository.

The model version is defined through the `MODEL_VERSION` variable. This allows a new model version to be introduced without modifying the application code or deployment configuration.

## Makefile

The `Makefile` provides a single interface for the main project workflows:

| Command                   | Description                                                                         |
| ------------------------- | ----------------------------------------------------------------------------------- |
| `make install`            | Creates the Python virtual environment and installs the project dependencies.       |
| `make download_datasets`  | Downloads the required raw dataset files from Hugging Face.                         |
| `make data`               | Prepares the dataset and creates the temporal train/test holdout split.             |
| `make train`              | Trains the final Machine Learning model and serializes it locally.                  |
| `make predict_validation` | Loads the configured model and generates predictions for the validation data.       |
| `make test`               | Runs the complete automated test suite with Pytest.                                 |
| `make local_deploy`       | Builds the Docker image with the configured model version and runs the API locally. |
| `make publish_model`      | Publishes the trained model to the configured Hugging Face repository.              |

## Data

The raw dataset is hosted externally on Hugging Face.

The `make download_datasets` command downloads the required raw dataset files when they are not already available locally.

The `make data` command prepares the dataset and creates the train/test holdout split based on temporal ordering. The most recent **20% of the data is reserved as an out-of-sample (OOS) test set**, while the remaining data is used for training and model development.

The temporal split prevents future observations from being used to train the model when evaluating it on the OOS period.

## Exploratory Data Analysis and Experimentation

The project includes a dedicated exploratory and experimentation phase implemented through Jupyter notebooks.

The EDA covers the structure and characteristics of the dataset, data quality, distributions and relationships between relevant variables.

The experimentation stage evaluates different preprocessing strategies, feature engineering approaches and Machine Learning models before selecting the final configuration.

Hyperparameter optimization and cross-validation are used during the experimentation process to evaluate model performance while reducing the risk of relying on a single train/validation split.

Cross-validation is performed using **time series validation**, preserving the temporal ordering of observations between training and validation folds.

## Model Training and Evaluation

The `make train` command executes the final model training workflow.

The resulting model is serialized locally and identified by its configured version.

Model evaluation is performed using the temporal validation workflow, while the test suite also includes a model performance test to detect significant regressions.

The `make predict_validation` command loads the configured model and generates predictions for the validation data.

## Testing

The project includes automated tests covering the main components of the application, including:

* Data preparation and dataset integrity.
* API endpoints.
* Model functionality and minimum expected performance.

The `make test` command executes the complete test suite.

Keeping the tests independent from the training process allows the application and model behavior to be validated without retraining the model.

## Model Versioning

Model artifacts are stored independently from the application source code using Hugging Face.

A single Hugging Face model repository contains the different model versions:

```text
transportation_cost/
├── model_1.0
├── model_1.1
└── model_1.2
```

The active model version is controlled through the `MODEL_VERSION` environment variable.

The `make publish_model` command publishes the locally trained model to the Hugging Face repository.

Publishing a model requires valid Hugging Face credentials with permission to write to the repository. Therefore, this command cannot be executed by other users unless they provide their own credentials with the required permissions.

Training and publication are intentionally separate operations: a model is only published after it has been trained and validated.

## API

The trained model is exposed through a REST API implemented with FastAPI.

The API loads the configured model during application startup and provides an endpoint for generating transportation cost predictions.

FastAPI also provides interactive API documentation through its OpenAPI interface.

## Docker

The application is containerized using Docker.

The `Dockerfile` builds the application environment and downloads the configured model version from Hugging Face during the image build process.

This keeps the application source code and model artifacts independently versioned while ensuring that each Docker image contains the exact model version configured for that build.

The `make local_deploy` command builds the Docker image and runs the API locally.

## CI/CD and Deployment

The project implements a CI/CD workflow using GitHub Actions, Docker and Render.

The deployment flow is:

```text
GitHub
   │
   │ GitHub Actions
   ▼
Docker image build
   │
   │ Dockerfile downloads MODEL_VERSION
   │ from Hugging Face
   ▼
New Docker image
   │
   │ Published by GitHub Actions
   ▼
Render
   │
   │ Pulls the new image
   ▼
Updated API service
```

GitHub Actions is responsible for building and publishing the new Docker image.

During the Docker build, the `Dockerfile` downloads the configured model version from Hugging Face and packages it together with the application.

Render then uses the newly published Docker image to update the running service.

This allows application code and model artifacts to be versioned independently while maintaining an automated path from a source code change to a deployed API.


