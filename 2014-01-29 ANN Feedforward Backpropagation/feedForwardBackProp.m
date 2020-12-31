% =========================================================================
% Author: Andrew Phillips
% Date:   2014-01-23
% Description: Testing a back propagation neural network using letter
% recognition.
% =========================================================================
clear all
clc

%% Load the raw data and  split it into different data sets
rawData = xlsread('Raw_Letter_Data.xlsx');
% rawOuts = xlsread('aOutput.xlsx');
% rawOuts = xlsread('vowelOutputs.xlsx');
rawOuts = xlsread('aAndVowelOutputs.xlsx');

[numSamp, nI] = size(rawData);  % Number of input neurons
[~, nO] = size(rawOuts);        % Number of output neurons

train = .75;
test = .125;
valid = .125;
[trainInd, testInd, validInd] = divideint(numSamp,train, test, valid);

trainingData = rawData(trainInd,:);
testData = rawData(testInd,:);
validationData = rawData(validInd,:);

trainingOut = rawOuts(trainInd,:);
testOut = rawOuts(testInd,:);
validationOut = rawOuts(validInd,:);

%% Define the system values
nH = 12;                        % Number of hidden neurons

iL = -1*ones(nI + 1,1); % Input neurons plus the threshold neuron
hL = -1*ones(nH + 1,1); % Hidden neurons plus the threshold neuron
oL = -1*ones(nO);       % Output neurons

Wij = rand(nI + 1, nH)-.5;    % Input to hidden weights
Wjk = rand(nH + 1, nO)-.5;    % Hidden to output weights
deltaWjk = zeros(nH + 1, nO); % Change in hidden to output layer weights
deltaWij = zeros(nI + 1, nH); % Change in input to hidden layer weights

oldDeltaWjk = deltaWjk;
oldDeltaWij = deltaWij;

maxEpoch = 30; % Maximum number of learning cycles
alpha = .1;    % Learning rate
beta = .5;     % Momentum
perError = zeros(maxEpoch,nO);

%% Begin Training
waiting = waitbar(0,'Starting Training');
for epoch = 1:maxEpoch
    errors = zeros(1,nO);
    for index = 1:length(trainingData)
        % Find the input neurons
        iL(1:nI) = trainingData(index,:);
        
        % Find the hidden neuron values
        hL(1:nH) = (iL.'*Wij).';
        hL(1:nH) = 1./(1+exp(-hL(1:nH)));
        
        % Find the output neuron values
        oL = (hL.'*Wjk).';
        oL = 1./(1+exp(-oL));
        
        % Calculate the error gradiants
        outGrad = oL.*(1 - oL).*(trainingOut(index).' - oL);
        hiddenGrad = hL.*(1 - hL).*(Wjk*outGrad);
        
        % Find the change in the hidden to output weights
        for j = 1:nH
            for k = 1:nO
                deltaWjk(j,k) = alpha*hL(j)*outGrad(k);
            end
        end
        
        % Find the change in the input to hidden weights
        for i = 1:nI
            for j = 1:nO
                deltaWij(i,j) = alpha*iL(i)*hiddenGrad(j);
            end
        end
        
        % Update the weights
        Wij = Wij + deltaWij + beta*oldDeltaWij;
        Wjk = Wjk + deltaWjk + beta*oldDeltaWjk;
        
        % The current weights become the old ones
        oldDeltaWij = deltaWij;
        oldDeltaWjk = deltaWjk;
        
        % Find the output, and find the errors
        out = round(oL);
        for k = 1:nO
            if out(k) ~= trainingOut(index,k)
                errors(k) = errors(k) + 1;
            end
        end
    end
    
    % Record the amount of errors
    perError(epoch,:) = 100.*errors./round(numSamp*train);
    waitbar(epoch/maxEpoch,waiting,'Training Neural Network');
    
end
close(waiting);

%% Display training information
figure;
for i = 1:nO
    plot(100 - perError(:,i));
    hold on
end
hold off
title('Accuracy');
xlabel('Epoch');
ylabel('Accuracy');
for k = 1:nO
    s = sprintf('Training Accuracy for output %1g is %0.5g%%', k,...
        100 - perError(end,k));
    fprintf(s);
    fprintf('\n');
end

%% Check the test data
errors = zeros(1,nO);
for index = 1:length(testData)
    % Find the input neurons
    iL(1:nI) = testData(index,:);
    
    % Find the hidden neuron values
    hL(1:nH) = (iL.'*Wij).';
    hL(1:nH) = 1./(1+exp(-hL(1:nH)));
    
    % Find the output neuron values
    oL = (hL.'*Wjk).';
    oL = 1./(1+exp(-oL));
    
    % Find the output, and find the errors
    out = round(oL);
    for k = 1:nO
        if out(k) ~= testOut(index,k)
            errors(k) = errors(k) + 1;
        end
    end
end

%% Display test information
for k = 1:nO
    s = sprintf('Testing Accuracy for output %1g is %0.5g%%', k,...
        100 - 100*errors(k)/round(numSamp*test));
    fprintf(s);
    fprintf('\n');
end

%% Check the validation data
errors = zeros(1,nO);
for index = 1:length(validationData)
    % Find the input neurons
    iL(1:nI) = validationData(index,:);
    
    % Find the hidden neuron values
    hL(1:nH) = (iL.'*Wij).';
    hL(1:nH) = 1./(1+exp(-hL(1:nH)));
    
    % Find the output neuron values
    oL = (hL.'*Wjk).';
    oL = 1./(1+exp(-oL));
    
    % Find the output, and find the errors
    out = round(oL);
    for k = 1:nO
        if out(k) ~= validationOut(index,k)
            errors(k) = errors(k) + 1;
        end
    end
end

%% Display training information
for k = 1:nO
    s = sprintf('Validation Accuracy for output %1g is %0.5g%%', k,...
        100 - 100*errors(k)/round(numSamp*valid));
    fprintf(s);
    fprintf('\n');
end