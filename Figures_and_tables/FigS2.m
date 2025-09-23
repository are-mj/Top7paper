function FigS2

  load Tables TRIP TZIP
  figure
  tl = tiledlayout(1,2,"TileSpacing","compact");
  nexttile;
    histogram(TRIP.Force,0.5:55.5);
    text(40,500,sprintf('%d rips',height(TRIP)));
    title('A: Rips')
    xlabel('Rip force (pN)')
    ylabel('Number of rips')
  nexttile
    histogram(TZIP.Force,0.5:0.5:20.5);
    text(15,2000,sprintf('%d zips',height(TZIP)));
    title('B: Zips')
    xlabel('Zip force (pN)')
    ylabel('Number of zips')
  title(tl,'Histograms of rip and zip forces.  All experiments')
  pos = get(gcf,'Position');
  set(gcf,"Position",pos.*[1 1 1.6 .7])