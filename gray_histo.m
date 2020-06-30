%filterwhee%%
clear all
close all
clear img img_sub img_thresh img_multi indx_particle 

%% set figure properties

set(groot,'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');


set(0,'DefaultAxesFontSize',55);
set(0,'DefaultTextFontSize', 60)
set(0,'DefaultLegendFontSize',80);
set(0,'DefaultLineMarkerSize', 10)
set(0,'DefaultLineLineWidth', 5)
% set(0,'DefaultMarkerMarkerSize', 1)
set(0,'defaultUicontrolFontName', 'Arial')
set(0,'defaultUitableFontName', 'Arial')
set(0,'defaultAxesFontName', 'Arial')
set(0,'defaultTextFontName', 'Arial')
set(0,'defaultUipanelFontName', 'Arial')
%% Loading info

load('filter.mat');
load('maximg.mat');
% load('frames.mat');


bun_num = 5000;

% Loading image 1003

img = imread('IMG1003.tif');


%% plotting raw image

fig = figure('name', 'normal image',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';

[counts_raw, grayLevels_raw] = imhist(img,bun_num);
bar(grayLevels_raw, counts_raw, 'FaceColor', 'b', 'BarWidth', 0.7);
xlim([0 255])
ylim([100 5e06])
% xlabel('Gray value','Interpreter','latex')

ylabel('Frequency (log scale)','Interpreter','latex')
set(gca,'YMinorTick','off','YGrid', 'on','YScale','log','YTick',...
    [1 10 100 1000 10000 100000 1000000]);
annotation('textbox',...
   [0.85 0.78 0.04 0.08],...
    'String','A',...
    'LineWidth',5,...
    'Interpreter','latex',...
    'HorizontalAlignment','center',...
    'FontSize',100,...
    'FitBoxToText','off');

% F    = getframe(fig);
% imwrite(F.cdata, 'raw_image.png', 'png')
% saveas(fig,'raw_image.eps', 'epsc')
%%

% subtracting image by maximage
filt = uint8(filt);
img_sub = uint8(max(double(maximg) - double(img(:,:,1)),0)).*filt;
fig = figure('name', 'subtracted image',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';

[counts_sub, grayLevels_sub] = imhist(img_sub,bun_num);
bar(grayLevels_sub, counts_sub, 'FaceColor', 'b', 'BarWidth', 0.7);

xlim([0 255])
ylim([100 5e06])
% xlabel('Gray value','Interpreter','latex')
% ylabel('Frequency (log scale)','Interpreter','latex')
set(gca,'YMinorTick','off','YGrid', 'on','YScale','log','YTick',...
    [1 10 100 1000 10000 100000 1000000]);
annotation('textbox',...
   [0.85 0.78 0.04 0.08],...
    'String','B',...
    'LineWidth',5,...
    'Interpreter','latex',...
    'HorizontalAlignment','center',...
    'FontSize',100,...
    'FitBoxToText','off');

hold on
plot([9 9],[100 5e06],'k.-','LineWidth',4)

annotation('textbox',...
    [0.16 0.825 0.33 0.085],...
    'FontSize',100,...
    'LineWidth',3,...
    'String',{'Filtering threshold'});


% F    = getframe(fig);
% imwrite(F.cdata, 'subtracted_image.png', 'png')
% saveas(fig,'subtracted_image.eps', 'epsc')



%% Applying threshhold

thresh = 9;
img_thresh = img_sub;
img_thresh(img_thresh<thresh) =0;
indx_particle = find(img_thresh>=thresh);
img_thresh(indx_particle) = (img_thresh(indx_particle)-thresh);

fig = figure('name', 'Thresholded image',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';

[counts_thresh, grayLevels_thresh] = imhist(img_thresh,bun_num);
bar(grayLevels_thresh, counts_thresh, 'FaceColor', 'b', 'BarWidth', 0.7);
xlim([0 255])
ylim([100 5e06])
xlabel('Gray value','Interpreter','latex')
ylabel('Frequency (log scale)','Interpreter','latex')

set(gca,'YMinorTick','off','YGrid', 'on','YScale','log','YTick',...
    [1 10 100 1000 10000 100000 1000000]);
annotation('textbox',...
   [0.85 0.78 0.04 0.08],...
    'String','C',...
    'LineWidth',5,...
    'Interpreter','latex',...
    'HorizontalAlignment','center',...
    'FontSize',100,...
    'FitBoxToText','off');

% F    = getframe(fig);
% imwrite(F.cdata, 'thresh_image.png', 'png')
% saveas(fig,'thresh_image.eps', 'epsc')


%% multipying
img_multi = (img_thresh + 1)*10;
fig = figure('name', 'multiplied image',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';

[counts_multi, grayLevels_multi] = imhist(img_multi,bun_num);
bar(grayLevels_multi, counts_multi, 'FaceColor', 'b', 'BarWidth', 0.7);
xlim([0 255])
ylim([100 5e06])
xlabel('Gray value','Interpreter','latex')
% ylabel('Frequency (log scale)','Interpreter','latex')
set(gca,'YMinorTick','off','YGrid', 'on','YScale','log','YTick',...
    [1 10 100 1000 10000 100000 1000000]);
annotation('textbox',...
    [0.85 0.78 0.04 0.08],...
    'String','D',...
    'LineWidth',5,...
    'Interpreter','latex',...
    'HorizontalAlignment','center',...
    'FontSize',100,...
    'FitBoxToText','off');
% F    = getframe(fig);
% imwrite(F.cdata, 'multiplied_image.png', 'png')
% saveas(fig,'multiplied_image.eps', 'epsc')


%% All in one place

leg1 = ['Raw Image'];
leg2=['Subtracted images after the 1st pre-processing step'];
leg3 = ['Thresholded images after the 3rd pre-processing step'];
leg4 = ['Thresholded image, multiplied by rescale coefficient'];
leg5 = ['Gray value threshhold'];

fig = figure('name', 'all_in_one_gary_hist',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';

idx = find(counts_raw~=0);
plot(grayLevels_raw(idx), counts_raw(idx),'b-')
hold on 

idx = find(counts_sub~=0);
plot(grayLevels_sub(idx), counts_sub(idx),'g--')
hold on 

plot([9 9],[100 5e06],'k.-','LineWidth',4)
hold on

idx = find(counts_thresh~=0);
plot(grayLevels_thresh(idx), counts_thresh(idx),'m-.')
hold on 

idx = find(counts_multi~=0);
plot(grayLevels_multi(idx), counts_multi(idx),'r:')
hold on 


hleg = legend(leg1,leg2,leg5,leg3,leg4);
% [hleg, hobj, hout, mout] = legend(leg1,leg2,leg3,leg4,leg5);
hleg.FontSize = 53;
% hobj.LineWidth = 4;
xlabel('Gray value','Interpreter','latex')
ylabel('Frequency (log scale)','Interpreter','latex')

xlim([0 255])
ylim([100 5e06])

set(gca,'YMinorTick','off','XMinorTick','on','YGrid', 'on','XMinorGrid', 'on','YScale','log','YTick',...
    [1 10 100 1000 10000 100000 1000000]);

hold on
% plot([9 9],[100 5e06],'k.-','LineWidth',4)
% 
% annotation('textbox',...
%     [0.16 0.825 0.33 0.085],...
%     'FontSize',100,...
%     'LineWidth',3,...
%     'String',{'Filtering threshold'});


F    = getframe(fig);
imwrite(F.cdata, 'all_in_one_gary_hist.png', 'png')
saveas(fig,'all_in_one_gary_hist.eps', 'epsc')



 
fig = figure(44);
imshow(img,[])
F    = getframe(fig);
imwrite(F.cdata, 'raw_image.png', 'png')
saveas(fig,'raw_image.eps', 'epsc')

fig = figure(45);
imshow(img_sub,[])
F    = getframe(fig);
imwrite(F.cdata, 'MaxSubtracted_image.png', 'png')
saveas(fig,'MaxSubtracted_image.eps', 'epsc')

fig = figure(46);
imshow(img_thresh,[])
F    = getframe(fig);
imwrite(F.cdata, 'Thresholded_image.png', 'png')
saveas(fig,'Thresholded_image.eps', 'epsc')

fig = figure(47);
imshow(img_multi,[])
F    = getframe(fig);
imwrite(F.cdata, 'Multiplied_image.png', 'png')
saveas(fig,'Multiplied_image.eps', 'epsc')




