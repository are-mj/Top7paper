function [dudkoth,dudkostd,dudkonorm] = fit_Dudko(Tun,runcase,Clusters,plotting)
% Fit Dudko model parameters for unfolding
% Input:
%   Tun:  Matlab table Tun from analyse_many 
%   runcase: struct specifying the the case to study. Specified in
%     run_fit_dual.  runcase has the following fields: 
%        selected:  logical column array with as many rows as Tun
%                     true for selected rows
%        text: string describing the pulling speed and temperature
%   Clusters: two column logical column array
%   
% Output:
%   dudkoth:  Fitted Dudko parameters DG, dx, and log10k0
%   dudkostd: Parameter standrd deviaton
%   dudkonorm: norm of errors between observed and model probability
%   distributions

  if nargin < 3
    plotting = 0;
  end
  par.nu = 0.5;
  par.model = 'DHS';
  % Allocate variables
  Fplot = linspace(5,55)';
  dF = 1;   % Force histogram spacing
  theta0 = [50;0.2;-2];

  selected = runcase.selected;
  Clusters = Clusters(selected,:);
  n = sum(Clusters);
  Tmean = mean(Tun.Temperature(selected),'omitnan');
  Fdot = mean(Tun.Fdot(selected));
  ncl = size(Clusters,2);
  force = Tun.Force(selected);
  dudkoth = zeros(3,ncl);
  dudkostd = zeros(3,ncl);
  dudkonorm = zeros(1,ncl); 
  for cl = 1:ncl
    [pd,F] = probdens(force(Clusters(:,cl)),dF);
    if isnan(pd)
      continue
    end
    [dudkoth(:,cl),dudkostd(:,cl),dudkonorm(1,cl)] = fit_Dudko_unfold(F,pd,Tmean,Fdot,theta0,par);
    pddudko(:,cl) = Dudko_unfold_probability(thetacalcfun(dudkoth(:,cl)),Fplot,Tmean,Fdot,par);  
  end

  w = n/sum(n);
  if plotting
    both = Clusters(:,2)|Clusters(:,1);
    [pdtot,Ftot] = probdens(force(both),dF());     
    figure;bar(Ftot,pdtot,1);
    hold on;
    legtext = {'Experiment','Model'};
    if size(pddudko,2) == 1
      plot(Fplot,pddudko,'r','LineWidth',1.5)
    else
      plot(Fplot,pddudko*w','r','LineWidth',1.5) 
      if ncl > 1
        plot(Fplot,pddudko(:,1)*w(1),'k',Fplot,pddudko(:,2)*w(2),'k');
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

function thetacalc = thetacalcfun(theta)
  DG = theta(1);
  dx = theta(2);
  k0 = theta(3); 
  a = dx/DG/2;
  thetacalc = [DG;a;k0];
end