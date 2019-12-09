# Design

Overall, this project uses a few files to train an SVM model on the 2017-18 NHL Player data and then predicts the salary for a player whose stats the user enters. I chose to set it up as one overarching script, nhlSalaryPrediction.m, which the user can run that relies upon a couple of other separate functions. Simply hit tun in nhlSalaryPrediction.m as long as the directory is correct and it will work!

### Data

The dataset reflects a variety of statistics from all active NHL players in the 2017-18 season. It consists of information such as hometown, draft year, goals, assists, points, et cetera as well as advanced Corsi statistics and injuries.

The dataset contains lots of unnecessary information, such as cap hit, which prepro.m will fix!

### prepro.m

This function first formats the dataset as a matlab table (as opposed to a .csv). It then removes many of the columns which are simply unneeded. It then converts some categorical variables into numeric formats. For example, handedness can be expressed in binary (i.e. 0 for left and 1 for right). Other variables, such as position and team, can also be represented numerically by simply assigning a unique natural number to each possible outcome (e.g. centers are 3, wingers are 2, and defenders are 1). The birth year in the table is represented in an odd format and as a string, but we are only concerned with the year of birth for the most part so this is iteratively redone as well.

Some data points are missing, so rows (read: players) without salary data are removed from the table. This is only a small number of samples (9).

Next, the machine learning sets are created. A target/response matrix is created which solely contains the salaries. The salaries are all divided by 10,000 and rounded for ease. The input matrix is created as well, containg the remaining columns of data.

Initially I planned on using a lot of data, but for computational ease and simplicity, I settled on using some key statistics: age, position, goals, and assists. This also makes the program more usable for users to generate predictions without providing crazy shot angle statistics!

Finally, the function saves those datasets as well as a cell array of just players' names to the working directory.

### nhlSalaryPrediction.m

This function calls upon prepro.m initially to gather the data (first checking if files are already in existence to save some time). 

Then, it collects the user input for age, position, goals, and assists. These will be formatted properly and run into the function nhlPredict (nested at the bottom of this script per MATLAB specifications — in-file functions must reside at the end of the file).

That function relies upon nhlModelGen.m, which generates the trained SVM model. That model (which is described further in this documentation), is used to make a prediction on the new statistics entered by the user. A couple of other functions then format the output, and collate a list of similar players (within a similar salary range). All of this information is printed and the list is exported as a struct as well.

### nhlModelGen.m

This function is trained on the ML datasets generated from prepro.m and is capable of generating models for the larger dataset as well as my simplified (age, position, goals, and assists) model, although the former is commented out. The function fits a regression SVM model to the data and uses a process called Bayesian Optimization to determine the optimal hyperparameters. Plots and progress can be shown but I've muted them using name-value pairs to keep the command window clean. The model here is cross-validated using the k-fold (with k=10) method, which ensures the model is not overfitting to only the data provided (so that it's generalizable to the user's input and doesn't only work on the training set). I chose Bayesian Optimization over a random or grid search because it's far more efficient with just a small number of iterations. The finished model is exported to be used in nhlSalaryPrediction.m.

I tested out using a neural network and some other ML algorithms but settled on SVM for its simplicity and effectiveness (here, it worked well pretty much right off the bat). Also there isn't a whole lot of data (relatively) for many other complex models.
