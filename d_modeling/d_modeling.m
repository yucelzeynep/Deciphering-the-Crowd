global shuffling shuffling_rate d_modeling_bin_size

% dist_4all;
load d_coh 
load d_noncoh

load dmax
load XMAX
load XMIN
load YMAX
load YMIN

% % get a cumulative distribtuion function
% d_cdf_coh = [];
% d_cdf_noncoh = [];
% for i = 1:dmax
%     d_cdf_coh(i) = mean(abs(d_coh)<i);
%     d_cdf_noncoh(i) = mean(abs(d_noncoh)<i);
% end

load edges
load evaluation_pts

% coh model
if(shuffling)
    [sorted, ind] = sort(rand(1, size(d_coh,1)));
    [hist_coh, bin] = histc(d_coh, edges);
    [hist_coh_train, bin] = histc(d_coh(ind(1:round(shuffling_rate* size(d_coh,1)/100)),1), edges);
else
    [hist_coh, bin] = histc(d_coh, edges);
    hist_coh_train = hist_coh;
end

pdf_coh = hist_coh(1:size(hist_coh,1)-1,:)/size(d_coh,1)/d_modeling_bin_size;
pdf_temp = hist_coh_train(1:size(hist_coh_train,1)-1,:)/round(shuffling_rate* size(d_coh,1)/100)/d_modeling_bin_size; % take out the last zero
save pdf_temp pdf_temp

% % in order to make an intelligent guess for starting points of golden
% % section search, plot the error square vs various values of sigma
% sigma_range = 100: 0.05: 1000;
% e_coh = [];
% for i = 1:size(sigma_range,2)
%     s = sigma_range(1,i);
%     f = maxwell_boltzmann(evaluation_pts, s);;
%     e_coh = [e_coh; sum((pdf_coh-f).^2)];
% end
% golden section search parameters
N = 1000; % max number of iterations
a0 = 100; % starting points
b0 = 1000;
% golden section for kappa in coherent case with no log

[sigma_coh, elist_coh] =...
    goldenSection(@maxwell_bolzmann_sqerror, a0, b0, N);
sigma_coh = sigma_coh(size(sigma_coh,1),1);
save sigma_coh sigma_coh

load d_modelling_sigma_coh_list;
d_modelling_sigma_coh_list = [d_modelling_sigma_coh_list; sigma_coh];
save d_modelling_sigma_coh_list d_modelling_sigma_coh_list;

% coh model
load D;
r_coh = 0:0.05:D; % should that be D*sqrt(2)??
y_coh = maxwell_boltzmann(r_coh, sigma_coh);

% noncoh model
% Dp = D - body_size/sqrt(2);
% 
% r = 0:0.05:D*sqrt(2);
% 
% r0 = 0:0.05:body_size;
% y0 = zeros(size(r0));
% 
% ra = body_size:0.05:Dp+body_size;
% r1 = (ra-body_size)/Dp;
% y1 = 1/Dp*2.*r1.*(r1.^2-4.*r1+pi);
% 
% rb = Dp+body_size:0.1:D*sqrt(2);
% r2 = (rb-body_size)/Dp;
% y2 = 1/Dp*2.*r2.*(4*sqrt(r2.^2-1) - (r2.^2+2-pi)-4*atan(sqrt(r2.^2-1)));
% 
% r_noncoh = [r0, ra, rb];
% y_noncoh = [y0, y1, y2];

r_noncoh = 0: 0.05:D*sqrt(2);
y_noncoh = square_line_pick(r_noncoh);


% % estimate cdf from pdf
% for i = 1:dmax
%     d_cdf_coh_model(i) = sum(y_coh(r_coh<i))/sum(y_coh); % because step is 0.05
%     d_cdf_noncoh_model(i) = sum(y_noncoh(r_noncoh<i))/sum(y_noncoh); % because step is 0.05
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% drawings
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load d_3d_coh
load d_3d_noncoh
% plot 3D distance history
plot_d_img(d_3d_coh);
saveas(gcf, '..\..\..\report\figures\d_3d_coh');
saveas(gcf, '..\..\..\report\figures\d_3d_coh.eps', 'psc2');
plot_d_img(d_3d_noncoh);
saveas(gcf, '..\..\..\report\figures\d_3d_noncoh');
saveas(gcf, '..\..\..\report\figures\d_3d_noncoh.eps', 'psc2');
% 
% % plot cdf
% figure;
% plot(d_cdf_noncoh, 'b', 'LineWidth',2);
% hold on;
% plot(d_cdf_coh, 'r', 'LineWidth',2);
% grid on;
% ylim([0 1.1]);
% xlabel('\delta(cm)', 'fontsize', 15);
% ylabel('F(\delta)', 'fontsize', 15);
% set(gca, 'fontsize', 15);
% plot(d_cdf_coh_model, 'r--', 'LineWidth',2);
% plot(d_cdf_noncoh_model, 'b--', 'LineWidth',2);
% legend('Non-coherent', 'Coherent', 'Location','southeast');
% saveas(gcf, '..\..\..\report\figures\d_cdf');
% saveas(gcf, '..\..\..\report\figures\d_cdf.eps', 'psc2');

% 
% % error for each kappa in the range
% figure;
% plot(sigma_range, e_coh, 'linewidth',2);
% grid on;
% xlabel('\sigma', 'fontsize',15);
% ylabel('\epsilon^2', 'fontsize',15);
% set(gca, 'fontsize', 15);
% saveas(gcf, '..\..\..\report\figures\d_sigma_vs_e2_coh');
% saveas(gcf, '..\..\..\report\figures\d_sigma_vs_e2_coh.eps', 'psc2');
% % conclusion is [-550,650] is a good interval


% plot real data and approximations for coherent
figure;
[hist_coh, bin] = histc(d_coh, edges); % real
hist_coh_temp = hist_coh;
pdf_coh = hist_coh_temp/size(d_coh,1)/d_modeling_bin_size;
bar(edges,pdf_coh,'histc');
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.5 0.5 0.5],'EdgeColor','w');
hold on;
plot(r_coh,y_coh, 'r', 'Linewidth', 2); % model
grid on;
xlabel('\delta(mm)', 'fontsize', 15);
ylabel('p(\delta)', 'fontsize', 15);
set(gca, 'fontsize', 15);
legend('Observed', 'Modeled', 'location', 'best');
hold off;
% saveas(gcf, '..\..\..\report\figures\model_fit\d_coh_model_apt');
% saveas(gcf, '..\..\..\report\figures\model_fit\d_coh_model_apt.eps', 'psc2');


% plot real data and approximations for non-coh
figure;
[hist_noncoh, bin] = histc(d_noncoh, edges); % real
hist_noncoh_temp = hist_noncoh;
pdf_noncoh = hist_noncoh_temp/size(d_noncoh,1)/d_modeling_bin_size;
bar(edges,pdf_noncoh,'histc');
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.5 0.5 0.5],'EdgeColor','w');
hold on;
plot(r_noncoh,y_noncoh, 'r', 'Linewidth', 2); % model
ylim([0 3*10^-4])
grid on;
xlabel('\delta(mm)', 'fontsize', 15);
ylabel('p(\delta)', 'fontsize', 15);
set(gca, 'fontsize', 15);
legend('Observed', 'Modeled', 'location', 'best');
hold off;
% saveas(gcf, '..\..\..\report\figures\model_fit\d_noncoh_model_apt');
% saveas(gcf, '..\..\..\report\figures\model_fit\d_noncoh_model_apt.eps', 'psc2');


