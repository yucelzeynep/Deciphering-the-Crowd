tic
close all; clear all; clc;

inits;

% model d
cd('d_modeling');
d_modeling;

% model vdot
cd('../vdot_modeling');
vdot_modeling;

% model theta
cd('theta_modeling');
theta_modeling;  

% d goodness of fit
cd('d_modeling/d_goodness_of_fit');
d_goodness_of_fit;

% vdot goodness of fit
cd('../../vdot_modeling\vdot_goodness_of_fit');
vdot_goodness_of_fit;

% theta goodness of fit
cd('theta_modeling/theta_goodness_of_fit');
theta_goodness_of_fit;

toc
