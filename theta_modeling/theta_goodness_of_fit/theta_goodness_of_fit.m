% function d_goodness_of_fit(bin_size)
tic
addpath('..\');

% log likelihood list for coh and non-coh pairs
theta_ll_list_coh_global = [];
theta_ll_list_coh_local_min = [];
theta_ll_list_coh_local_max = [];

theta_ll_list_noncoh_global = [];
theta_ll_list_noncoh_local_min = [];
theta_ll_list_noncoh_local_max = [];

% kullback leibler divergence list for coh and non-coh pairs
q2p_rho_theta_coh = [];
p2q_rho_theta_coh = [];
q2p_rho_theta_noncoh = [];
p2q_rho_theta_noncoh = [];

for i = 1:15
    part_number = i;

    % load coordinates, time start, features
    load(['..\..\..\..\data\apita_dataset\smooth_nonrepeating\part', num2str(part_number),'_smooth_nonrepeating_100msec'], 'b'); % feats
    a = b;
    % load id, vx, vy...
    load(['..\..\..\..\data\apita_dataset\velocity\part', num2str(part_number),'_velocity'],'ids', 'vx', 'vy', 't_start', 't_end');
    % load type labels
    load(['..\..\..\..\data\apita_dataset\labels\labels', num2str(part_number)]);
    % load ids which overlap in time
    load(['..\..\..\..\data\apita_dataset\overlaps\overlapping', num2str(part_number)]);
    % load pairs id couples
    load(['..\..\..\..\data\apita_dataset\pairs\pairs', num2str(part_number)]);

    velocity = [ids t_start t_end vx vy];

    Nids = max(ids);

    for j = 1:size(overlapping,1)
        id1 = overlapping(j,1);
        label1 = labels(labels(:,1) == id1, 2);
        velocity1 = velocity(velocity(:,1) == id1, :);
        time_start1 = velocity1(:, 2);

        overlappers = nonzeros(overlapping(j, 2:30));

        for k = 1:size( overlappers ,1 )

            id2 = overlappers(k,1);
            label2 = labels(labels(:,1) == id2, 2);
            velocity2 = velocity(velocity(:,1) == id2, :);
            time_start2 = velocity2(:, 2);

            [theta_dot, theta] = dot_product_of_velocities_modified(...
                time_start1, time_start2,...
                velocity1, velocity2);

            % iscoherent
            [iscoherent, true_label] = get_coh_label(pairs, id1, id2);

            %% append this vdot histories to coh or noncoh arrays
            if(~isempty(theta_dot))

                % log likelihood ratios (global)
                theta_ll_coh_global    = sum(log(theta_pdf_coh(theta)));
                theta_ll_noncoh_global = sum(log(theta_pdf_noncoh(theta)));

                % log likelihood max (local)
                theta_ll_coh_local_max    = max(log(theta_pdf_coh(theta)));
                theta_ll_noncoh_local_max = max(log(theta_pdf_noncoh(theta)));

                % log likelihood min (local)
                theta_ll_coh_local_min    = min(log(theta_pdf_coh(theta)));
                theta_ll_noncoh_local_min = min(log(theta_pdf_noncoh(theta)));

                % uncertainity
                [q2p_rho_theta, p2q_rho_theta] = theta_uncertainity(theta_dot);

                if(iscoherent)
                    theta_ll_list_coh_global = [theta_ll_list_coh_global; theta_ll_coh_global, theta_ll_noncoh_global];
                    theta_ll_list_coh_local_min  = [theta_ll_list_coh_local_min;  theta_ll_coh_local_min,  theta_ll_noncoh_local_min];
                    theta_ll_list_coh_local_max = [theta_ll_list_coh_local_max; theta_ll_coh_local_max,  theta_ll_noncoh_local_max];
                    
                    q2p_rho_theta_coh = [q2p_rho_theta_coh; q2p_rho_theta];
                    p2q_rho_theta_coh = [p2q_rho_theta_coh; p2q_rho_theta];
                else
                    theta_ll_list_noncoh_global = [theta_ll_list_noncoh_global; theta_ll_coh_global, theta_ll_noncoh_global];
                    theta_ll_list_noncoh_local_min  = [theta_ll_list_noncoh_local_min;  theta_ll_coh_local_min,  theta_ll_noncoh_local_min];
                    theta_ll_list_noncoh_local_max = [theta_ll_list_noncoh_local_max; theta_ll_coh_local_max,  theta_ll_noncoh_local_max];
                    
                    q2p_rho_theta_noncoh = [q2p_rho_theta_noncoh; q2p_rho_theta];
                    p2q_rho_theta_noncoh = [p2q_rho_theta_noncoh; p2q_rho_theta];
                end
            end
        end
    end
end

save theta_ll_list_coh_global theta_ll_list_coh_global
save theta_ll_list_coh_local_min  theta_ll_list_coh_local_min
save theta_ll_list_coh_local_max theta_ll_list_coh_local_max

save theta_ll_list_noncoh_global theta_ll_list_noncoh_global
save theta_ll_list_noncoh_local_min  theta_ll_list_noncoh_local_min
save theta_ll_list_noncoh_local_max theta_ll_list_noncoh_local_max

save q2p_rho_theta_coh q2p_rho_theta_coh
save p2q_rho_theta_coh p2q_rho_theta_coh
save q2p_rho_theta_noncoh q2p_rho_theta_noncoh
save p2q_rho_theta_noncoh p2q_rho_theta_noncoh



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawings
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot((theta_ll_list_noncoh_global(:,1)), (theta_ll_list_noncoh_global(:,2)), '.');
grid on;
hold on;
a = xlim;
b = ylim;
t0 = max([a(1) b(1)]);
tf = min([a(2) b(2)]);
h = line(t0:0.01:tf, t0:0.01:tf);
set(h, 'color', 'r', 'LineWidth', 2);
xlabel('LL^{c}');
ylabel('LL^{n}');
saveas(gcf, '..\..\..\..\report\figures\theta_goodness_of_fit_loglikelihood_noncoh');
saveas(gcf, '..\..\..\..\report\figures\theta_goodness_of_fit_loglikelihood_noncoh.eps', 'psc2');

figure;
plot((theta_ll_list_coh_global(:,1)), (theta_ll_list_coh_global(:,2)), '.');
grid on;
hold on;
a = xlim;
b = ylim;
t0 = max([a(1) b(1)]);
tf = min([a(2) b(2)]);
h = line(t0:0.01:tf, t0:0.01:tf);
set(h, 'color', 'r', 'LineWidth', 2);
saveas(gcf, '..\..\..\..\report\figures\theta_goodness_of_fit_loglikelihood_coh');
saveas(gcf, '..\..\..\..\report\figures\theta_goodness_of_fit_loglikelihood_coh.eps', 'psc2');
