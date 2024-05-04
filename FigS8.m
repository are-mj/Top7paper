function FigS8
  load Top7Tables.mat Tun;
  [ok,Cluster1,Cluster2] = no_outliers(Tun);

  f = Tun.Force;
  speed = Tun.Pullingspeed;
  T = Tun.Temperature;
  fast = speed>500;
  normal = speed<500 & speed>50;
  slow = speed<14;

  xx = linspace(10,25);
  figure;
  tl = tiledlayout(2,1,"TileSpacing","compact");
  nexttile
  hold on
  plot(Tun.Deltax(fast&Cluster1),Tun.Force(fast&Cluster1),'.b');
  plot(Tun.Deltax(fast&Cluster2),Tun.Force(fast&Cluster2),'.r');
  plot(Tun.Deltax(fast&~ok),Tun.Force(fast&~ok),'.','color',0.65*[1 1 1]);
  plot(xx,wlc(xx,.65,290,29.28),'k');
  xlim([10,28]);ylim([7,50]);
  title('1000 nm/s')
  box on
  nexttile
  hold on;
  plot(Tun.Deltax(slow&Cluster1),Tun.Force(slow&Cluster1),'.b');
  plot(Tun.Deltax(slow&Cluster2),Tun.Force(slow&Cluster2),'.r');
  plot(Tun.Deltax(slow&~ok),Tun.Force(slow&~ok),'.','color',0.65*[1 1 1]);
  plot(xx,wlc(xx,.65,290,29.28),'k');
  xlim([10,28]);ylim([7,50]);
  box on
  title('10 nm/s')

  xlabel(tl,'Δx (nm)'); ylabel(tl,'Force (pN)');