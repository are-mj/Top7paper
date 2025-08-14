function fmean = FigS7
% Figure S7 B and D. Plot force histogram normal speed and different temperatures

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
  % speeds = [fast,normal,slow;]
  % speedtext = ["250-1000nm/s","50-250nm/s","10-50nm/s"];
  [cl1,cl2,cl3] = clusterdefinitions(TRIP);

  selection = [normal & Tclass(:,2),normal & Tclass(:,3)];
  % texts = strcat(Ttext(2:3)," normal speed");
  clusters = [cl1,cl2,cl3];  

  Fstep = 1;
  edges = 5:Fstep:50;
  values = (edges(1:end-1)+edges(2:end))/2;
  figure('Name','S4B');
  tl = tiledlayout(2,1,'TileSpacing','compact');
  fmean = zeros(4,1);
  for i = 1:2
    sel = selection(:,i);
    N = histcounts(f(sel),edges);
    fmean(i) = mean(f(sel));
    p = N/sum(N)/Fstep;
    [~,~,n,Fplot,pdbell] = fitBell(TRIP,clusters&selection(:,i),0);
    % [~,~,~,n,Fplot,pdbell] = fit_dual_Bell(TRIP,runcase,clusters,0);
    w = n/sum(n);
    nexttile(i)
    h(i,1) = bar(values,p,1);
    hold on;
    h(i,2) = plot(Fplot,max(w.*pdbell,[],2),'r','LineWidth',1.5) 
    % plot(Fplot,pdbell*w','r','LineWidth',1.5);
    % title(texts(i));
    text(25,0.4,{Ttext(i+1),"Normal speed",sprintf('n = %d',sum(N))}, ...
      "HorizontalAlignment","center")
    ylim([0,0.1])
    xlim([4,55])
    if i == 1
      legend('Experiment','Model','Location','northwest');
    end
  end
  % title(tl,'Force distributions for normal pulling speed')
  xlabel(tl,'Force (pN)');ylabel(tl,'Probability density (pN^-^1)')
  fprintf('Figure S4B\n')
  fprintf('%14s     %20s\n','Temperature','Mean unfolding force (pN)')
  for i = 1:4
    fprintf('%14s %14.2f\n',Ttext(i),fmean(i))
  end

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
  
  speedtext = ["High speed","Normal speed","Low speed"; ...
    ">250","50-250","<50"];
  
  ok = cl1|cl2|cl3;
  selection = false(height(TZIP),2);
  selection(:,1) = normal&Tclass(:,2);
  seltext{1} = {Ttext(2);speedtext(2,2)};
  selection(:,2) = normal&Tclass(:,3);
  seltext{2} = {Ttext(3),speedtext(2,2)};

  step = 0.5;
  edges = 2:step:50;
  values = (edges(1:end-1)+edges(2:end))/2;
  fmean = zeros(4,1);
  for i = 1:2
    sel = selection(:,i);
    N = histcounts(f(sel),edges);
    fmean(i) = mean(f(sel));
    p = N/sum(N)/step;
    [~,rms(i),n,Fplot,pdbell] = fitBell(TZIP,sel,0);
    w = repmat(n/sum(n),numel(Fplot),1);
    nexttile(i)
    % plot(values,p,'k','LineWidth',1.5)
    h(i+2,1) = bar(values,p,1,'FaceAlpha',0.5);
    ylim([0,0.5])
    xlim([4,55])
    if i == 1
      legend([h(1,1),h(3,1),h(1,2)],{'Rip experiment','Zip experiment','Rip Model'},'Location','NorthEast');
    end
  end
end