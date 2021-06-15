function f_coh = theta_pdf_coh(theta)

addpath('..\');
load theta_kappa_coh;

f_coh = exp(kappa_coh.*cos(theta))...
    /2/pi/besseli(0, kappa_coh);