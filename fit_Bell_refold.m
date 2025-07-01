function [theta,resnorm] = fit_Bell_refold(pd_obs,edges,Tmean,Fdot,theta0)
% Fitting parameters for Bell refolding model
% Input:
%   pd_obs   column array of experiment probability densities
%   edges    bin edges for pd_obs.  pd_obs(i) is the mean probabiltydensity
%                  in the interval )bin) from edges(i) to edges(i+1)
%       pd_obs and edges, may be caclulated by probdens.m
%   Tmean    Temperature (°C) (mean over all unfolding events)
%   Fdot     df/dt before refolding (mean over all unfolding events)
%   theta0   InAitial guess for model parameters [dx;log10(k0)]
% F, pd and Fdotmean may be caclulated by probability_density.m
% Output:
%   theta    Fitted parameters
%   resnorm  norm of difference between input and model pd

% Version 1.0 2023-08-13
% Version 2.0 2025-06-25 Removed confidence interval by nlparci
%                        as this often gave incorrect results 

  % Optimization parameters:
  opt = optimoptions('lsqcurvefit');
  opt.MaxFunctionEvaluations = 2000;
  opt.Display = 'off';

  F  = (edges(1:end-1)+edges(2:end))'/2;  % Bin midpoints
  lb = [0;0];
  ub = [50;10];

  probfun = @(theta,F)Bell_refold_probability(theta,F,Tmean,Fdot);

  % Fit model parameters to data:
  [theta,resnorm,resid,exitflag,~,~,J] = ...
    lsqcurvefit(probfun,theta0,F,pd_obs,lb,ub,opt);
  if exitflag < 1
    error('lsqcurvefit problems. Exitflag: %d',exitflag)
  end  

end
