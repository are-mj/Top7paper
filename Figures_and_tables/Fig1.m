function fmean = Fig1
% Figure 1. Plot force histogram normal speed and different temperatures
  
  load Tables.mat TRIP
  
  T = TRIP.Temperature;
  f = TRIP.Force;
  speed = TRIP.Pullingspeed;
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  slow = speed < 30;
  normal = speed > 30 & speed<250;
  fast = speed > 250;
  
  [cl1,cl2,cl3] = clusterdefinitions(TRIP);
  
  speedtext = ["High speed","Normal speed","Low speed"];
  
  ok = cl1|cl2|cl3;
  selection = false(height(TRIP),4);
  selection(:,1) = normal&Tclass(:,1)&ok;
  seltext{1} = {Ttext(1),speedtext(1,2)};
  selection(:,2) = normal&Tclass(:,4)&ok;
  seltext{2} = {Ttext(4),speedtext(1,2)};
  selection(:,3) = fast&ok&Tclass(:,4);
  seltext{3} = {Ttext(4),speedtext(1,1)};
  selection(:,4) = slow&ok&Tclass(:,4);
  seltext{4} = {Ttext(4),speedtext(1,3)};
  
  step = 2;
  edges = 2:step:50;
  values = (edges(1:end-1)+edges(2:end))/2;
  figure('Name','Fig1');
  tl = tiledlayout(2,4,'TileSpacing','compact');
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
    [~,rms(i),n,Fplot,pdbell] = fitBell(TRIP,sel&Clusters,0);
    w = repmat(n/sum(n),numel(Fplot),1);
    nexttile
    bar(values,p,1);
    disp(max(p))
    hold on;
    plot(Fplot,max(w.*pdbell,[],2),'r','LineWidth',1.5);
    % text(45,0.1,sprintf('n = %d',sum(N)))
    text(32,0.095,seltext{i},'FontName','Times New Roman','FontWeight', ...
      'bold','HorizontalAlignment','center');
    text(32,0.078,sprintf('n = %d',sum(N)),'HorizontalAlignment','center');
    ylim([0,0.11])
    xlim([4,55])
    if i == 1
      legend('Experiment','Model','Location','East');
      ylabel('Rip');
      set(gca,'YTick',0:0.05:0.1);
      text(-5,0.1,'C','FontName','Times New Roman','FontSize',18,'FontWeight','Bold')
    else
      set(gca,'YTick',[]);
    end    
  end
  % title(tl,'Force distributions for normal pulling speed')
  title(tl,'Rip force distributions')
  xlabel(tl,'Force (pN)');ylabel(tl,'Probability density (pN^-^1)')
  % fprintf('Figure 1\n')
  % fprintf('%14s     %20s  %5s\n','Temperature','Mean unfolding force (pN)','rms')
  % for i = 1:4
  %   fprintf('%14s %14.2f              %.5f\n',Ttext(i),fmean(i),rms(i))
  % end
  pos = get(gcf,'position');
  % set(gcf,'Position',pos.*[0.1 1 2.7 1]);
  set(gcf,'Position',pos.*[0.05 1 2.2 1]);

% **************** ZIP *********************:
  load Tables.mat TZIP
  
  T = TZIP.Temperature;
  f = TZIP.Force;
  speed = TZIP.Pullingspeed;
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  slow = speed < 30;
  normal = speed > 30 & speed<250;
  fast = speed > 250;
  
  selection = false(height(TZIP),4);
  selection(:,1) = normal&Tclass(:,1);
  seltext{1} = {Ttext(1),speedtext(1,2)};
  selection(:,2) = normal&Tclass(:,4);
  seltext{2} = {Ttext(4),speedtext(1,2)};
  selection(:,3) = fast&Tclass(:,4);
  seltext{3} = {Ttext(4),speedtext(1,1)};
  selection(:,4) = slow&Tclass(:,4);
  seltext{4} = {Ttext(4),speedtext(1,3)};

  step = 0.5;
  edges = 2:step:50;
  values = (edges(1:end-1)+edges(2:end))/2;
  fmean = zeros(4,1);
  for i = 1:4
    sel = selection(:,i);
    N = histcounts(f(sel),edges);
    fmean(i) = mean(f(sel));
    p = N/sum(N)/step;
    [~,rms(i),n,Fplot,pdbell] = fitBell(TZIP,sel,0);
    nexttile
    bar(values,p,1);
    hold on;
    plot(Fplot,pdbell,'r','LineWidth',1.5);
    text(11,0.43,sprintf('n = %d',sum(N)),'HorizontalAlignment','center')
    text(11,0.53,seltext{i},'FontName','Times New Roman','FontWeight', ...
      'bold','HorizontalAlignment','center');
    ylim([0,0.6])
    xlim([0,18])
    if i ==1
      ylabel('Zip');
      text(-3,0.58,'D','FontName','Times New Roman','FontSize',18,'FontWeight','Bold')
    else
      set(gca,'YTick',[]);
    end
  end
  title(tl,'Rip and Zip force distributions');  
end
  % 


