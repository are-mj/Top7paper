function fmean = Fig1
% Figure 1. Plot force histogram normal speed and different temperatures
  
  load Tables.mat TP
  
  T = TP.Temperature;
  f = TP.Force;
  speed = TP.Pullingspeed;
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  slow = speed < 30;
  normal = speed > 30 & speed<250;
  fast = speed > 250;
  
  [cl1,cl2,cl3] = clusterdefinitions(TP);
  
  speedtext = ["High speed","Normal speed","Low speed"; ...
    "<50","50-250",""];
  
  ok = cl1|cl2|cl3;
  selection = false(height(TP),4);
  selection(:,1) = normal&Tclass(:,1)&ok;
  seltext{1} = {Ttext(1),speedtext(2)};
  selection(:,2) = normal&Tclass(:,4)&ok;
  seltext{2} = {Ttext(4),speedtext(2)};
  selection(:,3) = fast&ok&Tclass(:,4);
  seltext{3} = {Ttext(4),speedtext(1)};
  selection(:,4) = slow&ok&Tclass(:,4);
  seltext{4} = {Ttext(4),speedtext(3)};
  
  step = 2;
  edges = 2:step:50;
  values = (edges(1:end-1)+edges(2:end))/2;
  figure('Name','Fig1');
  tl = tiledlayout(2,2,'TileSpacing','compact');
  fmean = zeros(4,1);
  for i = 1:4
    Clusters = [cl1,cl2,cl3];
    if i >= 3
      Clusters = [cl1,cl2|cl3];
    end
    sel = selection(:,i);
    N = histcounts(f(sel),edges);
    fmean(i) = mean(f(sel));
    p = N/sum(N)/step;
    [~,rms(i),n,Fplot,pdbell] = fitBell(TP,sel&Clusters,0);
    w = repmat(n/sum(n),numel(Fplot),1);
    nexttile
    bar(values,p,1);
    hold on;
    plot(Fplot,max(w.*pdbell,[],2),'r','LineWidth',1.5) 
    % plot(Fplot,pdbell*w','r','LineWidth',1.5);
    % title(seltext{i});
    text(40,0.05,sprintf('n = %d',sum(N)))
    text(30,0.085,seltext{i},'HorizontalAlignment','center')
    % text(30,0.06,sprintf('rms = %.4f',rms))
    ylim([0,0.1])
    xlim([4,55])
    if i == 4
      legend('Experiment','Model','Location','southeast');
    end
  end
  % title(tl,'Force distributions for normal pulling speed')
  title(tl,'Rip force distributions')
  xlabel(tl,'Force (pN)');ylabel(tl,'Probability density (pN^-^1)')
  fprintf('Figure 1\n')
  fprintf('%14s     %20s  %5s\n','Temperature','Mean unfolding force (pN)','rms')
  for i = 1:4
    fprintf('%14s %14.2f              %.5f\n',Ttext(i),fmean(i),rms(i))
  end
end
