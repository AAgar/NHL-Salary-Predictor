function [mdl3] = nhlModelGen(x2, t2, directory)
% Generates the SVM Model to be used in nhlSalaryPrediction > nhlPredict

cd(directory);

%% SVM
%% All data, full salaries
% mdl = fitrsvm(x,t,'OptimizeHyperparameters','all',...
%     'HyperparameterOptimizationOptions',struct('Optimizer','bayesopt','AcquisitionFunctionName',...
%     'expected-improvement-plus','Kfold',10,'MaxObjectiveEvaluations',30));

%% All data, reduced salaries
% mdl2 = fitrsvm(x,t2,'OptimizeHyperparameters','all',...
%     'HyperparameterOptimizationOptions',struct('Optimizer','bayesopt','AcquisitionFunctionName',...
%     'expected-improvement-plus','Kfold',10,'MaxObjectiveEvaluations',30));

%% Less data, reduced salaries
mdl3 = fitrsvm(x2,t2,'OptimizeHyperparameters','all',...
    'HyperparameterOptimizationOptions',struct('Optimizer','bayesopt','AcquisitionFunctionName',...
    'expected-improvement-plus','Kfold',10,'MaxObjectiveEvaluations',10,'ShowPlots',false,'Verbose',0));
end

