function  y_coh =  maxwell_bolzmann_sqerror(sigma)

load pdf_temp
load evaluation_pts

temp =  maxwell_boltzmann(evaluation_pts, sigma);

y_coh = sum((pdf_temp - temp).^2);

