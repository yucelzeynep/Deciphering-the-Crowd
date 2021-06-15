
global shuffling shuffling_rate vdot_modeling_bin_size 

edges = -1: vdot_modeling_bin_size : 1; 
save edges edges;

% % vdot and theta for every possible pair
% vdot_4all();
load vdot_coh
load vdot_noncoh

% pdf and histogram for training set
if(shuffling)
    % shuffle coh
    [sorted, ind] = sort(rand(1, size(vdot_coh,1)));

    [hist_coh_train, bin] = histc(vdot_coh(ind(1:round(shuffling_rate* size(vdot_coh,1)/100)),1), edges);
    pdf_coh_train = hist_coh_train/round(shuffling_rate* size(vdot_coh,1)/100)/vdot_modeling_bin_size;
    pdf_coh_train = pdf_coh_train (1:size(pdf_coh_train,1)-1,:);

    % shuffle noncoh
    [sorted, ind] = sort(rand(1, size(vdot_noncoh,1)));

    [hist_noncoh_train, bin] = histc(vdot_noncoh(ind(1:round(shuffling_rate* size(vdot_noncoh,1)/100)),1), edges);
    pdf_noncoh_train = hist_noncoh_train/round(shuffling_rate* size(vdot_noncoh,1)/100)/vdot_modeling_bin_size;
    pdf_noncoh_train = pdf_noncoh_train (1:size(pdf_noncoh_train,1)-1,:);

else
    hist_coh_train = hist_coh;
    pdf_coh_train = pdf_coh;
    hist_noncoh_train = hist_noncoh;
    pdf_noncoh_train = pdf_noncoh;
end

% pdf and histogram for whole set
[...
    hist_coh, hist_noncoh,...
    pdf_coh, pdf_noncoh] =...
    histogram_pdf(vdot_modeling_bin_size, edges, vdot_coh, vdot_noncoh);

% the midpoint of each bin is evaluation point
evaluation_pts = mean([[edges, 0]; [0, edges]], 1);
evaluation_pts = evaluation_pts(2:size(evaluation_pts,2)-1)';
save evaluation_pts evaluation_pts;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% % cdf
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% vdot_max = max(max(vdot_coh), max(vdot_noncoh));
% vdot_min = min(min(vdot_coh), min(vdot_noncoh));
% counter = 1;
% for i = vdot_min:0.001:vdot_max
%     cdf_v_noncoh(counter) = mean((vdot_noncoh)<i);
%     cdf_v_coh(counter) = mean((vdot_coh)<i);
%     counter = counter + 1;
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% % get a plausible range for kappa
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % in order to make an intelligent guess for starting points of golden
% % section search, plot the error square vs various values of kappa
% kappa_range = 0: 0.05: 500;
% pdf_temp = pdf_coh_train;
% save pdf_temp pdf_temp
% e_coh = [];
% for i = 1:size(kappa_range,2)
%     k = kappa_range(1,i);
%     e_coh = [e_coh; mises_sqerror_coh(k)];
% end
% 
% pdf_temp = pdf_noncoh_train;
% save pdf_temp pdf_temp
% e_noncoh = [];
% for i = 1:size(kappa_range,2)
%     k = kappa_range(1,i);
%     e_noncoh = [e_noncoh; mises_sqerror_noncoh(k)];
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% golden section search
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% golden section search parameters
N = 100; % max number of iterations
a0 = 0; % starting points
b0 = 12;

% golden section for kappa in coherent case with no log
pdf_temp = pdf_coh_train;
save pdf_temp pdf_temp
[kappa_coh, elist_coh] =...
    goldenSection(@mises_sqerror_coh, a0, b0, N);
% model
kappa_coh = kappa_coh(size(kappa_coh,1),1);
save vdot_kappa_coh kappa_coh
load vdot_kappa_coh_list;
vdot_kappa_coh_list = [vdot_kappa_coh_list;  kappa_coh];
save vdot_kappa_coh_list vdot_kappa_coh_list;
f_coh = mises_vdot_coh(evaluation_pts, kappa_coh);

% golden section search parameters
N = 100; % max number of iterations
a0 = 0; % starting points
b0 = 1;
% golden section for kappa in non-coherent case with no log
pdf_temp = pdf_noncoh_train;
save pdf_temp pdf_temp
[kappa_noncoh, elist_noncoh] =...
    goldenSection(@mises_sqerror_noncoh, a0, b0, N);
kappa_noncoh = kappa_noncoh(size(kappa_noncoh,1),1);
save vdot_kappa_noncoh kappa_noncoh
load vdot_kappa_noncoh_list;
vdot_kappa_noncoh_list = [vdot_kappa_noncoh_list;  kappa_noncoh];
save vdot_kappa_noncoh_list vdot_kappa_noncoh_list;
f_noncoh = mises_vdot_coh(evaluation_pts, kappa_noncoh);

