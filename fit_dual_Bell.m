function [bellth,bellstd,bellnorm,n,Fplot,pdbell] = fit_dual_Bell(tbl,runcase,Clusters,plotting)
% Bell unfoldingmodel parameters for unfolding or refolding
%   For unfolding: Cluster 1 for frce <= split. Cluster1 for force > split
%     Only one cluster for refolding
% Input:
%   tbl:  Matlab table Tun or Tre from analyse_many (or analys_table)
%   runcase: struct specifying the the case to study. Specified in
%     run_fit_dual.  runcase has the following fields: 
%        selected:  logical column array with as many rows as tbl
%                     true for selected rows
%        text: string describing the pulling speed and temperature
%   Clusters: two column logical column array
%
% Output:
%   bellth:  Fitted Bell parameters dx and log10k0
%   bellstd: Parameter standrd deviaton
%   bellnorm: norm of errors between observed and model probability
%   distributions

  if nargin < 3
    plotting = 0;
  end
  % Allocate variables
  unfold = tbl.Fdot(1) > 0;
  if unfold
    Fplot = linspace(5,55)';
    dF = 1;   % Force histogram spacing
    thetabell0 = [1;-2];
    tracetype = 'Unfolding';
  else
    Fplot = linspace(3,18)';
    dF = 0.5;   % Force histogram spacingpdbell    
    thetabell0 = [4;4];
    tracetype = 'Refolding';
  end

  selected = runcase.selected;
  Clusters = Clusters(selected,:);
  % cluster = false(sum(selected),2);
  % if numel(cldef) == 1  % split: force value separating clusters 1 and 2
  %   % Note that run_fit_dual has already removed outliers (sort of)
  %   force = tbl.Force(selected);
  %   cluster(:,2) = force<=cldef;
  %   cluster(:,1) = force>cldef;    
  % else % Labels from dbscan
  %   cluster(:,2) = cldef(selected) == 2;
  %   cluster(:,1) = cldef(selected) == 1;   
  % end

  Tmean = mean(tbl.Temperature(selected),'omitnan');
  Fdot = mean(tbl.Fdot(selected));

  force = tbl.Force(selected);
  both = any(Clusters,2);
  [pdtot,Ftot,n] = probdens(force(both),dF());
  if unfold
    n = sum(Clusters);
    Clusters = Clusters(:,n>8);  % skip very small clusters 
    ncl = size(Clusters,2);
    bellth = zeros(2,ncl);
    bellstd = zeros(2,ncl);
    bellnorm = zeros(1,ncl); 
    for cl = 1:ncl
      [pd,F] = probdens(force(Clusters(:,cl)),dF);
      if isnan(pd)
        continue
      end
      [bellth(:,cl),bellstd(:,cl),bellnorm(1,cl)] = fit_Bell_unfold(F,pd,Tmean,Fdot,thetabell0);
      pdbell(:,cl) = Bell_unfold_probability(bellth(:,cl),Fplot,Tmean,Fdot);  
    end
  else
      [bellth,bellstd,bellnorm] = fit_Bell_refold(Ftot,pdtot,Tmean,Fdot,thetabell0);
      pdbell = Bell_refold_probability(bellth,Fplot,Tmean,Fdot);    
  end
  w = n/sum(n);
  if plotting
    figure;bar(Ftot,pdtot,1);
    hold on;
    legtext = {'Experiment','Model'};
    if size(pdbell,2) == 1
      plot(Fplot,pdbell,'r','LineWidth',1.5)
    else
      plot(Fplot,pdbell*w','r','LineWidth',1.5) 
      if ncl > 1
        plot(Fplot,pdbell(:,1)*w(1),'k',Fplot,pdbell(:,2)*w(2),'k');
        legtext =[legtext,{'Clusters'}];
      end
    end
    % title(sprintf('Pulling speed : %s, Temperature: %s. %s',speedtext,temptext,tracetype))
    title(runcase.text)
    xlabel('Force (pN)');ylabel('Probability density (pN^-^1)')      
    set(gca,'xtick',5:5:55)
    % xlim([5,55]);
    legend(legtext)
  end
end

