clc
clear all;

%%
mdl = "CA1_model";
open_system(mdl);

%%
% plant parameters (1) as given in the description
b0=-0.5;
b1=-1;
a1=0.22;
a2=6.1;
Kp=b0;
Zp=[1 b1/b0];
Rp=[1 a1 a2];

% reference model, parameters are self-defined
tau=1/10;
Rm=[1 1/tau];
Km=1/tau;

% filtering system 1/T(p)
C=0.045;
w=2.47;
T=[1 2*C*w w^2];
t1=T(2);
t2=T(3);

g=50;
Gamma=diag([10000*g,10000*g,1000*g,1000*g,1000*g]);

% theoretical result
[E, F]=deconv(conv(T, Rm), Rp);
Fbar=F/Kp;
Gbar=conv(E, Zp);
G1=Gbar-T;

K=Km/Kp;
% sequence in the model: [r, wu, pwu, wy, pwy]
theta_bar=[K,-G1(3),-G1(2),-Fbar(3),-Fbar(4)]
