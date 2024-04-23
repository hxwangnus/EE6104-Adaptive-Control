clc
clear all;

%% Define initial parameters for the PI controllers
Kc = 5e6; % proportional gain
TI = 500; % integral time
gamma = 1; % step size
eta = 1.2; % weight factor in cost function

%% Define thickness
rn = 8750; % in nm, target thickness
y0 = 10000; % initial thickness, manually chosen from the paper

reference = load("reference signal4.mat");
open_system('CA2_model');
out = sim('CA2_model.slx');

%% IFT

s = tf('s'); % Define the symbolic variable for s (Laplace transform variable)

% Calculation need for J(Kc, TI) and R.
sum_error = 0; % sum of error
sum_yydyyKc = 0; % sum of yy*(dyy/dKc)
sum_yydyyTI = 0; % sum of yy*(dyy/dTI)
sum_uduKc = 0; % sum of u*(du/dKc)
sum_uduTI = 0; % sum of u*(du/dTI)
sum_dyy2Kc = 0; % sum of (dyy/dKc)^T * (dyy/dKc)
sum_dyy2TI = 0; % sum of (dyy/dTI)^T * (dyy/dTI)
sum_du2Kc = 0; % sum of (du/dKc)^T * (du/dKc)
sum_du2TI = 0; % sum of (du/dTI)^T * (du/dTI)

for i = 1:50 % number of iterations
    
    out = sim('CA2_model.slx');

    P = 8.5e-7 / (150 * s + 2); % Plant transfer function
    C = Kc * (1 + 1/(s * TI)); % Controller transfer function

    % simulate the controller output and plant response
    u = out.u.data; % PI controller output
    y = out.y.data; % Process output response
    r = out.r.data;
    time = out.y.time;
    
    for t = 1:length(time)
        % Calculate the gradients using numerical differentiation
        ye = -y(t);
        ue = -u(t);
        yy = y(t) - r(t); % thickness error

        dyy_dKc = (1/Kc) * ye;
        % dyy_dTI = (1/(TI * (s*TI + 1))) * ye;
        dyy_dTI = (1/TI) * ye; % Calculate at s=0;
        du_dKc = (1/Kc) * ue;
        % du_dTI = (1/(TI * (s*TI + 1))) * ue;
        du_dTI = (1/TI) * ue;

        % Calculate all sums
        sum_yydyyKc = sum_yydyyKc + yy * dyy_dKc; % sum of yy*(dyy/dKc)
        sum_yydyyTI = sum_yydyyTI + yy * dyy_dTI; % sum of yy*(dyy/dTI)

        sum_uduKc = sum_uduKc + u(t) * du_dKc; % sum of u*(du/dKc)
        sum_uduTI = sum_uduTI + u(t) * du_dTI; % sum of u*(du/dTI)

        sum_dyy2Kc = sum_dyy2Kc +  dyy_dKc.' * dyy_dKc;   % sum of (dyy/dKc)^T * (dyy/dKc)
        sum_dyy2TI = sum_dyy2TI + dyy_dTI.' * dyy_dTI; % sum of (dyy/dTI)^T * (dyy/dTI)
        sum_du2Kc = sum_du2Kc + du_dKc.' * du_dKc; % sum of (du/dKc)^T * (du/dKc)
        sum_du2TI = sum_du2TI + du_dTI.' * du_dTI; % sum of (du/dTI)^T * (du/dTI)
    end
    
    % Gradient of the cost function J
    J_prime_Kc = (sum_yydyyKc + eta * sum_uduKc) / length(time);
    J_prime_TI = (sum_yydyyTI + eta * sum_uduTI) / length(time);
    
    % Positive definite matrix R
    R_Kc = (sum_dyy2Kc + eta * sum_du2Kc) / length(time);
    R_TI = (sum_dyy2TI + eta * sum_du2TI) / length(time);

    
    % Update controller parameters using the gradient
    Kc = Kc - gamma * inv(R_Kc) * J_prime_Kc;
    TI = TI - gamma * inv(R_TI) * J_prime_TI;
    
    % Display current controller parameters and error
    fprintf('Iteration %d: Kc = %.2f, TI = %.2f, Error = %.2f nm\n', i, Kc, TI, yy);
end 
