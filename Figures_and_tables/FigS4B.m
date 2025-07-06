function fmean = FigS4B
% Figure S4B. Plot force histogram normal speed and different temperatures

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
  texts = strcat(Ttext(2:3)," normal speed");
  clusters = [cl1,cl2,cl3];  

  step = 1;
  edges = 5:step:50;
  values = (edges(1:end-1)+edges(2:end))/2;
  figure('Name','S4B');
  tl = tiledlayout(2,1,'TileSpacing','compact');
  fmean = zeros(4,1);
  for i = 1:2
    sel = selection(:,i);
    N = histcounts(f(sel),edges);
    fmean(i) = mean(f(sel));
    p = N/sum(N)/step;
    [~,~,n,Fplot,pdbell] = fitBell(TRIP,clusters&selection(:,i),0);
    % [~,~,~,n,Fplot,pdbell] = fit_dual_Bell(TRIP,runcase,clusters,0);
    w = n/sum(n);
    nexttile
    bar(values,p,1);
    hold on;
    plot(Fplot,max(w.*pdbell,[],2),'r','LineWidth',1.5) 
    % plot(Fplot,pdbell*w','r','LineWidth',1.5);
    title(texts(i));
    text(45,0.07,sprintf('n = %d',sum(N)))
    ylim([0,0.1])
    if i == 2
      legend('Experiment','Model','Location','northwest');
    end
  end
  title(tl,'Force distributions for normal pulling speed')
  xlabel(tl,'Force (pN)');ylabel(tl,'Probability density (pN^-^1)')
  fprintf('Figure S4B\n')
  fprintf('%14s     %20s\n','Temperature','Mean unfolding force (pN)')
  for i = 1:4
    fprintf('%14s %14.2f\n',Ttext(i),fmean(i))
  end

