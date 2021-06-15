function f_noncoh = vdot_pdf_noncoh(vdot)

addpath('..\');
load vdot_kappa_noncoh;

f_noncoh = exp(kappa_noncoh.*vdot)...
    /pi/besseli(0, kappa_noncoh)./sqrt(1-vdot.^2);