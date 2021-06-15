function [R, theta] = dot_product_of_velocities_modified(...
    time_start1, time_start2,...
    velocity1, velocity2)

R = [];
theta = [];

% dot product of velocities
for m = 1:size(time_start1)
    if(size(nonzeros(time_start1(m,1) == time_start2),1) ~= 0)
        vx1 = velocity1((velocity1(:,2) == time_start1(m,1)), 4);
        vy1 = velocity1((velocity1(:,2) == time_start1(m,1)), 5);

        vx2 = velocity2((velocity2(:,2) == time_start1(m,1)), 4);
        vy2 = velocity2((velocity2(:,2) == time_start1(m,1)), 5);

        dotpro = vx1*vx2 + vy1*vy2;
        magn = sqrt(vx1*vx1 + vy1*vy1) * sqrt(vx2*vx2 + vy2*vy2);
        theta = [theta; atan2(vy2,vx2)-atan2(vy1,vx1)];

        R = [R; dotpro / magn];
    end
end

theta = mod(theta, 2*pi); % fix it to interval [0, 2*pi]
theta(theta>pi) = theta(theta>pi)-2*pi; % subtract 2*pi from theta>pi, so that the interval is [-pi, pi]
