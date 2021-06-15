tic
close all; clear all; clc;

inits; 
global param_counter;
% cd('d_modeling'); % redundant but necessary
% for j = 1:50
%     % model d
%     cd('../d_modeling');
%     d_modeling;
% 
%     % model vdot
%     cd('../vdot_modeling');
%     vdot_modeling;
% 
%     % model theta
%     cd('../theta_modeling');
%     theta_modeling;
%     
%     close all;
% end
%

for param_counter = 1:50
    
    cd('d_modeling');
    load d_modelling_sigma_coh_list;
    sigma_coh = d_modelling_sigma_coh_list(param_counter,1);
    save sigma_coh sigma_coh
    % d goodness of fit
    cd('d_goodness_of_fit');
    d_goodness_of_fit;

    % vdot goodness of fit
    cd('../../vdot_modeling');
    
    load('vdot_kappa_coh_list');
    kappa_coh = vdot_kappa_coh_list(param_counter, 1);
    save vdot_kappa_coh kappa_coh;
    
    load('vdot_kappa_noncoh_list');
    kappa_noncoh = vdot_kappa_noncoh_list(param_counter, 1);
    save vdot_kappa_noncoh kappa_noncoh;
    
    cd('vdot_goodness_of_fit');
    vdot_goodness_of_fit;

    % theta goodness of fit
    cd('../../theta_modeling');
    
    load('theta_kappa_coh_list');
    kappa_coh = theta_kappa_coh_list(param_counter, 1);
    save theta_kappa_coh kappa_coh;
    
    load('theta_kappa_noncoh_list');
    kappa_noncoh = theta_kappa_noncoh_list(param_counter, 1);
    save theta_kappa_noncoh kappa_noncoh;
    
    cd('theta_goodness_of_fit');
    theta_goodness_of_fit;

    close all;
end

toc
