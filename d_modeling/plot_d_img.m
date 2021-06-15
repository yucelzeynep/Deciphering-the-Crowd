function plot_d_img(image_mat)

% the image data you want to show as a plane.
planeimg = abs(image_mat);
 
% scale image between [0, 255] in order to use a custom color map for it.
scaledimg = (floor(((planeimg) ./ ...
    (max(max(planeimg)))) * 255)); % perform scaling
 
% convert the image to a true color image with the jet colormap.
colorimg = ind2rgb(scaledimg,jet(256));
 
% set hold on so we can show multiple plots / surfs in the figure.
figure; 
hold on;
 
% do a normal surface plot.
surf(image_mat,'edgecolor','none');
shading interp
 
% desired z position of the image plane.
imgzposition = -3*max(max(image_mat));
 
% plot the image plane using surf.
surf([1 size(image_mat, 1)],[1 size(image_mat,2)],...
    repmat(imgzposition, [2 2]),...
    colorimg,'facecolor','texture');
 
% set the view.
view(60,25);
xlim([1,size(image_mat, 1)]);
ylim([1,size(image_mat, 2)]);
grid on;
xlabel('\delta^x(mm)', 'fontsize', 15);
ylabel('\delta^y(mm)', 'fontsize', 15);
set(gca, 'fontsize', 15);
zlabel('Number of instances');

ztl = get(gca,'zticklabel');
ztl(str2num(ztl)<0, :) = ' ';
set(gca, 'zticklabel', ztl);
drawnow;

load XMIN
load XMAX
load YMIN
load YMAX
numberofxticks = 4;

xt = 1:floor((max(xlim)-min(xlim))/numberofxticks):max(xlim)-min(xlim);
xtl = -(XMAX-XMIN) : 2*(XMAX-XMIN)/numberofxticks : (XMAX-XMIN);
set(gca, 'xtick', xt);
set(gca, 'xticklabel', xtl);

yt = 1:floor((max(ylim)-min(ylim))/numberofxticks):max(ylim)-min(ylim);
ytl = -(YMAX-YMIN) : 2*(YMAX-YMIN)/numberofxticks : (YMAX-YMIN);
set(gca, 'ytick', yt);
set(gca, 'yticklabel', ytl);

drawnow;
