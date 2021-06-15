
global shuffling shuffling_rate theta_bin_size

edges = -pi: theta_bin_size : pi; 
save edges edges;

% % vdot and theta for every possible pair
% theta_4all();
load theta_coh
load theta_noncoh 

% pdf and histogram for training set
if(shuffling)
    % shuffle coh
    [sorted, ind] = sort(rand(1, size(theta_coh,1)));

    [hist_coh_train, bin] = histc(theta_coh(ind(1:round(shuffling_rate* size(theta_coh,1)/100)),1), edges);
    pdf_coh_train = hist_coh_train/round(shuffling_rate* size(theta_coh,1)/100)/theta_bin_size;
    pdf_coh_train = pdf_coh_train (1:size(pdf_coh_train,1)-1,:);

    % shuffle noncoh
    [sorted, ind] = sort(rand(1, size(theta_noncoh,1)));

    [hist_noncoh_train, bin] = histc(theta_noncoh(ind(1:round(shuffling_rate* size(theta_noncoh,1)/100)),1), edges);
    pdf_noncoh_train = hist_noncoh_train/round(shuffling_rate* size(theta_noncoh,1)/100)/theta_bin_size;
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
    histogram_pdf(theta_bin_size, edges, theta_coh, theta_noncoh);

% the midpoint of each bin is evaluation point
evaluation_pts = mean([[edges, 0]; [0, edges]], 1);
evaluation_pts = evaluation_pts(2:size(evaluation_pts,2)-1)';
save evaluation_pts evaluation_pts;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% % cdf//not used at the moment
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_max = max(max(theta_coh), max(theta_noncoh));
% theta_min = min(min(theta_coh), min(theta_noncoh));
% counter = 1;
% for i = theta_min:0.001:theta_max
%     cdf_noncoh(counter) = mean((theta_noncoh)<i);
%     cdf_coh(counter) = mean((theta_coh)<i);
%     counter = counter + 1;
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %
% % get a plausible range for kappa
% %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % in order to make an intelligent guess for starting points of golden
% % section search, plot the error square vs various values of kappa
% kappa_range = 0: 0.05: 10;
% pdf_temp = pdf_coh_train;
% save pdf_temp pdf_temp
% e_coh = [];
% for i = 1:size(kappa_range,2)
%     k = kappa_range(1,i);
%     e_coh = [e_coh; mises_theta_sqerror_coh(k)];
% end
% 
% pdf_temp = pdf_noncoh_train;
% save pdf_temp pdf_temp
% e_noncoh = [];
% for i = 1:size(kappa_range,2)
%     k = kappa_range(1,i);
%     e_noncoh = [e_noncoh; mises_theta_sqerror_noncoh(k)];
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% golden section search
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% golden section search parameters
N = 1000; % max number of iterations
a0 = 0; % starting points
b0 = 10;

% golden section for kappa in coherent case with no log
pdf_temp = pdf_coh_train;
save pdf_temp pdf_temp
[kappa_coh, elist_coh] =...
    goldenSection(@mises_theta_sqerror_coh, a0, b0, N);
% model
kappa_coh = kappa_coh(size(kappa_coh,1),1);
save theta_kappa_coh kappa_coh
load theta_kappa_coh_list;
theta_kappa_coh_list = [theta_kappa_coh_list;  kappa_coh];
save theta_kappa_coh_list theta_kappa_coh_list;
f_coh = mises_theta_coh(evaluation_pts, kappa_coh);

% golden section search parameters
N = 1000; % max number of iterations
a0 = 0; % starting points
b0 = 1;
% golden section for kappa in non-coherent case with no log
pdf_temp = pdf_noncoh_train;
save pdf_temp pdf_temp
[kappa_noncoh, elist_noncoh] =...
    goldenSection(@mises_theta_sqerror_noncoh, a0, b0, N);
kappa_noncoh = kappa_noncoh(size(kappa_noncoh,1),1);
save theta_kappa_noncoh kappa_noncoh
load theta_kappa_noncoh_list;
theta_kappa_noncoh_list = [theta_kappa_noncoh_list;  kappa_noncoh];
save theta_kappa_noncoh_list theta_kappa_noncoh_list;
f_noncoh = mises_theta_noncoh(evaluation_pts, kappa_noncoh);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% drawings
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% % error for each kappa in the range
% figure;
% plot(kappa_range, e_coh, 'linewidth',2);
% grid on;
% xlabel('\kappa', 'fontsize',15);
% ylabel('\epsilon^2', 'fontsize',15);
% set(gca, 'fontsize', 15);
% saveas(gcf, '..\..\..\report\figures\theta_k_vs_e2_coh');
% saveas(gcf, '..\..\..\report\figures\theta_k_vs_e2_coh.eps', 'psc2');
% figure;
% plot(kappa_range, e_noncoh, 'linewidth',2);
% grid on;
% xlabel('\kappa', 'fontsize',15);
% ylabel('\epsilon^2', 'fontsize',15);
% set(gca, 'fontsize', 15);
% saveas(gcf, '..\..\..\report\figures\theta_k_vs_e2_noncoh');
% saveas(gcf, '..\..\..\report\figures\theta_k_vs_e2_noncoh.eps', 'psc2');
% % conclusion is [0,20] is a good interval

% theta pdf for coh
theta_coh(theta_coh<-pi) = theta_coh(theta_coh<-pi)+2*pi;
theta_coh(theta_coh>pi) = theta_coh(theta_coh>pi)-2*pi;
[n, bin] = histc(theta_coh, edges);
figure; bar(edges,n/size(theta_coh,1)/theta_bin_size,'histc');
h = findobj(gca,'Type','patch');
set(h,'FaceColor',[0.5 0.5 0.5],'EdgeColor','w');
grid on;
hold on;
plot(evaluation_pts, f_coh, 'r', 'linewidth',2);
hold off;
xlabel('\theta(rad)', 'fontsize',15);
ylabel('p(\theta)', 'fontsize',15);
set(gca, 'fontsize', 15);
legend('Observed', 'Modeled', 'location', 'best');
saveas(gcf, '..\..\..\report\figures\model_fit\theta_coh_model_apt');
saveas(gcf, '..\..\..\report\figures\model_fit\theta_coh_model_apt.eps', 'psc2');

% theta pdf for noncoh
theta_noncoh(theta_noncoh<-pi) = theta_noncoh(theta_noncoh<-pi)+2*pi;
theta_noncoh(theta_noncoh>pi) = theta_noncoh(theta_noncoh>pi)-2*pi;
[n, bin] = histc(theta_noncoh, edges);
figure; bar(edges,n/size(theta_noncoh,1)/theta_bin_size,'histc');
h = findobj(gca,'Type','patch');
grid on;
hold on;
plot(evaluation_pts, f_noncoh, 'r', 'linewidth',2);
hold off;
xlabel('\theta(rad)', 'fontsize',15);
ylabel('p(\theta)', 'fontsize',15);
set(gca, 'fontsize', 15);
set(h,'FaceColor',[0.5 0.5 0.5],'EdgeColor','w');
legend('Observed', 'Modeled', 'location', 'best');
saveas(gcf, '..\..\..\report\figures\model_fit\theta_noncoh_model_apt');
saveas(gcf, '..\..\..\report\figures\model_fit\theta_noncoh_model_apt.eps', 'psc2');
