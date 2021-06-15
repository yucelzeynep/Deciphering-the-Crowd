% function d_goodness_of_fit(bin_size)
tic
addpath('..\');

% log likelihood list for coh and non-coh pairs
v_ll_list_coh_global = [];
v_ll_list_coh_local_min = [];
v_ll_list_coh_local_max = [];

v_ll_list_noncoh_global = [];
v_ll_list_noncoh_local_min = [];
v_ll_list_noncoh_local_max = [];

% kullback leibler divergence list for coh and non-coh pairs
q2p_rho_v_coh = [];
p2q_rho_v_coh = [];
q2p_rho_v_noncoh = [];
p2q_rho_v_noncoh = [];

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

            [v_dot, theta] = dot_product_of_velocities_modified(...
                time_start1, time_start2,...
                velocity1, velocity2);

            % iscoherent
            [iscoherent, true_label] = get_coh_label(pairs, id1, id2);

            %% append this vdot histories to coh or noncoh arrays
            if(~isempty(v_dot))

                % log likelihood ratios (global)
                v_ll_coh_global    = sum(log(vdot_pdf_coh(v_dot)));
                v_ll_noncoh_global = sum(log(vdot_pdf_noncoh(v_dot)));

                % log likelihood max (local)
                v_ll_coh_local_max    = max(log(vdot_pdf_coh(v_dot)));
                v_ll_noncoh_local_max = max(log(vdot_pdf_noncoh(v_dot)));

                % log likelihood min (local)
                v_ll_coh_local_min    = min(log(vdot_pdf_coh(v_dot)));
                v_ll_noncoh_local_min = min(log(vdot_pdf_noncoh(v_dot)));

                % uncertainity
                [q2p_rho_v, p2q_rho_v] = v_uncertainity(v_dot);

                if(iscoherent)
                    v_ll_list_coh_global = [v_ll_list_coh_global; v_ll_coh_global, v_ll_noncoh_global];
                    v_ll_list_coh_local_min  = [v_ll_list_coh_local_min;  v_ll_coh_local_min,  v_ll_noncoh_local_min];
                    v_ll_list_coh_local_max = [v_ll_list_coh_local_max; v_ll_coh_local_max,  v_ll_noncoh_local_max];

                    q2p_rho_v_coh = [q2p_rho_v_coh; q2p_rho_v];
                    p2q_rho_v_coh = [p2q_rho_v_coh; p2q_rho_v];
                else
                    v_ll_list_noncoh_global = [v_ll_list_noncoh_global; v_ll_coh_global, v_ll_noncoh_global];
                    v_ll_list_noncoh_local_min  = [v_ll_list_noncoh_local_min;  v_ll_coh_local_min,  v_ll_noncoh_local_min];
                    v_ll_list_noncoh_local_max = [v_ll_list_noncoh_local_max; v_ll_coh_local_max,  v_ll_noncoh_local_max];

                    q2p_rho_v_noncoh = [q2p_rho_v_noncoh; q2p_rho_v];
                    p2q_rho_v_noncoh = [p2q_rho_v_noncoh; p2q_rho_v];
                end
            end
        end
    end
end

save v_ll_list_coh_global v_ll_list_coh_global
save v_ll_list_coh_local_min  v_ll_list_coh_local_min
save v_ll_list_coh_local_max v_ll_list_coh_local_max

save v_ll_list_noncoh_global v_ll_list_noncoh_global
save v_ll_list_noncoh_local_min  v_ll_list_noncoh_local_min
save v_ll_list_noncoh_local_max v_ll_list_noncoh_local_max

save q2p_rho_v_coh q2p_rho_v_coh
save p2q_rho_v_coh p2q_rho_v_coh
save q2p_rho_v_noncoh q2p_rho_v_noncoh
save p2q_rho_v_noncoh p2q_rho_v_noncoh




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawings
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot((v_ll_list_noncoh_global(:,1)), (v_ll_list_noncoh_global(:,2)), '.');
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
saveas(gcf, '..\..\..\..\report\figures\vdot_goodness_of_fit_loglikelihood_noncoh');
saveas(gcf, '..\..\..\..\report\figures\vdot_goodness_of_fit_loglikelihood_noncoh.eps', 'psc2');

figure;
plot((v_ll_list_coh_global(:,1)), (v_ll_list_coh_global(:,2)), '.');
grid on;
hold on;
a = xlim;
b = ylim;
t0 = max([a(1) b(1)]);
tf = min([a(2) b(2)]);
h = line(t0:0.01:tf, t0:0.01:tf);
set(h, 'color', 'r', 'LineWidth', 2);
saveas(gcf, '..\..\..\..\report\figures\vdot_goodness_of_fit_loglikelihood_coh');
saveas(gcf, '..\..\..\..\report\figures\vdot_goodness_of_fit_loglikelihood_coh.eps', 'psc2');
