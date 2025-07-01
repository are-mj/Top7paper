function FigS3
  load Tables TP
  [cl1,cl2,cl3,outliers,clustershapes] = clusterdefinitions(TP);
  figure('Name','FigS3'); hold on
  plot(TP.Deltax(cl1),TP.Force(cl1),'.b');
  plot(TP.Deltax(cl2),TP.Force(cl2),'.r');
  plot(TP.Deltax(cl3),TP.Force(cl3),'.m');
  plot(TP.Deltax(outliers),TP.Force(outliers),'.','color',0.65*[1 1 1]);
  c = get(gca,'children');
  for i = 1:length(c)
    c(i).MarkerSize = 4;
  end


  xx = linspace(10,25);
  % plot(xx,wlc(xx,.65,290,29.28),'k');
  plot(xx,wlc(xx,.65,290,29.96),'k');
  hold on;
  for i = 1:3; 
    plot(clustershapes(i),'facealpha',0,'facecolor','w');end
  box on;
  ylim([5,55]); 
  xlim([5 30]);
  title('Scatter plot of unfolding force and Δx. All unfoldings.');
  xlabel('Δx (nm)'); ylabel('Force (pN)');
  fprintf('Figure S3\n')
  legend('Cluster 1','Cluster 2','Cluster 3','Outliers','WLC','location','northwest');

  