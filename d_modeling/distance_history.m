function [d_hist, dx_hist, dy_hist, isrelevant] = distance_history(...
    a,...
    id1, id2,...
    time_start1, time_start2)


isrelevant = false;

time_spent_nearby = 0;
total_time = 0;

dx_hist = [];
dy_hist = [];
d_hist = [];


% dot product of velocities
for m = 1:size(time_start1)
    if(size(nonzeros(time_start1(m,1) == time_start2),1) ~= 0)

        dx = a(a(:,1) == time_start1(m, 1) & a(:,2) == id2 , 3) -...
            a(a(:,1) == time_start1(m, 1) & a(:,2) == id1 , 3);
        dy = a(a(:,1) == time_start1(m, 1) & a(:,2) == id2 , 4) - ...
            a(a(:,1) == time_start1(m, 1) & a(:,2) == id1 , 4);;

        d = sqrt(dx*dx + dy*dy);
        
        dx_hist = [dx_hist; dx];
        dy_hist = [dy_hist; dy];
        d_hist = [d_hist; d];

        if( d < 1200)
            time_spent_nearby = time_spent_nearby + 1;
            total_time = total_time + 1;
        else
            total_time = total_time + 1;
        end

    end
end

if( total_time ~= 0 && time_spent_nearby/total_time > 0.7)
    isrelevant = true;
end