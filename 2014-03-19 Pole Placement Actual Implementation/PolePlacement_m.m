%% Author - Andrew Pillips
% Date   - 2014-02-20
% Title  - Pole Zero Cancelations and Root Locus
% References:
% https://www.library.cmu.edu/ctms/ctms/simulink/examples/pend/pendsim.htm
% http://ctms.engin.umich.edu/CTMS/index.php?example=InvertedPendulum&section=SimulinkModeling
clear all
clc

%% Plant Constants
M = 0.5;
m = 0.2;
B = 0.1;
I = 0.006;
g = 9.8;
l = 0.3;
T = .01;

%% Create Controller
comp2Num = conv([1 10+1i*10],[1 10-1i*10]);
comp2Den = conv([1 0],[1 100]);
K = 500;

%% Create Digital Controller
cTF = tf(comp2Num,comp2Den);
dTF = c2d(cTF,T,'zoh');
[dNum, dDen] = tfdata(dTF);
dDen = dDen{1};
dNum = dNum{1};

%% Simulate system
thetaInit = .2;
STOP = 10;
sim('PolePlacementNonlinear');

%% Plot Results
figure(1)
subplot(2,1,1)
plot(t,Y(:,2))
ylabel('Theta (rad)');
subplot(2,1,2)
plot(t,Y(:,1))
ylabel('Position (m)')
xlabel('Time (s)')

%% Plot Digital Results
figure(2)
subplot(2,1,1)
plot(t,Yd(:,2))
ylabel('Theta (rad)');
subplot(2,1,2)
plot(t,Yd(:,1))
ylabel('Position (m)')
xlabel('Time (s)')

%% Plot Digital Results
figure(3)
subplot(2,1,1)
plot(t,Ydt(:,2))
ylabel('Theta (rad)');
subplot(2,1,2)
plot(t,Ydt(:,1))
ylabel('Position (m)')
xlabel('Time (s)')