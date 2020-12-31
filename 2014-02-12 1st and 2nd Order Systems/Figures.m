% First order system
t1 = 0:.001:1;
stable = tf(1,[1 3]);
unstable = tf(1,[1 -1]);
figure(1)
step(stable,t1);
hold on
step(unstable,t1);
hold off
legend('Negative Real Pole','Positive Real Pole')
title('First Order Response')

% Second order systems
zeta = [2 1 .5 0];
wn = 10;
t2 = 0:.001:2;
figure(2)
for i = 1:length(zeta)
    second = tf(wn^2,[1 2*zeta(i)*wn wn^2]);
    step(second,t2);
    hold on
end
title('Second Order Response')
legend('Over Damped','Critically Damped','Under Damped','Undamped');
hold off