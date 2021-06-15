addpath('..\');

% log likelihood list for coh and non-coh pairs
d_ll_list_coh_global = [];
d_ll_list_coh_local_max = [];
d_ll_list_coh_local_min = [];
d_ll_list_noncoh_global = [];
d_ll_list_noncoh_local_max = [];
d_ll_list_noncoh_local_min = [];

% kullback leibler divergence list for coh and non-coh pairs
q2p_rho_d_coh = [];
p2q_rho_d_coh = [];
q2p_rho_d_noncoh = [];
p2q_rho_d_noncoh = [];

for i = 1:15
    part_number = i;

    % load coordinates, time start, features
    load(['..\..\..\..\data\apita_dataset\smooth_nonrepeating\part', num2str(part_number),'_smooth_nonrepeating_100msec'], 'b'); % feats
    a = b;
    % load id, vx, vy...
    load(['..\..\..\..\data\apita_dataset\velocity\part', num2str(part_number),'_velocity'],'ids', 't_start', 't_end');
    % load type labels
    load(['..\..\..\..\data\apita_dataset\labels\labels', num2str(part_number)]);
    % load ids which overlap in time
    load(['..\..\..\..\data\apita_dataset\overlaps\overlapping', num2str(part_number)]);
    % load pairs id couples
    load(['..\..\..\..\data\apita_dataset\pairs\pairs', num2str(part_number)]);

    velocity = [ids t_start t_end];

    Nids = max(ids);

    for j = 1:size(overlapping,1)
        id1 = overlapping(j,1);
        label1 = labels(labels(:,1) == id1, 2);
        time_start1 = velocity(velocity(:,1) == id1, 2);

        overlappers = nonzeros(overlapping(j, 2:30));

        for k = 1:size( overlappers ,1 )

            id2 = overlappers(k,1);
            label2 = labels(labels(:,1) == id2, 2);
            time_start2 = velocity(velocity(:,1) == id2, 2);

            %% get distance history for this pair. they can be coherent or
            %% non-coherent
            [d_hist] = distance_history(...
                a,...
                id1, id2,...
                time_start1, time_start2);

            % get ground truth, i.e. iscoherent
            [iscoherent, true_label] = get_coh_label(pairs, id1, id2);

            %% append this distance histories to coh or noncoh arrays
            if(~isempty(d_hist))

                % log likelihood ratios (global)
                d_ll_coh_global    = sum(log(d_pdf_coh(d_hist)));
                d_ll_noncoh_global = sum(log(d_pdf_noncoh(d_hist)));

                % max likelihood  (local)
                d_ll_coh_local_max    = max(log(d_pdf_coh(d_hist)));
                d_ll_noncoh_local_max = max(log(d_pdf_noncoh(d_hist)));

                % min likelihood  (local)
                d_ll_coh_local_min    = min(log(d_pdf_coh(d_hist)));
                d_ll_noncoh_local_min = min(log(d_pdf_noncoh(d_hist)));

                % uncertainity
                [q2p_rho_d, p2q_rho_d] = d_uncertainity(d_hist);

                if(iscoherent)
                    d_ll_list_coh_global     = [d_ll_list_coh_global;     d_ll_coh_global,     d_ll_noncoh_global];
                    d_ll_list_coh_local_max  = [d_ll_list_coh_local_max;  d_ll_coh_local_max,  d_ll_noncoh_local_max];
                    d_ll_list_coh_local_min  = [d_ll_list_coh_local_min;  d_ll_coh_local_min,  d_ll_noncoh_local_min];

                    q2p_rho_d_coh = [q2p_rho_d_coh; q2p_rho_d];
                    p2q_rho_d_coh = [p2q_rho_d_coh; p2q_rho_d];
                else
                    d_ll_list_noncoh_global     = [d_ll_list_noncoh_global;     d_ll_coh_global,     d_ll_noncoh_global];
                    d_ll_list_noncoh_local_max  = [d_ll_list_noncoh_local_max;  d_ll_coh_local_max,  d_ll_noncoh_local_max];
                    d_ll_list_noncoh_local_min  = [d_ll_list_noncoh_local_min;  d_ll_coh_local_min,  d_ll_noncoh_local_min];

                    q2p_rho_d_noncoh = [q2p_rho_d_noncoh; q2p_rho_d];
                    p2q_rho_d_noncoh = [p2q_rho_d_noncoh; p2q_rho_d];
                end
            end
        end
    end
end

save d_ll_list_noncoh_global     d_ll_list_noncoh_global
save d_ll_list_noncoh_local_max  d_ll_list_noncoh_local_max
save d_ll_list_noncoh_local_min  d_ll_list_noncoh_local_min

save d_ll_list_coh_global     d_ll_list_coh_global
save d_ll_list_coh_local_max  d_ll_list_coh_local_max
save d_ll_list_coh_local_min  d_ll_list_coh_local_min

save q2p_rho_d_coh q2p_rho_d_coh
save p2q_rho_d_coh p2q_rho_d_coh
save q2p_rho_d_noncoh q2p_rho_d_noncoh
save p2q_rho_d_noncoh p2q_rho_d_noncoh

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawings
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
plot(-(d_ll_list_noncoh_global(:,1)), -(d_ll_list_noncoh_global(:,2)), '.');
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
saveas(gcf, '..\..\..\..\report\figures\d_goodness_of_fit_loglikelihood_noncoh');
saveas(gcf, '..\..\..\..\report\figures\d_goodness_of_fit_loglikelihood_noncoh.eps', 'psc2');

figure;
plot(-(d_ll_list_coh_global(:,1)), -(d_ll_list_coh_global(:,2)), '.');
grid on;
hold on;
a = xlim;
b = ylim;
t0 = max([a(1) b(1)]);
tf = min([a(2) b(2)]);
h = line(t0:0.01:tf, t0:0.01:tf);
set(h, 'color', 'r', 'LineWidth', 2);
saveas(gcf, '..\..\..\..\report\figures\d_goodness_of_fit_loglikelihood_coh');
saveas(gcf, '..\..\..\..\report\figures\d_goodness_of_fit_loglikelihood_coh.eps', 'psc2');
