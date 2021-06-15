close all; clc;

% 1846 noncoh
% 312 coh

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% how stable are the estimated parameters?
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% d
load d_modeling/d_modelling_sigma_coh_list
plot(d_modelling_sigma_coh_list);
grid on;
xlabel('Iteration number');
ylabel('\sigma');
fprintf('-------------------------------\n');
fprintf('Estimation of sigma for coh\n');
fprintf('Mean: %f\n', mean(d_modelling_sigma_coh_list));
fprintf('Std: %f\n', std(d_modelling_sigma_coh_list));
fprintf('-------------------------------\n');

% vdot
load vdot_modeling/vdot_kappa_coh_list
load vdot_modeling/vdot_kappa_noncoh_list
figure; hold on;
plot(vdot_kappa_coh_list, 'b');
plot(vdot_kappa_noncoh_list, 'r');
legend('\kappa_{coh}', '\kappa_{noncoh}', 'location', 'best');
grid on;
xlabel('Iteration number');
ylabel('\sigma');
fprintf('-------------------------------\n');
fprintf('Estimation of kappa for coh in vdot\n');
fprintf('Mean: %f\n', mean(vdot_kappa_coh_list));
fprintf('Std: %f\n', std(vdot_kappa_coh_list));
fprintf('Estimation of kappa for noncoh in vdot\n');
fprintf('Mean: %f\n', mean(vdot_kappa_noncoh_list));
fprintf('Std: %f\n', std(vdot_kappa_noncoh_list));
fprintf('-------------------------------\n');

