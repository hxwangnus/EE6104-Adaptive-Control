% parameters from calibration
CA3_calibration;
k_theta=mdl1.Coefficients{1,1};
k_w=mdl2.Coefficients{1,1};

% parameters for the plant
K=6.2;
tau=0.25;
b=[0;1];

K2 = 4.5;
tau2 = 0.45;

Ap=[0 1;0 -1/tau];
g=K/tau;

% parameters for the reference model, value are changed to explore
C=1;
w=10;

Am=[0 1;-w^2 -2*C*w];
gm=w^2;

% Gamma & gamma, value are changed to explore effect
Gamma=[100 0; 0 100];
gamma=1000;

% Lyapunov
Q=[100 0; 0 100]; % value are changed to explore
P=lyap(Am', Q);

% control gain
theta_x=((b'*(Am-Ap))./g)';
theta_r=(tau*w^2)/K;
disp(['The theoretical control gain theta_x1 is: ',num2str(theta_x(1))])
disp(['The theoretical control gain theta_x2 is: ',num2str(theta_x(2))])
disp(['The theoretical control gain theta_r is: ',num2str(theta_r)])

