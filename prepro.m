function [x, x2, t, t2, prepTable, usefulTable, names] = prepro(directory)
% Formats data for use in nhlSalaryPrediction.m

cd(directory);
bigTable = readtable('NHL 2017-18.xls');
names = bigTable{3:end,[17, 20]};

%% Remove unnecessary variables
prepTable = removevars(bigTable,{'Var2','Var3','Var4','Var5',...
    'Var15','Var16','Var17','Var18','Var19'});
prepTable = prepTable(2:end, [1:172, 177:179, 185:end]);

%% Make some categorical variables numeric (binary, etc)
% handedness
for i = 2:size(prepTable.Var11, 1)
    if strcmp(prepTable.Var11{i}, 'L') == 1
        prepTable.Var11{i} = 0;
    else
        prepTable.Var11{i} = 1;
    end
end

% position
for i = 2:size(prepTable.Var20, 1)
    if contains(prepTable.Var20{i}, 'C') == 1
        prepTable.Var20{i} = 3;
    elseif contains(prepTable.Var20{i}, 'RW') || contains(prepTable.Var20{i}, 'LW')
        prepTable.Var20{i} = 2;
    else
        prepTable.Var20{i} = 1;
    end
end

% team
teams = unique(prepTable.Var21(2:end));
for i = 1:size(teams,1)
    f = find(strcmp(prepTable.Var21, teams{i}) == 1);
    prepTable.Var21(f) = {i}; %#ok<*FNDSB>
end

% birth year
for i = 2:size(prepTable,1)
    x = cell2mat(table2array(prepTable(i,1)));
    x = str2double(x(8:11));
    prepTable.PlayerInformation{i} = x;
end

% others
for i = 2:size(prepTable,1)
    for j = 1:size(prepTable,2)
        try
            x = str2double(cell2mat(prepTable{i,j}));
        end
        if ~isnan(x)
            prepTable.(prepTable.Properties.VariableNames{j}){i} = x;
        end
        if isempty(prepTable.(prepTable.Properties.VariableNames{j}){i})
            prepTable.(prepTable.Properties.VariableNames{j}){i} = 0;
        end
    end
end

% remove rows with missing salary data (9 instances)
ind = [];
for i = 1:size(prepTable,1)
    if isempty(prepTable.Var187{i}) == 1
        ind(i) = 1; %#ok<*AGROW>
    end
end
prepTable = prepTable(setdiff(1:size(prepTable,1),find(ind==1)),:);


%% Prepare ML datasets
t = cell2mat(prepTable.Var187(2:end));
t2 = round(t./10000);
xTemp = removevars(prepTable,{'Var187','Var188'});
xTemp = table2array(xTemp(2:end,:));
x = [];
for i = 1:size(xTemp,1)
    for j = 1:size(xTemp,2)
        try %#ok<*TRYNC>
            x(i,j) = xTemp{i,j};
        end
    end
end

usefulTable = prepTable(:,[9,11,14,15]);
xTemp2 = table2array(usefulTable(2:end,:));
x2 = [];
for i = 1:size(xTemp2,1)
    for j = 1:size(xTemp2,2)
        try %#ok<*TRYNC>
            x2(i,j) = xTemp2{i,j};
        end
    end
end

save prepTable.mat
save usefulTable.mat
save x.mat
save x2.mat
save t.mat
save t2.mat
save names.mat


end



