function FigS15
  load Top7Tables.mat TunTop7BSA  TunTop7Top7

  % Remove rows without temperature info:
  TunTop7BSA = TunTop7BSA(~isnan(TunTop7BSA.Temperature),:);
  TunTop7Top7 = TunTop7Top7(~isnan(TunTop7Top7.Temperature),:);

  % TunTop7Top7 has too few data points to define clusters
  % Lump with TunTop7BSA for defining outliers:
  Tun_both = [TunTop7BSA;TunTop7Top7];
  n_both = height(Tun_both);

  % Logical arrays:
  [~,Cluster1,Cluster2] = no_outliers(Tun_both);
  BSArows = [true(height(TunTop7BSA),1);false(height(TunTop7Top7),1)];
  Top7rows = ~BSArows;

  Clusters = [Cluster1,Cluster2];
  Clustertext = ["Cluster1","Cluster2"];

  deltax = Tun_both.Deltax;
  force = Tun_both.Force;
  T = Tun_both.Temperature;
  Tclass = [4<T&T<=14 , 14<T&T<=27];
  Ttext = ["4°C<T≤14°C","14°C<T≤27°C"];

  speed = Tun_both.Pullingspeed;
  normal = speed<500 & speed>50;

  P = 0.65;
  L0 = 29.28;
  L = zeros(n_both,1);
  for i = 1:n_both
    % deltax0 is the value correstponding to the force, assuming nominal
    % parameters for Top7:
    deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);

    % The WLC function is a function of deltax/L, so the wlc model giving
    % wlc(force(i)) = deltax(i) has L(i) given by:    
    L(i) = L0*deltax(i)/deltax0;
  end

  edges = 9.5:32.5;  

  figure('name','FigS15');
  tl = tiledlayout(2,1,'TileSpacing','compact');
  nexttile
  histogram(L(Clusters(:,1)&Tclass(:,1)&normal&Top7rows),edges)
  hold on;
  histogram(L(Clusters(:,2)&Tclass(:,1)&normal&Top7rows),edges)
  title(Ttext(1));
  legend('Cluster1','Cluster2','Location','northeast')
  xlim([15,35])
  ylim([0,16])
  
  nexttile
  histogram(L(Clusters(:,1)&Tclass(:,1)&normal&BSArows),edges)
  hold on;
  histogram(L(Clusters(:,2)&Tclass(:,1)&normal&BSArows),edges)
  % title(Ttext(k));
  % legend('Cluster1','Cluster2','Location','northwest')
  xlim([15,35])
  ylim([0,200])
  

  title(tl,'Contour length histograms')
  xlabel(tl,'Contour length (nm)')
  ylabel(tl,'Top7/BSA                         Top7/Top7')

