function FigS7
  load Top7Tables.mat Tre
  Tre = Tre(no_outliers(Tre),:);
  % Remove rips with no recorded temperature
  ok = ~isnan(Tre.Temperature);
  deltax = Tre.Deltax(ok);
  force = Tre.Force(ok);
  T = Tre.Temperature(ok);
  speed = Tre.Pullingspeed(ok);
  nok = sum(ok);

  fast = speed>500;
  normal = speed<500 & speed>50;
  slow = speed<14;

  Tclass = [4<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=27];
  Ttext = ["4°C<T≤7°C","7°C<T≤14°C","14°C<T≤20°C","20°C<T≤27°C"];
 
  P = 0.65;
  L0 = 29.28;

  [~,Cluster1,Cluster2,par] = no_outliers(Tre(ok,:));
  X = [deltax*par.scaling,force];  % Scaled
  labels = dbscan(X,par.epsilon,par.minpts);

  L = zeros(nok,1);
  for i = 1:nok
    deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);
    L(i) = L0*deltax(i)/deltax0;
  end

  edges = 9.5:32.5;
  figure('name','FigS2B');
  % tl = tiledlayout(2,1);
  tl = tiledlayout(2,2,'TileSpacing','compact');
  fprintf('Mean refolding contour lengths\n')
  fprintf('%14s %14s\n','Temperature','Mean length (nm)')
  for k = 1:4
    nexttile
    histogram(L(Cluster1&Tclass(:,k)&normal),edges)
    fprintf('%14s   %5.2f\n',Ttext(k),mean(L(Cluster1&Tclass(:,k)&normal)));
    hold on;
    histogram(L(Cluster2&Tclass(:,k)&normal),edges)
    title(Ttext(k));
    if k<=2
      set(gca,'XTick',[])
    end
    xlim([10,35])
    ylim([0,65])
  end
  title(tl,'Refolding contour length histograms, normal speed')
  xlabel(tl,'Contour lenghth (nm)')
  ylabel(tl,'Number of events')

end
