function FigS6
  load Top7Tables.mat Tun
  Tun = Tun(no_outliers(Tun),:);
  % Remove rips with no recorded temperature
  ok = ~isnan(Tun.Temperature);
  deltax = Tun.Deltax(ok);
  force = Tun.Force(ok);
  T = Tun.Temperature(ok);
  speed = Tun.Pullingspeed(ok);
  nok = sum(ok);

  fast = speed>500;
  normal = speed<500 & speed>50;
  slow = speed<14;

  Tclass = [4<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=27];
  Ttext = ["4°C<T≤7°C","7°C<T≤14°C","14°C<T≤20°C","20°C<T≤27°C"];
 
  P = 0.65;
  L0 = 29.28;

  [~,Cluster1,Cluster2] = no_outliers(Tun(ok,:));

  L = zeros(nok,1);
  for i = 1:nok
    deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);
    L(i) = L0*deltax(i)/deltax0;
  end

  edges = 9.5:32.5;
  figure('name','FigS2');
  % tl = tiledlayout(2,1);
  tl = tiledlayout(2,2,'TileSpacing','compact');
  fprintf('Mean unfolding contour lengths\n')
  fprintf('%14s %8s    %14s\n','Temperature','Cluster','Mean length (nm)')
  for k = 1:4
    nexttile
    histogram(L(Cluster1&Tclass(:,k)&normal),edges)
    fprintf('%14s %4s       %5.2f\n',Ttext(k),'1',mean(L(Cluster1&Tclass(:,k)&normal)));
    hold on;
    histogram(L(Cluster2&Tclass(:,k)&normal),edges)
    fprintf('%14s %4s       %5.2f\n',"     ""     ",'2',mean(L(Cluster2&Tclass(:,k)&normal)));
    title(Ttext(k));
    if k==1
      legend('Cluster1','Cluster2','Location','northwest')
    end
    if k<=2
      set(gca,'XTick',[])
    end
    xlim([15,35])
    ylim([0,110])
  end
  title(tl,'Unfolding contour length histograms, normal speed')
  xlabel(tl,'Contour lenghth (nm)')
  ylabel(tl,'Number of events')
  % fprintf('Median(L0), Cluster1: %6.1f\n',median(L(Cluster1)))
  % fprintf('Median(L0), Cluster2: %6.1f\n',median(L(Cluster2)))
end

