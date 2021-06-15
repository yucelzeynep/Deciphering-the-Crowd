function [iscoherent, true_label] = get_coh_label(pairs, id1, id2)

iscoherent = 0;
true_label = 0; % non-coherent

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% coh or non-coh wrt ground truth
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if((~isempty(nonzeros((pairs(:,2) == id1))) &&...
        (~isempty(nonzeros((pairs((pairs(:,2)==id1), 3)==id2))))) ||...
        (~isempty(nonzeros((pairs(:,3) == id1))) &&...
        (~isempty(nonzeros((pairs((pairs(:,3)==id1), 2)==id2))))))
    % coherent
    true_label = 1;
    iscoherent = 1;

    % type of coh
    if(~isempty(nonzeros(pairs(:,2) == id1)))
        if(~isempty(nonzeros(pairs(pairs(:,2) == id1,3) == id2)))
            if(pairs(pairs(:,2) == id1 & pairs(:,3) == id2, 1) == 1)
                % side
                true_label = 1.1;
                iscoherent = 1;
            end
        end
    end
    if(~isempty(nonzeros(pairs(:,3) == id1)))
        if(~isempty(nonzeros(pairs(pairs(:,3) == id1,2) == id2)))
            if(pairs(pairs(:,3) == id1 & pairs(:,2) == id2, 1) == 1)
                % side
                true_label = 1.1;
                iscoherent = 1;
            end
        end
    end
    if(~isempty(nonzeros(pairs(:,2) == id1&...
            pairs(:,3) == id2)))
        if(...
                (pairs(pairs(:,2) == id1 & pairs(:,3) == id2,1) == 3 ||...
                pairs(pairs(:,2) == id1 & pairs(:,3) == id2,1) == 4 ||...
                pairs(pairs(:,2) == id1 & pairs(:,3) == id2,1) == 5))
            % front
            true_label = 1;
            iscoherent = 1;
        end
    end
    if (~isempty(nonzeros(pairs(:,3) == id1&...
            pairs(:,2) == id2)))
        if(...
                (pairs(pairs(:,3) == id1 & pairs(:,2) == id2,1) == 3 ||...
                pairs(pairs(:,3) == id1 & pairs(:,2) == id2,1) == 4 ||...
                pairs(pairs(:,3) == id1 & pairs(:,2) == id2,1) == 5))
            % rear
            true_label = -1;
            iscoherent = 1;
        end
    end
end