% theta
load theta_modeling/theta_kappa_coh_list
load theta_modeling/theta_kappa_noncoh_list
figure; hold on;
plot(theta_kappa_coh_list, 'b');
plot(theta_kappa_noncoh_list, 'r');
legend('\kappa_{coh}', '\kappa_{noncoh}', 'location', 'best');
grid on;
xlabel('Iteration number');
ylabel('\sigma');
fprintf('-------------------------------\n');
fprintf('Estimation of kappa for coh in theta\n');
fprintf('Mean: %f\n', mean(theta_kappa_coh_list));
fprintf('Std: %f\n', std(theta_kappa_coh_list));
fprintf('Estimation of kappa for noncoh in theta\n');
fprintf('Mean: %f\n', mean(theta_kappa_noncoh_list));
fprintf('Std: %f\n', std(theta_kappa_noncoh_list));
fprintf('-------------------------------\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Mean improvement rates
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j = 1:50;
load performance_list

noncoh_d_before = performance_list(j*14-12, 2);
coh_d_before = performance_list(j*14-13, 2);

noncoh_v_before = performance_list(j*14-10, 2);
noncoh_t_before = performance_list(j*14-3, 2);
figure; hold on;
plot(noncoh_v_before, 'b');
plot(noncoh_t_before, 'r');
grid on;
xlabel('Iteration number');
ylabel('Detection of noncoh');
legend('Only v', 'Only t', 'location', 'best');

coh_v_before = performance_list(j*14-11, 2);
coh_t_before = performance_list(j*14-4, 2);
figure; hold on;
plot(coh_v_before, 'b');
plot(coh_t_before, 'r');
grid on;
xlabel('Iteration number');
ylabel('Detection of coh');
legend('Only v', 'Only t', 'location', 'best');

noncoh_v_after = performance_list(j*14-7, 2);
noncoh_t_after = performance_list(j*14, 2);
figure; hold on;
plot(noncoh_v_after, 'b');
plot(noncoh_t_after, 'r');
grid on;
xlabel('Iteration number');
ylabel('Detection of noncoh');
legend('d+v', 'd+t', 'location', 'best');

coh_v_after = performance_list(j*14-8, 2);
coh_t_after = performance_list(j*14-1, 2);
figure; hold on;
plot(coh_v_after, 'b');
plot(coh_t_after, 'r');
grid on;
xlabel('Iteration number');
ylabel('Detection of coh');
legend('d+v', 'd+t', 'location', 'best');

fprintf('-------------------------------\n');
fprintf('Detection rates before and after \n');
fprintf('     d\t                      v\t                         t\t                        d+v\t                   d+t\t\n');
fprintf('Non %f+-%f\t  %f+-%f\t %f+-%f\t %f+-%f\t %f+-%f\t\n', ...
    mean(noncoh_d_before), std(noncoh_d_before),...
    mean(noncoh_v_before), std(noncoh_v_before),...
    mean(noncoh_t_before), std(noncoh_t_before),...
    mean(noncoh_v_after), std(noncoh_v_after),...
    mean(noncoh_t_after), std(noncoh_t_after));
fprintf('Coh %f+-%f\t   %f+-%f\t  %f+-%f\t  %f+-%f\t %f+-%f\t\n',...
    mean(coh_d_before),    std(coh_d_before),...
    mean(coh_v_before),    std(coh_v_before),...
    mean(coh_t_before),    std(coh_t_before),...
    mean(coh_v_after),     std(coh_v_after),...
    mean(coh_t_after),     std(coh_t_after));
fprintf('Tot %f+-%f\t  %f+-%f\t  %f+-%f\t  %f+-%f\t  %f+-%f\t\n', ...
    mean(coh_d_before+noncoh_d_before),  std(coh_d_before+noncoh_d_before),...
    mean(coh_v_before+noncoh_v_before),  std(coh_v_before+noncoh_v_before),...
    mean(coh_t_before+noncoh_t_before),  std(coh_t_before+noncoh_t_before),...
    mean(coh_v_after+noncoh_v_after),    std(coh_v_after+noncoh_v_after),...
    mean(coh_t_after+noncoh_t_after),    std(coh_t_after+noncoh_t_after));
fprintf('-------------------------------\n');


fprintf('-------------------------------\n');
fprintf('Mean improvement rate \n');
fprintf('    v->d+v\t     d->d+v\t     t->d+t\t     d->d+t\t     \n');
fprintf('Non %f\t  %f\t %f\t  %f\t \n',...
    (mean(noncoh_v_after)- mean(noncoh_v_before))/(1846-mean(noncoh_v_before)),...
    (mean(noncoh_v_after)- mean(noncoh_d_before))/(1846-mean(noncoh_d_before)),...
    (mean(noncoh_t_after)- mean(noncoh_t_before))/(1846-mean(noncoh_t_before)),...
    (mean(noncoh_t_after)- mean(noncoh_d_before))/(1846-mean(noncoh_d_before)));
fprintf('Coh %f\t  %f\t  %f\t  %f\t\n',...
    (mean(coh_v_after)- mean(coh_v_before))/(312-mean(coh_v_before)),...
    (mean(coh_v_after)- mean(coh_d_before))/(312-mean(coh_d_before)),...
    (mean(coh_t_after)- mean(coh_t_before))/(312-mean(coh_t_before)),...
    (mean(coh_t_after)- mean(coh_d_before))/(312-mean(coh_d_before)));
fprintf('Tot %f\t  %f\t %f\t  %f\t \n',...
    (mean(noncoh_v_after) + mean(coh_v_after)- mean(noncoh_v_before) - mean(coh_v_before))/(1846 + 312 -mean(noncoh_v_before)- mean(coh_v_before)),...
    (mean(noncoh_v_after) + mean(coh_v_after)- mean(noncoh_d_before) - mean(coh_d_before))/(1846 + 312 -mean(noncoh_d_before)- mean(coh_d_before)),...
    (mean(noncoh_t_after) + mean(coh_t_after)- mean(noncoh_t_before) - mean(coh_t_before))/(1846 + 312 -mean(noncoh_t_before)- mean(coh_t_before)),...
    (mean(noncoh_t_after) + mean(coh_t_after)- mean(noncoh_d_before) - mean(coh_d_before))/(1846 + 312 -mean(noncoh_d_before)- mean(coh_d_before)));
fprintf('-------------------------------\n');



