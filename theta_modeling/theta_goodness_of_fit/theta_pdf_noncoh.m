function f_noncoh = theta_pdf_noncoh(theta)

addpath('..\');
load theta_kappa_noncoh;

f_noncoh = exp(kappa_noncoh.*cos(theta))...
    /2/pi/besseli(0, kappa_noncoh);