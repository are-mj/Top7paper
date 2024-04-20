function [DG,DGstd] = kinetic_DG(thetau,thetaustd,thetar,thetarstd,T)
% Value and STD of DG_kin from unfolding and refolding parameters
% Input:
%   thetau: 2 by n array of dx and log10k0. n = 2 for dual model
%   thetaustd: 2 by n array of standard deviations for dx and log10k0
%   theta1r: 2 by 1 array of dx and log10k0.
%   thetarstd: 2 by 1 array of standard deviations for dx and log10k0
%   T : temperature (K) 
%   Parameter inputs from fit_dual_Bell.m
% Outputs:
%   DG: Kinetic DG value
%   DGstd:  Standard deviation of DG

% Using the simplified expression for propagation of standard deviation:
% stdf = sqrt((df/dx)^2*stdx + (df/dxy^2*stdy)
% https://en.wikipedia.org/wiki/Propagation_of_uncertainty#Simplification

  n = size(thetau,2);

  k0u = 10.^thetau(2,:);
  k0ustd = k0u.*log(10).*thetaustd(2,:);
  k0r = 10.^thetar(2);
  k0rstd = k0r.*log(10).*thetarstd(2);

  kB = 0.01380649; % Boltzmann's constant (zJ/K/molecule)
  DG = -kB*T*log(k0u/k0r); % = kB*T*(log(k0R)-log(k0U))
  dDG_dk0u = -kB*T./k0u;
  dDG_dk0r = kB*T/k0r;

  DGstd = sqrt((dDG_dk0u).^2.*k0ustd.^2 + dDG_dk0r^2*k0rstd^2*ones(1,n));
end
