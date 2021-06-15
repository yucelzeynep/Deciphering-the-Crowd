function y = mises_theta_sqerror_noncoh(x)

load pdf_temp
load evaluation_pts

f_noncoh = mises_theta_noncoh(evaluation_pts, x);

y = sum((pdf_temp-f_noncoh).^2);