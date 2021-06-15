% the history of the dot product of velocities for coherent and
% noncoherent

function vdot_4all

vdot_noncoh = [];
vdot_coh = [];

for i = 1:15
    part_number = i;

    % load id, vx, vy...
    load(['..\..\..\data\apita_dataset\velocity\part', num2str(part_number),'_velocity'],'ids', 'vx', 'vy', 't_start', 't_end');
    % load type labels
    load(['..\..\..\data\apita_dataset\labels\labels', num2str(part_number)]);
    % load ids which overlap in time
    load(['..\..\..\data\apita_dataset\overlaps\overlapping', num2str(part_number)]);
    % load pairs id couples
    load(['..\..\..\data\apita_dataset\pairs\pairs', num2str(part_number)]);

    velocity = [ids t_start t_end vx vy];

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

            %% get distance history for this pair. they can be coherent or
            %% non-coherent
            [v_dot, theta] = dot_product_of_velocities_modified(...
                time_start1, time_start2,...
                velocity1, velocity2);

            % iscoherent
            [iscoherent, true_label] = get_coh_label(pairs, id1, id2);

            %% append this distance histories to coh or noncoh arrays
            if(~isempty(v_dot))
                if(iscoherent)
                    vdot_coh = [vdot_coh; v_dot];
                else
                    vdot_noncoh = [vdot_noncoh; v_dot];
                end
            end
        end
    end
end

save vdot_noncoh vdot_noncoh
save vdot_coh vdot_coh