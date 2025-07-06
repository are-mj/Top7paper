function FigS2

  load Tables TRIP
  T = TRIP.Temperature;
  speed = TRIP.Pullingspeed;

  figure('Name','FigS2');
  tcl = tiledlayout(2,1);nexttile;
  histogram(T,2.5:0.5:30.5);
  xlim([3,28])
  xlabel('°C')
  xline([3,7,14,20,30])
  xlabel('°C')
  title('Temperature histogram and class boundaries')

  nexttile;
  histogram(log10(speed));
  xlim(log10([8,1200]))
  xl = [10,100,1000];
  set(gca,'xtick',log10(xl))
  set(gca,'xticklabel',xl)
  xline(log10([10 30 250 1000]))
  
  xlabel('nm/s')
  title('Pulling speed histogram and class boundaries')
  ylabel(tcl,'Number of events')
  fprintf('Figure S2\n')