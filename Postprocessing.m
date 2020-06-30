% code to put 3 FOV in one place

clc 
close all
clear all

%% set figure properties

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex'); 


set(0,'DefaultAxesFontSize',55);
set(0,'DefaultTextFontSize', 60)
set(0,'DefaultLegendFontSize',40);
set(0,'DefaultLineMarkerSize', 6)
set(0,'DefaultLineLineWidth', 6)
% set(0,'DefaultMarkerMarkerSize', 1)
set(0,'defaultUicontrolFontName', 'Arial')
set(0,'defaultUitableFontName', 'Arial')
set(0,'defaultAxesFontName', 'Arial')
set(0,'defaultTextFontName', 'Arial')
set(0,'defaultUipanelFontName', 'Arial')

%%

flow = load('flow.mat');
high = load('high.mat');
low =  load('low.mat');

highu = load('uhigh.mat');
highv = load('vhigh.mat');
lowu  = load('ulow.mat');
lowv  = load('vlow.mat');

lowmask  = load('masklow.mat');
highmask = load('maskhigh.mat');


u.middle = flow.u;
u.top    = low.u;
u.bottom = high.u;

v.middle = flow.v;
v.top    = low.v;
v.bottom = high.v;



u.middle = u.middle(64:333,:);
u.top = u.top(1:338,:);
u.bottom = u.bottom(82:end,:);


v.middle = v.middle(64:333,:);
v.top = v.top(1:338,:);
v.bottom = v.bottom(82:end,:);

[x1 y] = size(u.middle);
[x2 y] = size(u.top);
[x3 y] = size(u.bottom);

u.overal = zeros(x1+x2+x3,y+4);
v.overal = zeros(x1+x2+x3,y+4);

u.overal(1:338,1:end-4) = u.top;
u.overal(339:338+x1,1:end-4) = u.middle;
u.overal(338+x1+1:end,5:end) = u.bottom();

v.overal(1:338,1:end-4) = v.top;
v.overal(339:338+x1,1:end-4) = v.middle;
v.overal(338+x1+1:end,5:end) = v.bottom;



%% Quiver 


% [xx yy] = meshgrid(1:y+4,1:x1+x2+x3);

[xdim ydim] = meshgrid(0.14:0.1:0.14+(y+4-1)*0.1,0.14:0.1:0.14+(x1+x2+x3-1)*0.1);

% xdim = xx*20*0.001;
% ydim = yy*20*0.001;

