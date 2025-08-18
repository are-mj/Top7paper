function FigS7
% Figure S7 B. Plot force histogram not shown in Figure 1
  load Tables.mat TRIP

  % Select pulling trace events (rips)
  T = TRIP.Temperature;
  f = TRIP.Force;
  speed = TRIP.Pullingspeed;
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  slow = speed < 50;
  normal = speed > 50 & speed<250;
  fast = speed > 250;
  speedtext = ["High speed","Normal speed","Low speed"];
  [cl1,cl2,cl3] = clusterdefinitions(TRIP);

  selection = [normal & Tclass(:,2),normal & Tclass(:,3), ...
    fast & Tclass(:,1),fast & Tclass(:,4)];
  seltext{1} = {Ttext(2);speedtext(2)};
  seltext{2} = {Ttext(3);speedtext(2)};
  seltext{3} = {Ttext(1);speedtext(1)};
  seltext{4} = {Ttext(4);speedtext(1)};

  % texts = strcat(Ttext(2:3)," normal speed");
  clusters = [cl1,cl2,cl3];  

  Fstep = 1;
  edges = 5:Fstep:50;
  values = (edges(1:end-1)+edges(2:end))/2;
  figure('Name','S7');
  tl = tiledlayout(2,4,'TileSpacing','compact');
  for i = 1:4
    sel = selection(:,i);
    N = histcounts(f(sel),edges);
    p = N/sum(N)/Fstep;
    [~,~,n,Fplot,pdbell] = fitBell(TRIP,clusters&selection(:,i),0);
    w = n/sum(n);
    nexttile(i)
    bar(values,p,1);
    hold on;
    plot(Fplot,max(w.*pdbell,[],2),'r','LineWidth',1.5) 
    text(45,0.1,sprintf('n = %d',sum(N)))
    text(30,0.105,seltext{i},'FontName','Times New Roman','FontWeight', ...
      'bold','HorizontalAlignment','center');
    ylim([0,0.12])
    xlim([4,55])
    if i == 1
      h = legend('Experiment','Model','Location','East');
      ylabel('Rip');
      set(gca,'YTick',0:0.05:0.1);
      text(-5,0.11,'C','FontName','Times New Roman','FontSize',18,'FontWeight','Bold')
    else
      set(gca,'YTick',[]);
    end     
  end
  % title(tl,'Force distributions for normal pulling speed')
  xlabel(tl,'Force (pN)');ylabel(tl,'Probability density (pN^-^1)')
  fprintf('Figure S4B\n')
  fprintf('%14s     %20s\n','Temperature','Mean unfolding force (pN)')
  pos = get(gcf,'position');
  set(gcf,'Position',pos.*[0.1 1 2.7 1]);  
  pos = get(h,'Position');
  set(h,'Position',pos.*[1 1.04 1 1]);  % Nudge legend upwards
% ZIP:
  load Tables.mat TZIP
  
  T = TZIP.Temperature;
  f = TZIP.Force;
  speed = TZIP.Pullingspeed;
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  slow = speed < 30;
  normal = speed > 30 & speed<250;
  fast = speed > 250;
  
  selection = [normal & Tclass(:,2),normal & Tclass(:,3), ...
    fast & Tclass(:,1),fast & Tclass(:,4)];

  step = 0.5;
  edges = 2:step:50;
  values = (edges(1:end-1)+edges(2:end))/2;
  for i = 1:4
    sel = selection(:,i);
    N = histcounts(f(sel),edges);
    p = N/sum(N)/step;
    [~,rms(i),n,Fplot,pdbell] = fitBell(TZIP,sel,0);
    % w = repmat(n/sum(n),numel(Fplot),1);
    nexttile
    bar(values,p,1);
    hold on;
    plot(Fplot,pdbell,'r','LineWidth',1.5) 
    text(14.5,0.55,sprintf('n = %d',sum(N)))
    text(10.5,0.53,seltext{i},'FontName','Times New Roman','FontWeight', ...
      'bold','HorizontalAlignment','center');    
    ylim([0,0.6])
    xlim([0,18])
    if i == 1
      text(-3,0.58,'D','FontName','Times New Roman','FontSize',18, ...
        'FontWeight','Bold');
    end
  end
end