% estimate the cdf from the pdf
counter = 1;
evaluation_pts_temp =  -0.999: 0.001 : 0.999;
f_coh_temp = exp(kappa_coh.*evaluation_pts_temp)...
    /pi/besseli(0, kappa_coh)./sqrt(1-evaluation_pts_temp.^2);
f_noncoh_temp = exp(kappa_noncoh.*evaluation_pts_temp)...
    /pi/besseli(0, kappa_noncoh)./sqrt(1-evaluation_pts_temp.^2);
for i = 1:size(evaluation_pts_temp,2)
    cdf_v_coh_model(counter) = sum((f_coh_temp(1, 1:i)))/sum(f_coh_temp);
    cdf_v_noncoh_model(counter) = sum((f_noncoh_temp(1, 1:i)))/sum(f_noncoh_temp);
    counter = counter + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawings
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % cdf
% figure;
% hold on;
% plot(cdf_v_noncoh, 'linewidth', 2);
% plot(cdf_v_coh, 'r', 'linewidth', 2);
% legend('Non-coherent', 'Coherent');
% plot(cdf_v_noncoh_model, 'b--');
% plot(cdf_v_coh_model, 'r--');
% grid on;
% ylim([0 1.1]);
% ylabel('F_{cos(\theta)}(\alpha)', 'fontsize',15);
% xlabel('\alpha', 'fontsize',15);
% set(gca, 'fontsize', 15);
% tl = get(gca, 'XtickLabel');
% tl = round((vdot_min : (vdot_max-vdot_min)/(size(tl,1)-1):vdot_max)*100)/100;
% set(gca, 'Xticklabel', num2str(tl'));
% legend('Non-coherent', 'Coherent', 'Location','northwest');
% saveas(gcf, '..\..\..\report\figures\cdf_vdot');
% saveas(gcf, '..\..\..\report\figures\cdf_vdot.eps', 'psc2');
% 
% % error for each kappa in the range
% figure;
% plot(kappa_range, e_coh, 'linewidth',2);
% grid on;
% xlabel('\kappa', 'fontsize',15);
% ylabel('\epsilon^2', 'fontsize',15);
% set(gca, 'fontsize', 15);
% saveas(gcf, '..\..\..\report\figures\vdot_k_vs_e2_coh');
% saveas(gcf, '..\..\..\report\figures\vdot_k_vs_e2_coh.eps', 'psc2');
% figure;
% plot(kappa_range, e_noncoh, 'linewidth',2);
% grid on;
% xlabel('\kappa', 'fontsize',15);
% ylabel('\epsilon^2', 'fontsize',15);
% set(gca, 'fontsize', 15);
% saveas(gcf, '..\..\..\report\figures\vdot_k_vs_e2_noncoh');
% saveas(gcf, '..\..\..\report\figures\vdot_k_vs_e2_noncoh.eps', 'psc2');
% % conclusion is [-20,20] is a good interval

% coh
figure;
bar(edges(1:size(edges,2)),hist_coh/size(vdot_coh,1)/vdot_modeling_bin_size,'histc');
h = findobj(gca,'Type','patch');
grid on;
set(h,'FaceColor',[0.5 0.5 0.5],'EdgeColor','w');
xlabel('cos(\theta)', 'fontsize',15);
ylabel('p(cos(\theta))', 'fontsize',15);
set(gca, 'fontsize', 15);
hold on;
plot(evaluation_pts, f_coh, 'r', 'linewidth',2);
hold off;
xlim([-1 1]);
legend('Observed', 'Modeled', 'location', 'northwest');
saveas(gcf, '..\..\..\report\figures\vdot_pdf_coh');
saveas(gcf, '..\..\..\report\figures\vdot_pdf_coh.eps', 'psc2');

%noncoh
figure;
bar(edges(1:size(edges,2)),hist_noncoh/size(vdot_noncoh,1)/vdot_modeling_bin_size,'histc');
h = findobj(gca,'Type','patch');
grid on;
set(h,'FaceColor',[0.5 0.5 0.5],'EdgeColor','w');
xlabel('cos(\theta)', 'fontsize',15);
ylabel('p(cos(\theta))', 'fontsize',15);
set(gca, 'fontsize', 15);
hold on;
plot(evaluation_pts, f_noncoh, 'r', 'linewidth',2);
hold off;
xlim([-1 1]);
legend('Observed', 'Modeled', 'location', 'northwest');
saveas(gcf, '..\..\..\report\figures\vdot_pdf_noncoh');
saveas(gcf, '..\..\..\report\figures\vdot_pdf_noncoh.eps', 'psc2');

