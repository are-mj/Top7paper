function FigS2
  load Top7Tables.mat Tun Tre
  T = [Tun.Temperature;Tre.Temperature];
  speed =[Tun.Pullingspeed;Tre.Pullingspeed];

  figure;
  tcl = tiledlayout(2,1);nexttile;
  histogram(T,2.5:0.5:29.5);
  xlim([3,28])
  xlabel('°C')
  xl = [4,7,14,20,27];  % Class boundaries
  for i = 1:5;xline(xl(i),'-k');end
  set(gca,'xtick',xl)
  xlabel('°C')
  ylim([0,850])
  set(gca,'ytick',[0,400,800])
  title('Temperature histogram and class boundaries')

  nexttile;
  histogram(log10(speed));
  xl = [10,40,400,1000];
  set(gca,'xtick',log10(xl))
  set(gca,'xticklabel',xl)

  for i = 1:4
    xline(log10(xl(i)),'-k');
  end
  xlabel('nm/s')
  xlim(log10([8,1200]))
  ylim([0 2500])
  title('Pulling speed histogram and classes boundaries')
  set(gca,'ytick',[0,1000,2000])
  ylabel(tcl,'Number of events')