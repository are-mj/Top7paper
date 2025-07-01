function FigS7_ver2
% Apparent contour lengths
% v2: Split on clusters

  % Top7 WLC parameters
  P = 0.65;
  L0 = 29.28;

  load Tables.mat TP

  force = TP.Force;
  deltax = TP.Deltax;
  speed = TP.Pullingspeed;
  T = TP.Temperature;
  [cl1,cl2,cl3] = clusterdefinitions(TP);
  clusters = [cl1,cl2,cl3];
  
  % Select temperature and pulling speed classes (rips)
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  normal = speed > 50 & speed<250;

  force = TP.Force;  
  T = TP.Temperature;
  N = length(force);
  L = zeros(N,1);
  for i = 1:N
    deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);
    L(i) = L0*deltax(i)/deltax0;
  end

  edges = 6.5:38.5;
  figure('name','FigS6');
  % tl = tiledlayout(2,1);
  tl = tiledlayout(2,2,'TileSpacing','compact');
  fprintf('Figure 1S6_ver2\n')
  fprintf('Mean refolding contour lengths\n')
  fprintf('%14s %14s\n','Temperature','Mean length (nm)')
  for k = 1:4
    nexttile
    for j = 1:size(clusters,2)
      hold on;
      histogram(L(Tclass(:,k)&normal&clusters(:,j)),edges);
    end
    fprintf('%14s   %5.2f\n',Ttext(k),mean(L(Tclass(:,k)&normal)));
    title(Ttext(k));
    if k<=2
      set(gca,'XTick',[])
    end    
    if k==2
      legend('Cluster1','Cluster2','Cluster3','Location','northwest')
    end
    box on
  end
  title(tl,'Rip apparent contour length histograms, normal speed')
  xlabel(tl,'Contour lenghth (nm)')
  ylabel(tl,'Number of events')

end
