# Installation and Execution Guide

This project follows the `src` layout and should therefore be installed as an editable dependency.

Run the following command from the project root to install the project and its dependencies: `pip install -r "models_requirements.txt"`

Since the provided download links were temporary, the initial data must be placed manually. Before running any scripts, create a `data/` directory in the project root and place the required CSV files inside it:
`train-test.csv`
`validation.csv`
`december-chart-inputs.csv`
    
Once these steps are complete, your environment will be fully functional.

# Running the pipeline

To generate the final results easily, execute the following commands from **`root/src/challenge_spotter`**:

1- **python make_data.py** 
this command preprocess the data and create the  train-test split that are used across the project. This must be executed before running the notebooks.

2- **python train.py**
Train the final model and serializate it, saving it in `root/models`

2- **python predict.py**
Load the final model, make the predictions and generates the outputs:
 - **validation_predictions.csv** in the root of the project (the script of score.py seems to expect to be there) 
 - **december_chart_inputs.csv** filled with their respective prediction in `root/data`

