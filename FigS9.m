function FigS9
  load Top7Tables.mat Tun
  Tun = Tun(~isnan(Tun.Temperature),:);
  deltax = Tun.Deltax;
  force = Tun.Force;
  T = Tun.Temperature;
  speed = Tun.Pullingspeed;
  [~,Cluster1,Cluster2] = no_outliers(Tun);

  fast = speed>500;
  normal = speed<500 & speed>50;
  slow = speed<14;

  % Calcukate contour lengths:
  n = numel(force);
  L = zeros(n,1);
  P = 0.65;
  L0 = 29.28;  
  for i = 1:n
    deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);
    L(i) = L0*deltax(i)/deltax0;
  end

  edges = 14.5:32.5;
  figure('name','FigS9');
  tl = tiledlayout(2,1,'TileSpacing','compact');  
  nexttile;
  histogram(L(Cluster1&fast),edges);
  hold on;
  histogram(L(Cluster2&fast),edges);
  legend('Cluster1','Cluster2','Location','northwest');
  title("1000 nm/s")
  set(gca,'xticklabels',[])
  xlim([15,35])
  ylim([0,23])

  nexttile;
  histogram(L(Cluster1&slow),edges);
  hold on;
  histogram(L(Cluster2&slow),edges);
  title("10 nm/s")  
  xlim([15,35])
  ylim([0,23])

  xlabel(tl,'Contour length (nm)')
  title(tl,'Unfolding contour length histograms for fast and slow pulling')
