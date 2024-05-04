function FigS10
  load Top7Tables.mat Tre
  Tre = Tre(~isnan(Tre.Temperature),:);
  deltax = Tre.Deltax;
  force = Tre.Force;
  T = Tre.Temperature;
  speed = Tre.Pullingspeed;
  % [~,Cluster1,Cluster2] = no_outliers(Tre);

  fast = speed>500;
  normal = speed<500 & speed>50;
  slow = speed<14;

  % Calculate contour lengths:
  n = numel(force);
  L = zeros(n,1);
  P = 0.65;
  L0 = 29.28;  
  for i = 1:n
    deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);
    L(i) = L0*deltax(i)/deltax0;
  end

  edges = 14.5:32.5;
  figure('name','FigS10');
  tl = tiledlayout(2,1,'TileSpacing','compact');  
  nexttile;
  histogram(L(fast),edges);
  title("1000 nm/s")
  set(gca,'xticklabels',[])
  xlim([15,35])
  ylim([0,20])

  nexttile;
  histogram(L(slow),edges);
  title("10 nm/s")  
  xlim([15,35])
  ylim([0,20])

  xlabel(tl,'Contour length (nm)')
  title(tl,'Refolding contour length histograms for fast and slow pulling')
