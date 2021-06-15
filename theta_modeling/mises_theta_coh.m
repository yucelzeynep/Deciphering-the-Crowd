function y = mises_theta_coh(evaluation_pts, kappa)

y = exp(kappa.*cos(evaluation_pts))./...
    2/pi/besseli(0,kappa);