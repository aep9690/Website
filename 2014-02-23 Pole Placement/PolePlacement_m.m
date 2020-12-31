%% Author - Andrew Pillips
% Date   - 2014-02-20
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

%% Transfer Functions
cNum = [(I+m*l^2)/alpha,0,-g*m*l/alpha];
cDen = [1, B*(I + m*l^2)/alpha, -(M + m)*m*g*l/alpha, -B*m*g*l/alpha, 0];
tfCart = tf(cNum,cDen);

pNum = [m*l/alpha, 0];
pDen = [1, B*(I + m*l^2)/alpha, -(M + m)*m*g*l/alpha, -B*m*g*l/alpha];
tfPend = tf(pNum,pDen);

%% Make zpk form of transfer functions
zpkPend = zpk(tfPend);
zpkCart = zpk(tfCart);

%% Make root locus plots
figure(1)
rlocus(zpkPend);
title('Root Locus for Pendulum')

%% Add a pole at 0
comp1Num = 1;
comp1Den = [1 0];
comp1 = zpk(tf(comp1Num,comp1Den));

% Get new compensated system
comp1Pend = minreal(comp1*zpkPend);

% Plot root locus
figure(2)
rlocus(comp1Pend);
title('Root Locus for 1st Compensator System');

%% Add complex conjugate zeros
% comp2Num = conv([1 2],[1 4]);
comp2Num = conv([1 10+1i*10],[1 10-1i*10]);
comp2Den = conv([1 0],[1 100]);
comp2 = zpk(tf(comp2Num, comp2Den));

% Get new compensated system
comp2Pend = minreal(comp2*zpkPend);

% Plot root locus
figure (3)
rlocus(comp2Pend);

%% Simulate the system
K = -500;
thetaInit = .1;
sim('PolePlacement');

figure(4)
subplot(2,1,1)
plot(t,Y(:,1))
title('Pendulum Response')
ylabel('Angle (Rad)')
subplot(2,1,2)
plot(t,Y(:,2))
title('Cart Response')
ylabel('Position (m)');