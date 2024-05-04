function fmean = Fig1_B_D
% Figure 1. Plot force histogram normal speed and different temperatures

load Top7Tables.mat Tun

[ok,Cluster1,Cluster2] = no_outliers(Tun);
Clusters = [Cluster1,Cluster2];

% Unfold cases:
f = Tun.Force;
speed = Tun.Pullingspeed;
T = Tun.Temperature;
fast = speed>500;
normal = speed<500 & speed>50;
slow = speed<14;

Tclass = [4<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=27];
Ttext = ["4°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=27°C"];
speedtext = ["1000nm/s","100nm/s","10nm/s"];


selection = false(numel(f),4);
selection(:,1) = normal&Tclass(:,1)&ok;
seltext(1) = strcat(Ttext(1)," , ",speedtext(2));
selection(:,2) = normal&Tclass(:,4)&ok;
seltext(2) = strcat(Ttext(4)," , ",speedtext(2));
selection(:,3) = fast&ok;
seltext(3) = speedtext(1);
selection(:,4) = slow&ok;
seltext(4) = speedtext(3);

step = 2;
edges = 6:step:50;
values = (edges(1:end-1)+edges(2:end))/2;
figure('Name','Fig1');
tl = tiledlayout(2,2,'TileSpacing','compact');
fmean = zeros(4,1);
for i = 1:4
  sel = selection(:,i);
  N = histcounts(f(sel),edges);
  fmean(i) = mean(f(sel));
  p = N/sum(N)/step;
  runcase.selected = sel;
  [~,~,~,n,Fplot,pdbell] = fit_dual_Bell(Tun,runcase,Clusters,0);
  w = n/sum(n);
  nexttile
  bar(values,p,1);
  hold on;
  plot(Fplot,pdbell*w','r','LineWidth',1.5);
  title(seltext(i));
  text(45,0.07,sprintf('n = %d',sum(N)))
  ylim([0,0.1])
  if i == 2
    legend('Experiment','Model','Location','northwest');
  end
end
title(tl,'Force distributions for normal pulling speed')
xlabel(tl,'Force (pN)');ylabel(tl,'Probability density (pN^-^1)')
fprintf('%14s     %20s\n','Temperature','Mean unfolding force (pN)')
for i = 1:4
  fprintf('%14s %14.2f\n',Ttext(i),fmean(i))
end

