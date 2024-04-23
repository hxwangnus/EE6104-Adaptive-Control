% Linear Regression Using MATLAB
% The linear model is $y=ku$, where k is the parameter to be estimated.
u1 = [-180,-144,-108,-72,-36,0,36,72,108,144,180]'; % angular position
y1 = [-5,-4,-3,-2,-1,0,1,2,3,4,5]';     % potientiometer output
mdl1 = fitlm(u1,y1,'intercept',false);
disp(['The estimation of k_theta is: ',num2str(mdl1.Coefficients{1,1})])

u2 = [-301,-237,-172,-108,-45,0,48,111,175,239,303]'; % angular velocity
y2 = [-4.03,-3.17,-2.3,-1.45,-0.6,0,0.62,1.48,2.33,3.2,4.06]';% tachometer output
mdl2 = fitlm(u2,y2,'intercept',false);
disp(['The estimation of k_w is: ',num2str(mdl2.Coefficients{1,1})])

figure(1)
plot(u1,y1,'+b')
hold on;
plot(u1,mdl1.Fitted,'-r')
grid on;
xlabel('u'); ylabel('y');

figure(2)
plot(u2,y2,'+b')
hold on;
plot(u2,mdl2.Fitted,'-r')
grid on;
xlabel('u'); ylabel('y');
