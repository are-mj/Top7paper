function FigS3
  load Top7Tables.mat Tun;
  [ok,Cluster1,Cluster2] = no_outliers(Tun);
  figure; hold on
  plot(Tun.Deltax(Cluster1),Tun.Force(Cluster1),'.b');
  plot(Tun.Deltax(Cluster2),Tun.Force(Cluster2),'.r');
  plot(Tun.Deltax(~ok),Tun.Force(~ok),'.','color',0.65*[1 1 1]);

  xx = linspace(10,25);
  % plot(xx,wlc(xx,.65,290,29.28),'k');
  plot(xx,wlc(xx,.65,290,29.96),'k');
  box on;
  ylim([5,55]); 
  title('Scatter plot of unfolding force and Δx. All unfoldings.');
  xlabel('Δx (nm)'); ylabel('Force (pN)');
  legend('Cluster 1','Cluster 2','Outliers','WLC','location','northwest');

  