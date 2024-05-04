function FigS14

  load Top7Tables.mat TunTop7BSA TunTop7Top7

  % Remove rows without temperature info:
  TunTop7BSA = TunTop7BSA(~isnan(TunTop7BSA.Temperature),:);
  TunTop7Top7 = TunTop7Top7(~isnan(TunTop7Top7.Temperature),:);

  % TunTop7Top7 has too few data points to define outliers
  % Lump with TunTop7BSA for defining outliers:
  Tun_both = [TunTop7BSA;TunTop7Top7];
  n_both = height(Tun_both);

  % Logical arrays:
  [ok,Cluster1,Cluster2] = no_outliers(Tun_both);
  BSArows = [true(height(TunTop7BSA),1);false(height(TunTop7Top7),1)];
  Top7rows = ~BSArows;

  % Clusters = [Cluster1,Cluster2];

  deltax = Tun_both.Deltax;
  force = Tun_both.Force;
  T = Tun_both.Temperature;

  % speed = Tun_both.Pullingspeed;  % All data are at normal speed
  % normal = speed<500 & speed>50;

  P = 0.65;
  L0 = 29.28;
  L = zeros(n_both,1);
  for i = 1:n_both
    deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);
    L(i) = L0*deltax(i)/deltax0;
  end

  L0_Top71 = mean(L(Top7rows&Cluster1));
  L0_Top72 = mean(L(Top7rows&Cluster2));
  L0_BSA1 = mean(L(BSArows&Cluster1));
  L0_BSA2 = mean(L(BSArows&Cluster2));  

  xx = linspace(10,23);

  figure('name','Fig4C');
  tl = tiledlayout(2,1,'TileSpacing','compact');
  nexttile; hold on;
  plot(Tun_both.Deltax(Cluster1&Top7rows),Tun_both.Force(Cluster1&Top7rows),'.b', ...
      Tun_both.Deltax(Cluster2&Top7rows),Tun_both.Force(Cluster2&Top7rows),'.r');
  plot(Tun_both.Deltax(~ok&Top7rows),Tun_both.Force(~ok&Top7rows),'.','color',0.65*[1 1 1]);
  plot(xx,wlc(xx,.65,290,L0_Top71),'k');
  plot(xx,wlc(xx,.65,290,L0_Top72),'--k');
  ylim([5,55]);
  xlim([10,25]);
  box on
  title('Top7/Top7')
  legend('Cluster1','Cluster2','Outliers','location','northwest')

  nexttile; hold on;
  plot(Tun_both.Deltax(Cluster1&BSArows),Tun_both.Force(Cluster1&BSArows),'.b', ...
      Tun_both.Deltax(Cluster2&BSArows),Tun_both.Force(Cluster2&BSArows),'.r');
  plot(Tun_both.Deltax(~ok&BSArows),Tun_both.Force(~ok&BSArows),'.','color',0.65*[1 1 1]);
  plot(xx,wlc(xx,.65,290,L0_BSA1),'k');
  plot(xx,wlc(xx,.65,290,L0_BSA2),'--k'); 
  ylim([5,55]);
  xlim([10,25]);
  box on
  title('Top7/BSA')

  xlabel(tl,'Δx (nm)')
  ylabel(tl,'Unfolding force (pN)')
  title(tl,'Force vs Δx scatter plots')

  solvent = [Top7rows,BSArows];
  solventtext = ["Top7","BSA"];
  Clusters = [Cluster1,Cluster2];
  Clustertext = ["Cluster1","Cluster2"];

  fprintf('The black curves are WLC curves with contour lengths equal to the mean contour lengths per cluster.\n');
  fprintf('\n');
  Lmean = zeros(2,2);
  Lstd = zeros(2,2);
  fprintf('Contour length statistics (all temperatures)\n')
  fprintf('%7s  %8s  %8s %12s\n','Solvent','Cluster','Length (nm)','Datapoints')
  for i = 1:2  % Solvent
    for j = 1:2 % Cluster
        selection = solvent(:,i)&Clusters(:,j);
        n = sum(selection);
        Lmean(i,j) = mean(L(selection));
        Lstd(i,j) = std(L(selection));
        fprintf('%7s  %8s    %4.1f±%3.1f  %8d\n',solventtext(i),Clustertext(j),Lmean(i,j),Lstd(i,j),n);
      end
    end
  end 