function Fig2A

  load Top7Tables.mat Tun Tre  % 121 files

  [~,Cluster1,Cluster2,par] = no_outliers(Tun);
  Clusters = [Cluster1,Cluster2];
  X0 = [Tun.Deltax,Tun.Force];  % Uscaled parameters
  X = [Tun.Deltax*par.scaling,Tun.Force];  % Scaled
  
  speed = Tun.Pullingspeed;
  fast = speed>500;
  normal = speed<500 & speed>50;
  slow = speed<14;
  speed = Tre.Pullingspeed;
  speedtext = ["fast","normal","slow"];
  
  T = Tun.Temperature;
  Tclass = [4<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=27];
  Ttext = ["4°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=27°C"];
  ucase(1).selected = Tclass(:,1)&fast;
  ucase(2).selected = Tclass(:,4)&fast;
  ucase(3).selected = Tclass(:,1)&normal;
  ucase(4).selected = Tclass(:,2)&normal;
  ucase(5).selected = Tclass(:,3)&normal;
  ucase(6).selected = Tclass(:,4)&normal;
  ucase(7).selected = Tclass(:,1)&slow;
  ucase(8).selected = Tclass(:,4)&slow;
  
  ucase(1).text = Ttext(1);
  ucase(2).text = Ttext(4);
  ucase(3).text = Ttext(1);
  ucase(4).text = Ttext(2);
  ucase(5).text = Ttext(3);
  ucase(6).text = Ttext(4);
  ucase(7).text = Ttext(1);
  ucase(8).text = Ttext(4);

  % refold cases:
  speed = Tre.Pullingspeed;
  T = Tre.Temperature;
  fast = speed>500;
  normal = speed<500 & speed>50;
  slow = speed<14;
  Tclass = [4<T&T<=7 , 7<T&T<=14 , 14<T&T<=19,19<T&T<=24];
  
  rcase(1).selected = Tclass(:,1)&fast;
  rcase(2).selected = Tclass(:,4)&fast;
  rcase(3).selected = Tclass(:,1)&normal;
  rcase(4).selected = Tclass(:,2)&normal;
  rcase(5).selected = Tclass(:,3)&normal;
  rcase(6).selected = Tclass(:,4)&normal;
  rcase(7).selected = Tclass(:,1)&slow;
  rcase(8).selected = Tclass(:,4)&slow;
  
  rcase(1).text = strcat("Refolding, ",speedtext(1),", ",Ttext(1));
  rcase(2).text = strcat("Refolding, ",speedtext(1),", ",Ttext(4));
  rcase(3).text = strcat("Refolding, ",speedtext(2),", ",Ttext(1));
  rcase(4).text = strcat("Refolding, ",speedtext(2),", ",Ttext(2));
  rcase(5).text = strcat("Refolding, ",speedtext(2),", ",Ttext(3));
  rcase(6).text = strcat("Refolding, ",speedtext(2),", ",Ttext(4));
  rcase(7).text = strcat("Refolding, ",speedtext(3),", ",Ttext(1));
  rcase(8).text = strcat("Refolding, ",speedtext(3),", ",Ttext(4));

  figure('Name','Fig2A');
  tcl = tiledlayout(2,1,"TileSpacing","compact");
  fprintf("Crooks' ΔG for normal pulling speed\n" )
  fprintf('%14s %8s   %12s\n','Temperature','Cluster','ΔG (kcal/mol)')
  for i = [3,6]
   [DG,DGstd] = fit_Crooks(Tun,Tre,ucase(i),rcase(i),Clusters,1);
   % set line color to black:
   c = get(gca,'children');
   for k = 1:2:6
     set(c(k),'color','k');
   end
   if i == 3
     legend(c([6:-2:2,1]),'Refolding','Low force unfolding',...
       'High force unfolding','Fitted Gaussians')
   else
     hl = legend('');
     delete(hl)
   end

   fprintf('%14s %4s       %5.2f±%4.2f\n',Ttext(i-2),'1',DG(1),DGstd(1));
   fprintf('%14s %4s       %5.2f±%4.2f\n',"     ""     ",'2',DG(2),DGstd(2));
  end

  % Remove unneeded tick labels
  % nexttile(1);
  % set(gca,'XTick',[]);
  % nexttile(2);
  % set(gca,'XTick',[]);
  % set(gca,'Ytick',[]);
  % nexttile(4);
  % set(gca,'Ytick',[]);
  % lgd = findobj('type', 'legend');
  % delete(lgd([1,2,4]));


  title(tcl,'Crooks work histograms, normal pulling speed')
  xlabel(tcl,'Work (kcal/mol)')
  ylabel(tcl,'Probality density')
