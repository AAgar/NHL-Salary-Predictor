# Predicting NHL Players' Salaries
## Usage

### Data
NHL 2017-18.xls — data on NHL players from the 2017-18 season

### Scripts/Functions
nhlSalaryPrediction.m — this is the primary script which users will run

nhlModelGen.m — function that generates the SVM model, used in nhlSalaryPrediction.m

prepro.m — function that does the preprocessing on the first dataset, used in nhlSalaryPrediction.m

* other files will be generated as these scripts are run *

### Steps to Run

1. Ensure that all files are in the same folder, and note the directory
2. Open nhlSalaryPrediction.m and enter your directory in the ' ' space under the "Load Data" headline
3. Run the script (either by hitting "Run" at the top or executing "nhlSalaryPrediction.m" in the command window)
4. Follow the prompts in the Command Window to enter the desired player stats (enter the age, select the position, enter the number of goals, and enter number of assists)

The script will now run, calling upon prepro.m to generate the proper datasets and nhlModelGen.m to generate a trained SVM model. The script will then use the trained model and make a prediction. The output will include the predicted salary of the player you created as well as a list of players with similar salaries and their stats.


