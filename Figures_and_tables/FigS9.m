function FigS9
  load Tables.mat TRIP

  % Top7 WLC parameters
  P = 0.65;
  L0 = 29.28;
  
  T = TRIP.Temperature;
  f = TRIP.Force;
  speed = TRIP.Pullingspeed;

  % Select temperature and pulling speed classes (rips)
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  slow = speed < 50;
  normal = speed > 50 & speed<250;
  fast =speed > 250;
  speedclasses = [fast,normal,slow];
  speedtext = ["250-1000nm/s","50-250nm/s","10-50nm/s"];

  [cl1,cl2,cl3] = clusterdefinitions(TRIP);  
  clusters = [cl1,cl2,cl3];
  deltax = TRIP.Deltax;
  force = TRIP.Force;  
  T = TRIP.Temperature;
  N = length(force);
  L = zeros(N,1);
  for i = 1:N
    deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);
    L(i) = L0*deltax(i)/deltax0;
  end

  % edges = 9.5:32.5;
  edges = 14.5:38.5;
  figure('name','FigS9');
  tl = tiledlayout(2,1,'TileSpacing','compact');
  fprintf('Figure S9\n')
  fprintf('Mean unfolding contour lengths\n')
  fprintf('%14s %8s   %16s\n','Pullingspeed','Cluster','Mean length (nm)')
  for i = [1,3]
    nexttile;
    hold on
    for j = 1:size(clusters,2)
      histogram(L(clusters(:,j) & speedclasses(:,i)),edges);
      fprintf('%14s %4d       %5.2f\n',speedtext(i),j,mean(L(clusters(:,j)&speedclasses(:,i))));
    end
    
    title(speedtext(i));
    if i == 3
      legend('Cluster1','Cluster2','Cluster3',Location="northwest");
    end
    if i == 1
      set(gca,'XTick','');
    end
    box on
  end

  xlabel(tl,'Contour length (nm)')
  title(tl,'Unfolding contour length histograms for fast and slow pulling')
