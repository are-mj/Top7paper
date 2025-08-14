function FigS3
  load Tables TRIP TZIP
  figure('Name','FigS3'); 
  xx = linspace(0,25);
  tl = tiledlayout(1,2,"TileSpacing","compact");
  nexttile;
    plot(TRIP.Deltax,TRIP.Force,'.','MarkerSize',4);
    hold on;
    plot(xx,wlc(xx,.65,290,29.96),'k');
    title('A: Rips')
    xlabel('Δx (nm)'); ylabel('Force (pN)');
    xlim([5,30]);ylim([5,55])
  nexttile
    plot(-TZIP.Deltax,TZIP.Force,'.','MarkerSize',4);
    hold on;
    plot(xx,wlc(xx,.65,290,29.96),'k');    
    title('B: Zips')
    xlabel('Δx (nm)'); ylabel('Force (pN)');
    ylim([3,15]); 
    xlim([0 30]);

  title(tl,'Rip/zip scatter plots.  All experiments')
  
  pos = get(gcf,'Position');
  set(gcf,"Position",pos.*[1 1 1.6 1])

  % plot(-TZIP.Deltax,TZIP.Force,'.','MarkerSize',5);
  % hold on
  % xx = linspace(0,25);
  % plot(xx,wlc(xx,.65,290,29.96),'k');
  % hold on;
  % ylim([3,15]); 
  % xlim([0 30]);
  % title('Zip force vs Δx scatter plot. All experiments.');
  % xlabel('Δx (nm)'); ylabel('Force (pN)');
  % fprintf('Figure S3A\n')
  % legend('Cluster 1','Cluster 2','Cluster 3','Outliers','WLC','location','northwest');

end

function [cl1,outliers] = zip_clusters(TZIP)
% Define outier zips
  cl1 = TZIP.Force > 3 & TZIP.Force < 11 & TZIP.Deltax < -6 ...
    & TZIP.Deltax > -25;
  outliers = ~cl1;
end