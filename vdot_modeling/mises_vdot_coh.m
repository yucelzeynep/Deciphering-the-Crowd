function y = mises_vdot_coh(evaluation_pts, kappa)

y = exp(kappa.*evaluation_pts)./...
    pi/besseli(0,kappa)./sqrt(1-evaluation_pts.^2);