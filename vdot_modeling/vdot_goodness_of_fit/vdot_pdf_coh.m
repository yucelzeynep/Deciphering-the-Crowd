function f_coh = vdot_pdf_coh(vdot)

addpath('..\');
load vdot_kappa_coh;

f_coh = exp(kappa_coh.*vdot)...
    /pi/besseli(0, kappa_coh)./sqrt(1-vdot.^2);