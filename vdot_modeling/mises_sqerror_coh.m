function y = mises_sqerror_coh(x)

load pdf_temp
load evaluation_pts

f_coh = mises_vdot_coh(evaluation_pts, x);

y = sum((pdf_temp-f_coh).^2);