fig = figure('name', 'quiver',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';
quiver(xdim*80/(max(max(xdim))),ydim,u.overal,v.overal,7,'color','b')
xlabel('Cell length $[mm]$')
ylabel('Cell width $[mm]$')
ylim([0 100])
xlim([0 50])
set(gca,'Ydir','reverse')
pbaspect([1 2 1])
% set(gca,'YMinorTick','on','YTick',...
%     [0 10 20 30 40 50 60 70 80 ])


set(gca,'FontSize',25,'PlotBoxAspectRatio',[1 2 1],'XTick',[0 25 50],'XTickLabel',...
    {'0','25','50'},'YMinorTick','on','YTick',...
    [0 12.5 25 37.5 50 62.5 75 87.5 100],'YTickLabel',...
    {'0','','20','','40','','60','','80'});
set(gca,'DefaultAxesFontSize',30);
set(gca,'DefaultTextFontSize', 30)



F    = getframe(fig);
imwrite(F.cdata, 'overal-quiver.png', 'png')
saveas(fig,'overal-quiver.eps', 'epsc')


%% overal histograms

num_points = 100;

 
[lowmat, lowmat_center] = hist(nonzeros(lowu.u_mat(:)),num_points);
[lowflow, lowflow_center] = hist(nonzeros(lowu.u_flow_frac(:)),num_points);
[loworient, loworient_center] = hist(nonzeros(lowu.u_oriented_frac(:)),num_points);

[highmat, highmat_center] = hist(nonzeros(highu.u_mat(:)),num_points);
[highflow, highflow_center] = hist(nonzeros(highu.u_flow_frac(:)),num_points);
[highorient, highorient_center] = hist(nonzeros(highu.u_oriented_frac(:)),num_points);



fig = figure('name', 'Overal u histogram',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';

plot(lowmat_center,lowmat,'g--')
leg1 = ['Low-permeability matrix'];
hold on 
plot(lowflow_center,lowflow,'r--')
leg2 =['Flow-through fracture in low-permeability matrix'];
hold on
plot(loworient_center,loworient,'b--')
leg3 = ['Dead-end fracture in low-permeability matrix'];
hold on

plot(highmat_center,highmat,'g:')
leg4 = ['High-permeability matrix'];
hold on 
plot(highflow_center,highflow,'r:')
leg5 = ['Flow-through fracture in high-permeability matrix'];
hold on
plot(highorient_center,highorient,'b:')
hold on
leg6 =['Dead-end fracture in high-permeability matrix'];

% leg = ['Velocity in low permeability matrix'; ...
%     'Velocity in flow through fracture, embedded in low permeability matarix'; ...
%     'Velocity in dead-ed fracture, embedded in low permeability matrix'; ...
%     'Velocity in high permeability matrix';...
%     'Velocity in flow through fracture, embedded in high permeability matarix';...
%     'Velocity in dead-ed fracture, embedded in high permeability matrix'];

% leg = [leg1;leg2;leg3;leg4;leg5;leg6];
                
leg = legend(leg1,leg2,leg3,leg4,leg5,leg6);
leg.FontSize = 46;
xlabel('Velocity in flow (longitudinal) direction $[\frac{mm}{sec}$]','Interpreter','latex')
ylabel('Frequency (log scale)','Interpreter','latex')
set(gca,'YScale','log','YGrid','on','XGrid','on')

set(gca,'XMinorTick','on','XTick',...
    [-0.01 0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 ])
    
ylim([10 20000])
xlim([-0.01 0.12])
F    = getframe(fig);
imwrite(F.cdata, 'overal-x_histogram.png', 'png')
saveas(fig,'overal-x_histogram.eps', 'epsc')


%% plot for InterPore

fig = figure('name', 'u for interpore',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';

plot(lowflow_center,lowflow,'r--')
%leg2 =['Flow-through fracture in low-permeability matrix'];
hold on
plot(loworient_center,loworient,'b--')
%leg3 = ['Dead-end fracture in low-permeability matrix'];
leg = legend(leg2,leg3);
leg.FontSize = 46;
xlabel('Velocity in flow (longitudinal) direction $[\frac{mm}{sec}$]','Interpreter','latex')
ylabel('Frequency (log scale)','Interpreter','latex')
set(gca,'YScale','log','YGrid','on','XGrid','on')

ylim([10 20000])
xlim([-0.01 0.12])
F    = getframe(fig);
imwrite(F.cdata, 'x_his_Interpore.png', 'png')
saveas(fig,'x_his_Interpore.eps', 'epsc')


%% Overall hist in y direction



 
[lowmat, lowmat_center] = hist(nonzeros(lowv.v_mat(:)),num_points);
[lowflow, lowflow_center] = hist(nonzeros(lowv.v_flow_frac(:)),num_points);
[loworient, loworient_center] = hist(nonzeros(lowv.v_oriented_frac(:)),num_points);

[highmat, highmat_center] = hist(nonzeros(highv.v_mat(:)),num_points);
[highflow, highflow_center] = hist(nonzeros(highv.v_flow_frac(:)),num_points);
[highorient, highorient_center] = hist(nonzeros(highv.v_oriented_frac(:)),num_points);



fig = figure('name', 'Overal v histogram',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';

plot(lowmat_center,lowmat,'g--')
leg1 = ['Low-permeability matrix'];
hold on 
plot(lowflow_center,lowflow,'r--')
leg2 =['Flow-through fracture in low-permeability mtarix'];
hold on
plot(loworient_center,loworient,'b--')
leg3 = ['Dead-end fracture in low-permeability matrix'];
hold on

plot(highmat_center,highmat,'g:')
leg4 = ['High-permeability matrix'];
hold on 
plot(highflow_center,highflow,'r:')
leg5 = ['Flow-through fracture in high-permeability matrix'];
hold on
plot(highorient_center,highorient,'b:')
hold on
leg6 =['Dead-end fracture in high-permeability matrix'];

% leg = ['Velocity in low permeability matrix'; ...
%     'Velocity in flow through fracture, embedded in low permeability matarix'; ...
%     'Velocity in dead-ed fracture, embedded in low permeability matrix'; ...
%     'Velocity in high permeability matrix';...
%     'Velocity in flow through fracture, embedded in high permeability matarix';...
%     'Velocity in dead-ed fracture, embedded in high permeability matrix'];

% leg = [leg1;leg2;leg3;leg4;leg5;leg6];
                
% leg = legend(leg1,leg2,leg3,leg4,leg5,leg6);
% leg.FontSize = 25;
xlabel('Velocity in transverse (lateral) direction $[\frac{mm}{sec}$]','Interpreter','latex')
ylabel('Frequency (log scale)','Interpreter','latex')
set(gca,'YScale','log','YGrid','on','XGrid','on')

% set(gca,'XMinorTick','on','XTick',...
%     [-0.01 0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 ])
    
ylim([10 20000])
xlim([-0.05 0.05])
F    = getframe(fig);
imwrite(F.cdata, 'overal-y_histogram.png', 'png')
saveas(fig,'overal-y_histogram.eps', 'epsc')


%% plot for InterPore

fig = figure('name', 'v for interpore',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';

plot(lowflow_center,lowflow,'r--')
%leg2 =['Flow-through fracture in low-permeability matrix'];
hold on
plot(loworient_center,loworient,'b--')
%leg3 = ['Dead-end fracture in low-permeability matrix'];
leg = legend(leg2,leg3);
leg.FontSize = 46;
xlabel('Velocity in flow (longitudinal) direction $[\frac{mm}{sec}$]','Interpreter','latex')
ylabel('Frequency (log scale)','Interpreter','latex')
set(gca,'YScale','log','YGrid','on','XGrid','on')

ylim([10 20000])
xlim([-0.05 0.05])
F    = getframe(fig);
imwrite(F.cdata, 'y_his_Interpore.png', 'png')
saveas(fig,'y_his_Interpore.eps', 'epsc')



%% Detailed flow in oriented and flow fracture


% 
% lowv.v_oriented_frac = lowv.v_oriented_frac .* lowmask.mask_extrac_of;
% lowv.v_flow_frac = lowv.v_flow_frac .* lowmask.mask_extrac_ff;
% highv.v_oriented_frac = highv.v_oriented_frac .* highmask.mask_extrac_of;
% highv.v_flow_frac = highv.v_flow_frac .* highmask.mask_extrac_ff;


lowu.v_oriented_frac = lowu.u_oriented_frac .* lowmask.mask_extrac_of;
lowu.v_flow_frac = lowu.u_flow_frac .* lowmask.mask_extrac_ff;
highu.v_oriented_frac = highu.u_oriented_frac .* highmask.mask_extrac_of;
highu.v_flow_frac = highu.u_flow_frac .* highmask.mask_extrac_ff;


% lowv.v_oriented_frac(lowv.v_oriented_frac == 0) = NaN;
% lowv.v_flow_frac(lowv.v_flow_frac == 0) = NaN;
% highv.v_oriented_frac(highv.v_oriented_frac == 0) = NaN;
% highv.v_flow_frac(highv.v_flow_frac == 0) = NaN;

lowu.u_oriented_frac(lowu.u_oriented_frac == 0) = NaN;
lowu.u_flow_frac(lowu.u_flow_frac == 0) = NaN;
highu.u_oriented_frac(highu.u_oriented_frac == 0) = NaN;
highu.u_flow_frac(highu.u_flow_frac == 0) = NaN;


meanv.low_oriented  = nanmean((lowv.v_oriented_frac),1);
meanv.low_flow      = nanmean(lowv.v_flow_frac,1);
meanv.high_oriented = nanmean(highv.v_oriented_frac,1);
meanv.high_flow     = nanmean(highv.v_flow_frac,1);


meanu.low_oriented  = nanmean(lowu.u_oriented_frac,1);
meanu.low_flow      = nanmean(lowu.u_flow_frac,1);
meanu.high_oriented = nanmean(highu.u_oriented_frac,1);
meanu.high_flow     = nanmean(highu.u_flow_frac,1);




% Averaging every n values

n = 4;
S1 = size(meanv.low_flow,2);
M = S1 - mod(S1,n);
y = reshape(meanv.low_oriented(1:M),n,[]);
meanv.low_oriented =transpose(sum(y,1)/n);


y = reshape(meanv.low_flow(1:M),n,[]);
meanv.low_flow   =transpose(sum(y,1)/n);


y = reshape(meanv.high_oriented(1:M),n,[]);
meanv.high_oriented   =transpose(sum(y,1)/n);


y = reshape(meanv.high_flow (1:M),n,[]);
meanv.high_flow  =transpose(sum(y,1)/n);


S1 = size(meanu.low_flow,2);
M = S1 - mod(S1,n);

y = reshape(meanu.low_oriented(1:M),n,[]);
meanu.low_oriented =transpose(sum(y,1)/n);


y = reshape(meanu.low_flow(1:M),n,[]);
meanu.low_flow   =transpose(sum(y,1)/n);


y = reshape(meanu.high_oriented(1:M),n,[]);
meanu.high_oriented   =transpose(sum(y,1)/n);


y = reshape(meanu.high_flow (1:M),n,[]);
meanu.high_flow  =transpose(sum(y,1)/n);


% Averaing every 10 values: 

fig = figure('name', 'meanv',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';
plot(meanv.low_oriented,'b--')
leg1 = ['Dead-end fracture in low-permeability matrix'];
hold on
plot(meanv.high_oriented,'r:')
leg2 = ['Dead-end fracture in high-permeability matrix'];
hold on

% plot(meanv.low_flow,'r--')
% leg3 =['Flow-through fracture in low-permeability mtarix'];
% hold on
% plot(meanv.high_flow,'r:')
% leg4 = ['Flow-through fracture in high-permeability matrix'];
% hold on



leg = legend(leg1,leg2);
leg.FontSize = 75;
plot([0 length(meanv.high_oriented)],[0 0],'k-')
xlabel('Cell length $[mm]$','Interpreter','latex')
ylabel('Velocity in transverse (lateral) direction $[\frac{mm}{sec}$]','Interpreter','latex')
xlim([0 210])
ylim([-2E-3 2E-3])
set(gca,'YGrid','on','XGrid','on')
set(gca,'DefaultLineMarkerSize', 2)
set(gca,'XMinorTick','on','XTick',...
        [0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210],...
    'XTickLabel',...
    {'0','','','','10','','','','20','','','','30','','','','40','','','','','50'})
hold off

F    = getframe(fig);
imwrite(F.cdata, 'Transverse velocity in oriented fracture.png', 'png')
saveas(fig,'Transverse velocity in oriented fracture.eps', 'epsc')


fig = figure('name', 'meanu',...
    'Position', get(0, 'Screensize'));
plot(meanu.low_oriented,'b--')
leg1 = ['Dead-end fracture in low-permeability matrix'];
hold on
plot(meanu.high_oriented,'r:')
leg2 = ['Dead-end fracture in high-permeability matrix'];
hold on

%% legend for separate plots
leg = legend(leg1,leg2);
leg.FontSize = 75;
%%
% plot(meanu.low_flow,'r--')
% leg3 =['Flow-through fracture in low-permeability mtarix'];
% hold on
% plot(meanu.high_flow,'r:')
% leg4 = ['Flow-through fracture in high-permeability matrix'];
% hold on



% leg = legend(leg1,leg2);
% leg.FontSize = 65;
% leg.Position = [0.130256581306458 0.791819270662918 0.294352793693542 0.108058608058608];
xlabel('Cell length $[mm]$','Interpreter','latex')
ylabel('Velocity in flow (longitudinal) direction $[\frac{mm}{sec}$]','Interpreter','latex')
xlim([0 210])
set(gca,'YGrid','on','XGrid','on')
set(gca,'XMinorTick','on','XTick',...
        [0 10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180 190 200 210],...
    'XTickLabel',...
    {'0','','','','10','','','','20','','','','30','','','','40','','','','','50'})
hold off

F    = getframe(fig);
imwrite(F.cdata, 'longitudinal velocity in oriented fracture.png', 'png')
saveas(fig,'longitudinal velocity in oriented fracture.eps', 'epsc')


%% Average of velocities in each of the media

high_mat_u = nanmean(highu.u_mat(:));
high_mat_v = nanmean(highv.v_mat(:));
high_mat   = nanmean((highu.u_mat(:).^2 + highv.v_mat(:).^2).^0.5);

high_flow_u = nanmean(highu.u_flow_frac(:));
high_flow_v = nanmean(highv.v_flow_frac(:));
high_flow   = nanmean((highu.u_flow_frac(:).^2 + highv.v_flow_frac(:).^2).^0.5);

high_oriented_u = nanmean(highu.u_oriented_frac(:));
high_oriented_v = nanmean(highv.v_oriented_frac(:));
high_oriented   = nanmean((highu.u_oriented_frac(:).^2 + highv.v_oriented_frac(:).^2).^0.5);

low_mat_u = nanmean(lowu.u_mat(:));
low_mat_v = nanmean(lowv.v_mat(:));
low_mat   = nanmean((lowu.u_mat(:).^2 + lowv.v_mat(:).^2).^0.5);

low_flow_u = nanmean(lowu.u_flow_frac(:));
low_flow_v = nanmean(lowv.v_flow_frac(:));
low_flow   = nanmean((lowu.u_flow_frac(:).^2 + lowv.v_flow_frac(:).^2).^0.5);

low_oriented_u = nanmean(lowu.u_oriented_frac(:));
low_oriented_v = nanmean(lowv.v_oriented_frac(:));
low_oriented   = nanmean((lowu.u_oriented_frac(:).^2 + lowv.v_oriented_frac(:).^2).^0.5);


leg1 = ['Low-permeability matrix'];
leg2 =['Flow-through fracture in low-permeability mtarix'];
leg3 = ['Dead-end fracture in low-permeability matrix'];
leg4 = ['High-permeability matrix'];
leg5 = ['Flow-through fracture in high-permeability matrix'];
leg6 =['Dead-end fracture in high-permeability matrix'];

fig = figure('name', 'mean_all_in_one',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';

% axes1 = axes('Parent',fig,...
%     'Position',[0.21 0.125516102394715 0.79 0.79]);

axes1 = axes('Parent',fig,...
    'Position',[0.45 0.125516102394715 0.51 0.79]);
hold(axes1,'on');


% x = [leg1, leg2, leg3, leg4,leg5,leg6];
% x = ['low mat' , 'low flow', 'low dead', 'high mat' ,'high flow','high dead'];
x = [1,2,3,4,5,6];

y = [  low_mat, low_mat_u , low_mat_v;  ...
    high_mat, high_mat_u , high_mat_v;  ...
    low_flow,low_flow_u, low_flow_v; ...
    high_flow,high_flow_u, high_flow_v; ...
    low_oriented,low_oriented_u, low_oriented_v; ...    
    high_oriented, high_oriented_u, high_oriented_v];

 h = barh(x,abs(y),'grouped','EdgeColor','none','BarWidth',0.5);
 
 h(1).FaceColor = 'blue';
 h(2).FaceColor = 'red';
 h(3).FaceColor = 'green';

leg = legend('Averaged velocity magnitude', ...
    'Averaged longitudinal velocity',...
    'Averaged lateral velocity');

% leg.FontSize = 35;
% leg.Position = [0.385 0.85 0.263 0.102];

leg.FontSize = 45;
leg.Position = [0.66 0.84 0.263 0.102];

xlabel('Average velocity $[\frac{mm}{sec}$] (log scale)','Interpreter','latex')

set(gca,'YGrid','on','XGrid','on')
set(gca,'XMinorTick','on','XScale','log','YTickLabel',...
    {'',leg1,leg4,leg2,leg5,leg3,leg6,''},'FontSize',50)


 %% plot for Interpore
% 
fig = figure('name', 'mean_interpore',...
    'Position', get(0, 'Screensize'));
fig.Color = 'w';

% 
axes1 = axes('Parent',fig,...
    'Position',[0.45 0.125516102394715 0.51 0.79]);
hold(axes1,'on');
% 
x = [1,2];

y = [low_flow,low_flow_u, low_flow_v; ...
    low_oriented,low_oriented_u, low_oriented_v];
% 
 h = barh(x,abs(y),'grouped','EdgeColor','none','BarWidth',0.5);
 
 h(1).FaceColor = 'blue';
 h(2).FaceColor = 'red';
 h(3).FaceColor = 'green';

leg = legend('Averaged velocity magnitude', ...
    'Averaged longitudinal velocity',...
    'Averaged lateral velocity');

% leg.FontSize = 35;
% leg.Position = [0.385 0.85 0.263 0.102];

leg.FontSize = 45;
leg.Position = [0.605201319694522 0.389457979953739 0.354628610610962 0.184271395528142];

xlabel('Average velocity $[\frac{mm}{sec}$] (log scale)','Interpreter','latex')

set(gca,'YGrid','on','XGrid','on')
set(gca,'XMinorTick','on','XScale','log','YTickLabel',...
    {'','matrix','in low-permeability','Flow-through fracture','','','matrix','in low-permeability','Dead-end fracture',''},'FontSize',50)
    
% set(gca,'XMinorTick','on','XScale','log','YTickLabel',...
%     {'','',leg3,'','','','',leg2,'',''},'FontSize',50)

    F    = getframe(fig);
imwrite(F.cdata, 'average_interpore.png', 'png')
saveas(fig,'average_interpore.eps', 'epsc')




% % % Create textbox
% annotation('textbox',...
%     [0.00001 0.75 0.30 0.0859030837004435],...
%     'String',{'Dead-end fracture in','high-permeability matrix'},...
%     'LineStyle','none',...
%     'Interpreter','latex',...
%     'FontSize',50,...
%     'FitBoxToText','off');
% 
% % % Create textbox
% annotation('textbox',...
%     [0.00001 0.64 0.30 0.0859030837004435],...
%     'String',{'Dead-end fracture in','low-permeability matrix'},...
%     'LineStyle','none',...
%     'Interpreter','latex',...
%     'FontSize',40,...
%     'FitBoxToText','off');
% 
% % % Create textbox
% annotation('textbox',...
%     [0.00001 0.525 0.3 0.0859030837004435],...
%     'String',{'Flow-through fracture in','high-permeability matrix'},...
%     'LineStyle','none',...
%     'Interpreter','latex',...
%     'FontSize',40,...
%     'FitBoxToText','off');
% % 
% % % Create textbox
% annotation('textbox',...
%     [0.00001 0.415 0.3 0.0859030837004438],...
%     'String',{'Flow-through fracture in','low-permeability matrix'},...
%     'LineStyle','none',...
%     'Interpreter','latex',...
%     'FontSize',40,...
%     'FitBoxToText','off');
% 
% % % Create textbox
% annotation('textbox',...
%     [0.00001 0.287 0.3 0.0859030837004438],...
%     'String',{'High permeability matrix'},...
%     'LineStyle','none',...
%     'Interpreter','latex',...
%     'FontSize',40,...
%     'FitBoxToText','off');
% % 
% % Create textbox
% annotation('textbox',...
%     [0.00001 0.174 0.3 0.0859030837004438],...
%     'String','Low permeability matrix',...
%     'LineStyle','none',...
%     'Interpreter','latex',...
%     'FontSize',40,...
%     'FitBoxToText','off');


% F    = getframe(fig);
% imwrite(F.cdata, 'mean_vel_in_one.png', 'png')
% saveas(fig,'mean_vel_in_one.eps', 'epsc')



%  figure();
% 
% y1 = [low_mat_u ,  low_mat;  ...
%      low_flow_u, low_flow; ... 
%      low_oriented_u,  low_oriented; ...
%      high_mat_u ,  high_mat;  ...
%      high_flow_u,  high_flow; ... 
%      high_oriented_u,  high_oriented];
%  
%  y2 = [low_mat_v ;  ...
%      low_flow_v ; ... 
%       low_oriented_v; ...
%      high_mat_v;  ...
%      high_flow_v; ... 
%       high_oriented_v];
% 
% ax1 = gca;
% 
%  b1 =  barh(x,y1,'grouped');
%  
%  hold on
%  
% ax1_pos = ax1.Position; % position of first axes
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'Color','none','YTick',[]);
%   
%  b2 = barh(x,y2,'grouped','Parent',ax2);
  
% xxaxis top  
% b1 =  barh(x,y1,'grouped');
% 
% xxaxis bottom
% hold on
% b2 = barh(x,y2,'grouped');

     
     
