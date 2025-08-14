function FigS2

  load Tables TRIP TZIP
  figure
  tl = tiledlayout(1,2,"TileSpacing","compact");
  nexttile;
    histogram(TRIP.Force,0.5:55.5);
    title('A: Rips')
    xlabel('Rip force (pN)')
    ylabel('Number of rips')
  nexttile
    histogram(TZIP.Force,0.5:0.5:20.5);
    title('B: Zips')
    xlabel('Zip force (pN)')
    ylabel('Number of zips')
  title(tl,'Histograms of rip and zip forces.  All experiments')
  pos = get(gcf,'Position');
  set(gcf,"Position",pos.*[1 1 1.6 .7])