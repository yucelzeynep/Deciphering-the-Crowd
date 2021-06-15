function y_noncoh = square_line_pick(pts)

load D;
global body_size;

% noncoh model
% plot the model
Dp = D - body_size/sqrt(2);

% r0 = 0:0.05:body_size;
r0 = pts(pts<=body_size);
y0 = zeros(size(r0));

% ra = body_size:0.05:Dp+body_size;
ra = pts(pts>body_size & pts<=Dp+body_size);
r1 = (ra-body_size)/Dp;
y1 = 1/Dp*2.*r1.*(r1.^2-4.*r1+pi);

% rb = Dp+body_size:0.1:D*sqrt(2);
rb = pts(pts>Dp+body_size);
r2 = (rb-body_size)/Dp;
y2 = 1/Dp*2.*r2.*(4*sqrt(r2.^2-1) - (r2.^2+2-pi)-4*atan(sqrt(r2.^2-1)));

y_noncoh = [y0(:); y1(:); y2(:)];