%% Author - Andrew Pillips
% Date   - 2014-03-02
% Title  - Pole Zero Cancelations and Root Locus
clear all
close all
clc

%% Plant Constants
M = 0.5;
m = 0.2;
B = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;
alpha = (M+m)*(I+m*l^2)-(m*l)^2;

%% Transfer Function
pNum = [m*l/alpha, 0];
pDen = [1, B*(I + m*l^2)/alpha, -(M + m)*m*g*l/alpha, -B*m*g*l/alpha];
tfPend = tf(pNum,pDen);

%% Multiply by 1/s
tNum = conv(pNum, [1]);
tDen = conv(pDen, [1 0]);

%% Partial Fraction Decomposition
[r, p, k] = residue(tNum, tDen);

%% Convert tfPend to digital
tfPendD = c2d(tfPend,.1,'zoh');