function [hist_coh, hist_noncoh, pdf_coh, pdf_noncoh] = histogram_pdf(bin_size, edges, vdot_coh, vdot_noncoh)

[hist_coh, bin] = histc(vdot_coh, edges);
hist_coh_temp = hist_coh(1:size(hist_coh,1)-1,:); % take out the last zero
pdf_coh = hist_coh_temp/size(vdot_coh,1)/bin_size;

[hist_noncoh, bin] = histc(vdot_noncoh, edges);
hist_noncoh_temp = hist_noncoh(1:size(hist_noncoh,1)-1,:); % take out the last zero
pdf_noncoh = hist_noncoh_temp/size(vdot_noncoh,1)/bin_size;