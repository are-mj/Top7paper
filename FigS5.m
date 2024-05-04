function FigS5
  load Top7Tables Tun
  [ok,Cluster1,Cluster2] = no_outliers(Tun);
  force = Tun.Force;
  T = Tun.Temperature;
  dx = Tun.Deltax;
  speed = Tun.Pullingspeed;
  normal = speed<500 & speed>50;
  Tclass = [4<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=27];
  Ttext = ["4°C<T≤7°C","7°C<T≤14°C","14°C<T≤20°C","20°C<T≤27°C"];  

  xx = linspace(10,25);
  wlc_curve = wlc(xx,0.65,288,29.28);
  figure;
  tcl = tiledlayout(2,2,'TileSpacing','compact');
  for i = 1:4
    nexttile;
    sel = normal&Tclass(:,i);
    plot(dx(sel&Cluster1),force(sel&Cluster1),'.b', ...
      dx(sel&Cluster2),force(sel&Cluster2),'.r');
    hold on;
    plot(dx(sel&~ok),force(sel&~ok),'.','color',0.7*[1,1,1]);
    plot(xx,wlc_curve,'k')
    ylim([5,55])
    title(Ttext(i));
  end
  xlabel(tcl,'Δx (nm)')
  ylabel(tcl,'Force (pN)')