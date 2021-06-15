function y_coh = d_pdf_coh(d_hist)

addpath('..\');
load('sigma_coh');

y_coh = maxwell_boltzmann(d_hist, sigma_coh);

% global body_size;
% 
% y_coh = (d_hist-body_size)./sigma_coh^2.*exp(-(d_hist-body_size).^2/2/sigma_coh^2);
%   
% y_coh =  d_hist./sigma_coh^2.*exp(-d_hist.^2/2/sigma_coh^2);



