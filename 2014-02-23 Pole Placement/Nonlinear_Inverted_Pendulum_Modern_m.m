%% Author: Andrew Phillips
%  Date: 2014-03-07
%  Description: Digital Controller on a Nonlinear System
clear all
close all
clc

%% Model Paramters
M = 0.5;
m = 0.2;
b = 0.1;
I = 0.006;
g = 9.8;
L = 0.3;
alpha = I*(M+m)+M*m*L^2;

%% State space system
A = [0 1 0 0;
     0 -b*(I+m*L^2)/alpha g*m^2*L^2/alpha 0;
     0 0 0 1;
     0 -m*L*b/alpha m*g*L*(M+m)/alpha 0];
B = [0; (I+m*L^2)/alpha; 0; m*L/alpha];
C = [1 0 0 0;
     0 0 1 0];
D = zeros(2,2);

%% Controller Design with place()
zeta = .7;
wn = 10;
POLES = [-zeta*wn - 1i*wn*sqrt(1-zeta^2);
         -zeta*wn + 1i*wn*sqrt(1-zeta^2);
         -10*zeta*wn - 1i*.1*wn*sqrt(1-zeta^2);
         -10*zeta*wn + 1i*.1*wn*sqrt(1-zeta^2)];
K = place(A,B,POLES);

%% Simulate the system
T = .01;
thetaInit = .1;
STOP = 1;
sim('Nonlinear_Inverted_Pendulum_Modern');

%% Plot Outputs
figure(1)
subplot(2,2,1)
plot(t,X(:,1))
title('Cart')
ylabel('Position (m)')
subplot(2,2,3)
plot(t,X(:,2))
ylabel('Velocity (m/s)')
xlabel('Time (s)')
subplot(2,2,2)
plot(t,X(:,3))
title('Pendulum')
ylabel('Position (rad)')
subplot(2,2,4)
plot(t,X(:,4))
ylabel('Velocity (rad/s)')
xlabel('Time (s)')

%% Controller design with Ackermann