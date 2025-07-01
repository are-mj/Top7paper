function Fig2A

  load Tables.mat TP TR  % 121 files

  conversion = 0.1439326;  % Energy units kcal/kmol 

  % Select pulling trace events (rips)
  T = TP.Temperature;
  f = TP.Force;
  speed = TP.Pullingspeed;
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  % slow = speed < 30;
  % normal = speed > 70 & speed<140;
  % fast = speed > 360;
  slow = speed < 50;
  normal = speed > 50 & speed<250;
  fast = speed > 250;
  [cl1,cl2,cl3] = clusterdefinitions(TP);
  ok = cl1|cl2|cl3;
  selectionP = [normal & Tclass(:,1),normal & Tclass(:,4)];
  texts = Ttext([1,4]);
  clusters = [cl1,cl2,cl3];

  % Select relaxing trace events (zips)
  T = TR.Temperature;
  f = TR.Force;
  speed = TR.Pullingspeed;
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=21,20<T&T<30];
  Ttext = ["3°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=30°C"];
  slow = speed < 30;
  normal = speed > 70 & speed<140;
  fast = speed > 360;
  selectionR = [normal & Tclass(:,1),normal & Tclass(:,4)]; 

  fprintf('Figure 2A\n')
  fprintf("Crooks' ΔG for normal pulling speed\n" )
  fprintf('%14s %8s   %12s\n','Temperature','Cluster','ΔG (kcal/mol)')  

  figure('Name','Fig2A');
  tcl = tiledlayout(2,1,"TileSpacing","compact");
  for i = 1:2
    [DG,DGstd] = fit_Crooks(TP,TR,selectionP(:,i),selectionR(:,i),clusters,texts(i),1);

    % set line color to black:
    c = get(gca,'children');
    for k = 1:2:8
      set(c(k),'color','k');
    end
    if i > 1
      hl = legend('');
      delete(hl)
    end
    ylim([0,0.25])
    set(gca,'ytick',[0:0.1:0.3]);
    fprintf('%14s %4s       %5.2f±%4.2f\n',Ttext(i),'1',DG(1),DGstd(1));
    for k = 2:numel(DG)
      fprintf('%14s %4d       %5.2f±%4.2f\n',"     ""     ",k,DG(k),DGstd(k));
    end
  end
  title(tcl,'Crooks work histograms, normal pulling speed')
  xlabel(tcl,'Work (kcal/mol)')
  ylabel(tcl,'Probality density')
end
