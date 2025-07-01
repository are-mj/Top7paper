function FigS8
  load Tables TP

  T = TP.Temperature;
  f = TP.Force;
  speed = TP.Pullingspeed;

  % Select temperature and pulling speed classes (rips)
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  slow = speed < 50;
  normal = speed > 50 & speed<250;
  fast = speed > 250;

  [cl1,cl2,cl3,outliers] = clusterdefinitions(TP);
  selection = [fast,slow];
  speedtext = ["250-1000nm/s","10-50nm/s"];
  xx = linspace(10,25);
  figure('Name','FigS8');
  tcl = tiledlayout(2,1,"TileSpacing","compact");
  for i = 1:2
    nexttile;
    hold on
    plot(TP.Deltax(selection(:,i) & cl1),TP.Force(selection(:,i) & cl1),'.b');
    plot(TP.Deltax(selection(:,i) & cl2),TP.Force(selection(:,i) & cl2),'.r');
    plot(TP.Deltax(selection(:,i) & cl3),TP.Force(selection(:,i) & cl3),'.m');
    plot(TP.Deltax(selection(:,i) & outliers),TP.Force(selection(:,i) & outliers),'.','color',0.65*[1 1 1]);
    plot(xx,wlc(xx,.65,290,29.28),'k');
    xlim([5,30]);ylim([5,55]);
    title(speedtext(i));
    box on
    if i == 1
      legend('Cluster1','Cluster2','Cluster3','Outliers','Location','northwest');
    end
  end
  xlabel(tcl,'Δx (nm)'); ylabel(tcl,'Force (pN)');
  title(tcl,'Scatter plots for fast and slow pulling, all temperatures')
  fprintf('Figure S8\n')
  