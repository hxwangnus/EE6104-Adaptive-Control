clc
clear all;
CA3_velocity_param;

open_system('CA3_model_velocity')
evalc('sim(''CA3_model_velocity'')');