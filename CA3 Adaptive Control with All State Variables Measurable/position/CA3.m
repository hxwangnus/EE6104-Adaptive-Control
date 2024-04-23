clc
clear all;
CA3_param;

open_system('plantChange_CA3_model')
evalc('sim(''plantChange_CA3_model'')');