function FigS5
  load Tables TRIP

  T = TRIP.Temperature;
  f = TRIP.Force;
  speed = TRIP.Pullingspeed;

  % Select temperature and pulling speed classes (rips)
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  normal = speed > 50 & speed<250;
  [cl1,cl2,cl3,outliers] = clusterdefinitions(TRIP);
  figure('Name','FigS5');
  tcl = tiledlayout(2,2,"TileSpacing","compact");
  for i = 1:4
    nexttile;
    hold on
    plot(TRIP.Deltax(Tclass(:,i)&normal&cl1),TRIP.Force(Tclass(:,i)&normal&cl1),'.b');
    plot(TRIP.Deltax(Tclass(:,i)&normal&cl2),TRIP.Force(Tclass(:,i)&normal&cl2),'.r');
    plot(TRIP.Deltax(Tclass(:,i)&normal&cl3),TRIP.Force(Tclass(:,i)&normal&cl3),'.m');
    plot(TRIP.Deltax(Tclass(:,i)&normal&outliers),TRIP.Force(Tclass(:,i)&normal&outliers),'.','color',0.65*[1 1 1]);
    c = get(gca,'children');
    for j = 1:length(c)
      c(j).MarkerSize = 4;
    end
    xx = linspace(10,25);
    % plot(xx,wlc(xx,.65,290,29.28),'k');
    plot(xx,wlc(xx,.65,290,29.96),'k');
    box on;
    ylim([5,55]); 
    xlim([5 30]);
    title(Ttext(i));
    if i < 3
      set(gca,'xticklabel','')
    end
  end
  xlabel(tcl,'Δx (nm)'); ylabel(tcl,'Force (pN)');
  title(tcl,'Scatter plots and clusters, normal pulling speed')
  fprintf('Figure S5\n')