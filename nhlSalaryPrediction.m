%% Predicting NHL Players' Salaries - developed by Akshar Agarwal for CPSC 100
%  Run this main script (after redefining directory as necessary) 
%  This script relies upon nhlModelGen.m and prepro.m
%  A few other functions are defined at the bottom of this script

%% Load data
directory = '~/Yale Drive/Freshman (2019-20)/Fall 2019/CPSC 100:CS50/final project';
cd(directory);
warning off
filenames = {'x.mat','x2.mat','t.mat','t2.mat','prepTable.mat','usefulTable.mat','names.mat'};
for i = 1:numel(filenames)
    if ~exist(filenames{i},'var')
        if isfile(filenames{i})
            load(filenames{i})
        else
        [x, x2, t, t2, prepTable, usefulTable, names] = prepro(directory);
        end
    end
end

%% Collect user input
age=input('Age: ','s');
while (isnan(str2double(age)) || str2double(age)<18 || str2double(age)>45)
     age=input('please enter only one number and make sure it is between (inclusive) 18 and 45: ','s');
end
age = str2double(age);

list = {'Defender','Winger','Center'};
[position,tf] = listdlg('ListString',list,'Name','Select Position','SelectionMode','single');
while tf == 0
    [position,tf] = listdlg('ListString',list,'Name','Select Position','SelectionMode','single');
end

goals=input('Goals: ','s');
while (isnan(str2double(goals)) || str2double(goals)<0 || str2double(goals)>49)
     goals=input('please enter only one non-zero number and make sure it is <=49: ','s');
end
goals = str2double(goals);

assists=input('Assists: ','s');
while (isnan(str2double(assists)) || str2double(assists)<0 || str2double(assists)>69)
     assists=input('please enter only one non-zero number and make sure it is <=68: ','s');
end
assists = str2double(assists);

%% Make prediction
[salary, simPlayers, simPlayersNames, mdl] = nhlPredict(x2, t2, names, age, position, goals, assists, directory); 

%% Print results
disp(['Salary: ', commatize(salary*10000)]);
disp('Players with similar salary (+/- 500k): ');
for i = 1:length(simPlayersNames)
    currPlayer = simPlayersNames{i};
    disp([(simPlayersNames{i}) ':']);
%     disp([simPlayers.(currPlayer(find(~isspace(currPlayer))))]);
    disp([simPlayers.(strcat('Player',num2str(i)))]);
end
disp(['Salary: ', commatize(salary*10000)]); % again for ease of viewing





function [salary, simPlayers, simPlayersNames, mdl] = nhlPredict(x2, t2, names, age, position, goals, assists, directory)
% Generate the SVM model and get a struct of similar players
[mdl] = nhlModelGen(x2, t2, directory);
x3 = [age position goals assists];
[label] = predict(mdl,x3);
salary = round(label);

simPlayersInd = intersect(find(t2<(salary+50)),find(t2>(salary-50)));
simPlayersNames = names(simPlayersInd,1);
simPlayers = struct();
for i = 1:length(simPlayersNames)
    currPlayer = simPlayersNames{i};
    tempInd = find(strcmp(names(:,1),currPlayer)==1); 
    simPlayers.(strcat('Player',num2str(i))).name = simPlayersNames{i}; 
    simPlayers.(strcat('Player',num2str(i))).age = names{tempInd,1}; %#ok<*FNDSB>
    simPlayers.(strcat('Player',num2str(i))).position = names{tempInd,2};
    simPlayers.(strcat('Player',num2str(i))).goals = x2(tempInd,3);
    simPlayers.(strcat('Player',num2str(i))).assists = x2(tempInd,4);
    % would use (currPlayer(find(~isspace(currPlayer)))) in place of strcat
    % but some names such as J.T. Brown aren't valid field names
end
end
function salaryCommatized = commatize(salary)
%  Make the final salary output more readable
   javaCommaFunction=java.text.DecimalFormat;
   salaryCommatized= char(javaCommaFunction.format(salary));
end
