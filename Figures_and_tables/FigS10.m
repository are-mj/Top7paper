function FigS10
  load Tables.mat TZIP

  % Top7 WLC parameters
  P = 0.65;
  L0 = 29.28;
  
  T = TZIP.Temperature;
  force = TZIP.Force;
  deltax = -TZIP.Deltax;
  speed = TZIP.Pullingspeed;

  % Select temperature and pulling speed classes (rips)
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  slow = speed < 50;
  normal = speed > 50 & speed<250;
  fast =speed > 250;
  speeds = [fast,normal,slow];
  speedtext = ["250-1000nm/s","50-250nm/s","10-50nm/s"];

  N = length(force);
  L = zeros(N,1);
  for i = 1:N
    deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);
    L(i) = L0*deltax(i)/deltax0;
  end

  edges = 14.5:38.5;
  figure('name','FigS10');
  tl = tiledlayout(2,1,'TileSpacing','compact');
  fprintf('Figure S10\n')
  fprintf('Mean refolding contour lengths\n')
  fprintf('%14s %16s\n','Pullingspeed','Mean length (nm)')  
  for k = [1,3]
    nexttile
    histogram(L(speeds(:,k)),edges)
    fprintf('%14s   %5.2f\n',speedtext(k),mean(L(speeds(:,k))));
    title(speedtext(k));
    if k<=2
      set(gca,'XTick',[])
    end
  end    
  title(tl,'Zip apparent contour length histograms')
  xlabel(tl,'Contour lenghth (nm)')
  ylabel(tl,'Number of events')



  % load Top7Tables.mat Tre
  % Tre = Tre(~isnan(Tre.Temperature),:);
  % deltax = Tre.Deltax;
  % force = Tre.Force;
  % T = Tre.Temperature;
  % speed = Tre.Pullingspeed;
  % % [~,Cluster1,Cluster2] = no_outliers(Tre);
  % 
  % fast = speed>500;
  % normal = speed<500 & speed>50;
  % slow = speed<14;
  % 
  % % Calculate contour lengths:
  % n = numel(force);
  % L = zeros(n,1);
  % P = 0.65;
  % L0 = 29.28;  
  % for i = 1:n
  %   deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);
  %   L(i) = L0*deltax(i)/deltax0;
  % end
  % 
  % edges = 14.5:32.5;
  % figure('name','FigS10');
  % tl = tiledlayout(2,1,'TileSpacing','compact');  
  % nexttile;
  % histogram(L(fast),edges);
  % title("250-1000 nm/s")
  % set(gca,'xticklabels',[])
  % xlim([15,35])
  % ylim([0,20])
  % 
  % nexttile;
  % histogram(L(slow),edges);
  % title("10-50 nm/s")  
  % xlim([15,35])
  % ylim([0,20])
  % 
  % xlabel(tl,'Contour length (nm)')
  % title(tl,'Refolding contour length histograms for fast and slow pulling')
