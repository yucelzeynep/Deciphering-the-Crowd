function y_coh = maxwell_boltzmann(pts, sigma)

global body_size;

y_coh = (pts-body_size)./sigma^2.*exp(-(pts-body_size).^2/2/sigma^2);
y_coh(pts<body_size) = 0;
