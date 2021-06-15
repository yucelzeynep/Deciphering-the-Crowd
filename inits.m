
global shuffling shuffling_rate;
global body_size;
global d_modeling_bin_size vdot_modeling_bin_size vddot_modeling_bin_size;
global theta_bin_size phi_bin_size;
global param_counter;
global performance_list;

shuffling = true;
shuffling_rate = 10; % percentage

body_size = 349;

d_modeling_bin_size = 300; % roughly every 300x300 mm is grouped as a bin
vdot_modeling_bin_size = 0.1;
theta_bin_size = 2*pi/100;

% EITHER
% make a list
% d_modelling_sigma_coh_list = [];
% vdot_kappa_coh_list = [];
% vdot_kappa_noncoh_list = [];
% theta_kappa_coh_list = [];
% theta_kappa_noncoh_list = [];
% 
% save d_modeling/d_modelling_sigma_coh_list d_modelling_sigma_coh_list
% save vdot_modeling/vdot_kappa_coh_list vdot_kappa_coh_list
% save vdot_modeling/vdot_kappa_noncoh_list vdot_kappa_noncoh_list
% save theta_modeling/theta_kappa_coh_list theta_kappa_coh_list
% save theta_modeling/theta_kappa_noncoh_list theta_kappa_noncoh_list

% % OR
% % read from a list
% param_counter = 0;
% performance_list = [];
% save performance_list performance_list;

