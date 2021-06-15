function dist_4all

global d_modeling_bin_size;

% the history of the absolute value of distance for coherent and
% noncoherent
d_noncoh= [];
d_coh = [];

% the history of the distance along x and y dimensions for coherent and
% noncoherent
dx_noncoh = [];
dy_noncoh = [];
dx_coh = [];
dy_coh = [];

% initialize these matrices to all zeros. increment an entry by one,
% whenever a distance is observed at that index.
d_3d_noncoh = [];
d_3d_coh = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% get xmax xmin ymax ymin
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
XMAX = []; 
XMIN = [];
YMAX = [];
YMIN = [];
for i = 1:15
    part_number = i;

    % load coordinates, time start, features
    load(['..\..\..\data\apita_dataset\smooth_nonrepeating\part', num2str(part_number),'_smooth_nonrepeating_100msec'], 'b'); % feats
    a = b;
    xcoord = a(:,3);
    ycoord = a(:,4);
    xmin = min(xcoord);
    xmax = max(xcoord);
    ymin = min(ycoord);
    ymax = max(ycoord);
    clear a b xcoord ycoord

    if(isempty(XMIN) || XMIN > xmin)        XMIN = xmin;    end
    if(isempty(XMAX) || XMAX < xmax)        XMAX = xmax;    end
    if(isempty(YMIN) || YMIN > ymin)        YMIN = ymin;    end
    if(isempty(YMAX) || YMAX < ymax)        YMAX = ymax;    end
end

save XMAX XMAX; 
save YMAX YMAX;
save XMIN XMIN;
save YMIN YMIN;
D = mean((XMAX-XMIN), (YMAX-YMIN)); % this is the mean of x dimension and y dimension
save D D

dmax = ceil(sqrt((XMIN-XMAX)^2 + (YMIN-YMAX)^2));
dxmax = ceil(XMAX-XMIN);
dymax = ceil(YMAX-YMIN);

save dmax dmax
edges = 0: d_modeling_bin_size : dmax;
evaluation_pts = mean([[edges, 0]; [0, edges]], 1);
evaluation_pts = evaluation_pts(2:size(evaluation_pts,2)-1)';
save edges edges;
save evaluation_pts evaluation_pts;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% initalize dist images to zeros
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Nx = ceil(dxmax/d_modeling_bin_size);
Ny = ceil(dymax/d_modeling_bin_size);
if(isempty(d_3d_noncoh))
    d_3d_noncoh = zeros(2*Nx, 2*Ny);
end
if(isempty(d_3d_coh))
    d_3d_coh    = zeros(2*Nx,2*Ny);
end


for i = 1:15
    part_number = i;

    % load coordinates, time start, features
    load(['..\..\..\data\apita_dataset\smooth_nonrepeating\part', num2str(part_number),'_smooth_nonrepeating_100msec'], 'b'); % feats
    a = b;
    % load id, vx, vy...
    load(['..\..\..\data\apita_dataset\velocity\part', num2str(part_number),'_velocity'],'ids', 't_start', 't_end');
    % load type labels
    load(['..\..\..\data\apita_dataset\labels\labels', num2str(part_number)]);
    % load ids which overlap in time
    load(['..\..\..\data\apita_dataset\overlaps\overlapping', num2str(part_number)]);
    % load pairs id couples
    load(['..\..\..\data\apita_dataset\pairs\pairs', num2str(part_number)]);

    timestarts = [ids t_start t_end ];

    Nids = max(ids);
    
    for j = 1:size(overlapping,1)
        id1 = overlapping(j,1);
        label1 = labels(labels(:,1) == id1, 2);
        time_start1 = timestarts(timestarts(:,1) == id1, 2);

        overlappers = nonzeros(overlapping(j, 2:30));

        for k = 1:size( overlappers ,1 )

            id2 = overlappers(k,1);
            label2 = labels(labels(:,1) == id2, 2);
            time_start2 = timestarts(timestarts(:,1) == id2, 2);

            %% get distance history for this pair. they can be coherent or
            %% non-coherent
            [d_hist, dx_hist, dy_hist, isrelevant] = distance_history(...
                a,...
                id1, id2,...
                time_start1, time_start2);

            % iscoherent
            [iscoherent, true_label] = get_coh_label(pairs, id1, id2);

            %% append this distance histories to coh or noncoh arrays
            if(~isempty(d_hist))
                if(iscoherent)
                    d_coh = [d_coh; d_hist];
                    dx_coh = [dx_coh; dx_hist];
                    dy_coh = [dy_coh; dy_hist];

                    %% make a bin of every bin_size points
                    for ii = 1:size(dx_hist,1)
                        d_3d_coh(...
                            ceil((dx_hist(ii,1)+(dxmax))/d_modeling_bin_size),...
                            ceil((dy_hist(ii,1)+(dymax))/d_modeling_bin_size)) = ...
                            d_3d_coh(...
                            ceil((dx_hist(ii,1)+(dxmax))/d_modeling_bin_size),...
                            ceil((dy_hist(ii,1)+(dymax))/d_modeling_bin_size))+ 1;
                    end

                else
                    % otherwise means it is not noncoh, not coherent
                    % entity.
                    d_noncoh = [d_noncoh; d_hist];
                    dx_noncoh = [dx_noncoh; dx_hist];
                    dy_noncoh = [dy_noncoh; dy_hist];

                    % make a bin of every #d_modeling_bin_size points
                    for ii = 1:size(dx_hist,1)
                        d_3d_noncoh(...
                            ceil((dx_hist(ii,1)+(dxmax))/d_modeling_bin_size),...
                            ceil((dy_hist(ii,1)+(dymax))/d_modeling_bin_size)) = ...
                            d_3d_noncoh(...
                            ceil((dx_hist(ii,1)+(dxmax))/d_modeling_bin_size),...
                            ceil((dy_hist(ii,1)+(dymax))/d_modeling_bin_size))+ 1;
                    end
                end
            end
        end
    end
end

save d_3d_coh d_3d_coh
save d_3d_noncoh d_3d_noncoh
save d_coh d_coh
save d_noncoh d_noncoh
save dx_coh dx_coh
save dy_coh dy_coh
  