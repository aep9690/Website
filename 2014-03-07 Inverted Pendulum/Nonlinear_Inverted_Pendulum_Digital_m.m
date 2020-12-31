%% Author: Andrew Phillips
%  Date: 2014-03-07
%  Description: Digital Controller on a Nonlinear System
clear all
close all
clc

%% Model Paramters
M = 0.5;
m = 0.2;
B = 0.1;
I = 0.006;
g = 9.8;
L = 0.3;
alpha = (M+m)*(I+m*L^2)-(m*L)^2;

%% Transfer Functions
cNum = [(I+m*L^2)/alpha,0,-g*m*L/alpha];
cDen = [1, B*(I + m*L^2)/alpha, -(M + m)*m*g*L/alpha, -B*m*g*L/alpha, 0];
tfCart = tf(cNum,cDen);

pNum = [m*L/alpha, 0];
pDen = [1, B*(I + m*L^2)/alpha, -(M + m)*m*g*L/alpha, -B*m*g*L/alpha];
tfPend = tf(pNum,pDen);

%% Controller
T = .001;
compNum = conv([1 10+1i*5],[1 10-1i*5]);
compDen = conv([1 0],[1 50]);
comp = tf(compNum, compDen);
compD = c2d(comp,T);
[dNum, dDen] = tfdata(compD);

%% Controller Design
% figure(1)
% rlocus(comp*tfPend);

%% Simulate the system
K = 365;
thetaInit = 1;
STOP = 12;
sim('Nonlinear_Inverted_Pendulum_Digital');

%% Plot Outputs
figure(2)
plot(t,THETA)
title('Theta')

figure(3)
plot(t,U);
title('Control Effort')