function [bellth,rms,n,Fplot,pdplot,pdtot,Fbins,w] = fitBell(tbl,clusters,plotting)
% Fit the Bell function to analysis results table and clusters

  % Allocate variables
  unfold = tbl.Fdot(1) > 0;
  if unfold
    Fplot = linspace(5,55,500)';
    dF = 1;   % Force histogram spacing
    % dx0 = 2;log10k0 = -3; theta0 = [dx0;log10k0];
    dx0 = 1;log10k0 = -3; theta0 = [dx0;log10k0];
    allclusters = any(clusters,2);
    fitfunction = @fit_Bell_unfold;
    % tracetype = 'Unfolding';
  else
    Fplot = linspace(3,18,500)';
    dF = 0.5;   % Force histogram spacing
    theta0 = [4;4];
    allclusters = true(size(tbl.Force));
    fitfunction = @fit_Bell_refold;
    % tracetype = 'Refolding';
  end
  
  force = tbl.Force(allclusters);
  [pdtot,Fbins] = probdens(force,dF);
  Ftot = (Fbins(1:end-1)+Fbins(2:end))/2;  % bin midpoints
  ntot = numel(Ftot);
  
  n = sum(clusters);  % Number of rips in each cluster
  n = n(n>8);
  n_clusters = size(n,2);
  if n_clusters == 0
    bellth = NaN;
    rms = NaN;
    n = NaN;
    Fplot= NaN;
    pdplot = NaN;
    return
  end

  % nboot = 200;
  plotpoints = 500;
  bellthR = zeros(2,n_clusters);
  bellci = zeros(2,n_clusters,2);
  pdplot = zeros(plotpoints,n_clusters);
  pdcalc = zeros(ntot,n_clusters);
  for i = 1:n_clusters
    [pd_obs,edges] = probdens(tbl.Force(clusters(:,i)),dF);
    force = (edges(1:end-1)+edges(2:end))/2;
    Tmean = mean(tbl.Temperature(clusters(:,i)),'omitmissing');
    Fdotmean = abs(mean(tbl.Fdot(clusters(:,i))));
    thetafun = @(f) Bellfun(f,dF,Tmean,Fdotmean,theta0);
    % bellthR = thetafun(force)';
    % bellciR = bootci(nboot,thetafun,force);

    bellth(:,i) = fitfunction(pd_obs,edges,Tmean,Fdotmean,theta0);
    pdplot(:,i) = Bell_unfold_probability(bellth(:,i),Fplot,Tmean,Fdotmean);
    pdcalc(:,i) = Bell_unfold_probability(bellth(:,i),Ftot,Tmean,Fdotmean);
  end
  w = repmat(n/sum(n),ntot,1);
  residual = max(w.*pdcalc,[],2)-pdtot;
  rms = sqrt(residual'*residual/ntot);
  if plotting
    w = repmat(n/sum(n),plotpoints,1); 
    hold on;
    bar(Ftot,pdtot,dF)
    plot(Fplot,max(w.*pdplot,[],2),'r','LineWidth',1.5) 
    for i = 1:n_clusters
      plot(Fplot,pdplot(:,i).*w(:,i),'k');
    end
    box on
    xlabel('Rip force (pN)');
    ylabel('Probability density (pN^-^1)');
    % title(title2)
    % legend('Observed','Calculated')
    limy = ylim;
    text(40,limy(2)*0.7,sprintf('rms: %5.4f',rms));
    title('Bell model')
  end
end

function [th,resnorm] = Bellfun(fs,dF,Tmean,Fdot,theta0)
  [pd,edges] = probdens(fs,dF);
  [th,resnorm] = fit_Bell_unfold(pd,edges,Tmean,Fdot,theta0);
  th = th';
end