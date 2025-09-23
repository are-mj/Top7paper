function FigS6
  load Tables TRIP
  [cl1,cl2,cl3,outliers,clustershapes] = clusterdefinitions(TRIP);
  figure('Name','FigS6'); hold on
  plot(TRIP.Deltax(cl1),TRIP.Force(cl1),'.b');
  plot(TRIP.Deltax(cl2),TRIP.Force(cl2),'.r');
  plot(TRIP.Deltax(cl3),TRIP.Force(cl3),'.m');
  plot(TRIP.Deltax(outliers),TRIP.Force(outliers),'.','color',0.65*[1 1 1]);
  c = get(gca,'children');
  for i = 1:length(c)
    c(i).MarkerSize = 4;
  end

  xx = linspace(10,25);
  plot(xx,wlc(xx,.65,290,29.96),'k');
  hold on;
  for i = 1:3 
    plot(clustershapes(i),'facealpha',0,'facecolor','w');end
  box on;
  ylim([5,55]); 
  xlim([5 30]);

  % text(6,45,sprintf('All rips: %d',height(TRIP)));
  text(6,45,sprintf('%d outliers',sum(outliers)));
  text(12.7,51,sprintf('Cluster 1: %d rips',sum(cl1)));
  text(20.5,14,sprintf('Cluster 2: %d rips',sum(cl2)));
  text(20.5,9,sprintf('Cluster 3: %d rips',sum(cl3)));
  title('Scatter plot of unfolding force and Δx. All unfoldings.');
  xlabel('Δx (nm)'); ylabel('Force (pN)');
  fprintf('Figure S3\n')
  % legend('Cluster 1','Cluster 2','Cluster 3','Outliers','WLC','location','northwest');

  