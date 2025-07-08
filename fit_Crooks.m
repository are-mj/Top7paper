function [DG,DGci] = fit_Crooks(Tun,Tre,selP,selR,Clusters,texts,plotting)
% Calculate DG from unfolding and refolding parameters dx and log10k0 
% Unfolding for all force clusters, Refolding for all data.
% DG equals the work at the point where unfolding and refolding work are
% equal, according to the Crooks fluctuation theorem
% Output:
%   DG:    Crooks DeltaG
%   DGci:  Confidence interval calculated by bootstrapping

% 20240209: Specified analytical search range in match.
% 20250529: Changed from standard deviation to 95% confidence interval

% Do calculations and plotting in kcal/kmol
conversion = 0.1439326;  % Energy units kcal/kmol 
% Convert outputs DG and DGci back to pN⋅nm for consistency
% This somwhat awkward procedure has historical reasons. 

  if nargin < 5
    plotting = 0;
  end
  P = 0.65;L0 = 29.28;  % WLC parameters

  Tmean = mean(Tun.Temperature(selP));
  T = Tmean + 273.15;

  % Refold:
  f_refold = Tre.Force(selR);
  bad = f_refold < 2;
  f_refold(bad) = [];  % Skip unrealistic values
  deltax_refold = -Tre.Deltax(selR);
  deltax_refold(bad) = []; 
  Ws = stretchwork(f_refold,deltax_refold,P,T,L0); % Should we subtract Ws here?
  Wr = f_refold.*deltax_refold - Ws;
  Wr_kcal = Wr*conversion;  % Convert energy units
  pdr = fitdist(Wr_kcal,'normal');   % Normal distribution

  % Unfold:
  f_unfold = Tun.Force(selP);
  deltax_unfold = Tun.Deltax(selP);

  n = sum(Clusters(selP,:));
  nclusters = find(n>9);    % Clusters with more that 8 rips  

  ncl = numel(nclusters);   % Number of clusters
  fu = cell(ncl,1);
  dxu = cell(ncl,1);
  Wu = cell(ncl,1);
  pdu = cell(ncl,1);
  DG = zeros(3,1);
  DGci = zeros(3,2);
  if plotting
    hh = [];
    nexttile;
    h = plot(pdr);hold on
    hh = [hh,h];
    colors = [0 0 1;0.5 0.2 0.5;0.3 0.6 0.6;.5*[1 1 1]];
    h(1).Color = colors(1,:);
    legtext = "Refolding";
  end
  for cl = find(n>9)  % Nonzero parameter columns
    fu{cl} = f_unfold(Clusters(selP,cl));
    dxu{cl} = deltax_unfold(Clusters(selP,cl));
    Ws = stretchwork(fu{cl},dxu{cl},P,T,L0);
    Wu{cl} = (fu{cl}.*dxu{cl}-Ws);        % Net work
    Wu{cl} = Wu{cl}*conversion;  % Convert energy units
    pdu{cl} = fitdist(Wu{cl},'normal');
    DG(cl) = match(pdr,pdu{cl})/conversion;
    if nargout > 1
      % Perform this time-consuming calculation only if needed:
      DGci(cl,:) = Crooks_ci(pdu{cl},pdr)/conversion;
    end
    if plotting
      h = plot(pdu{cl});
      hh = [hh,h];
      h(1).Color = colors(cl+1,:);
      s = sprintf('Cluster %d',cl);
      legtext = [legtext;s];
      title(texts)
      xlabel('');ylabel(''); % remove fitdist's standard labels
    end
  end
  if plotting
    set(gca,'XScale','log')
    xlim([2,200]);
    if conversion < 1
      ylim([0,0.3]);
    end
    set(gca,'xtick',[3,10,30,100])
    legend(hh(2:2:8),legtext);
  end
end

function pd = pdfun(pdobj,x)
  mu = pdobj.mu;
  sigma = pdobj.sigma;
  pd = exp(-0.5*((x-mu)/sigma).^2)/sigma/sqrt(2*pi);
end

function DG = match(pd1,pd2)
% Find the point where two normal distributions are equal
  fun = @(x) pdfun(pd1,x)-pdfun(pd2,x);
  try
    [DG,~,exitflag] = fzero(fun,[pd1.mu,pd2.mu]);
  catch  % No crossong point between distribution tops
    [DG,~,exitflag] = fzero(fun,[pd1.mu-pd1.sigma,pd2.mu]);
  %   warning('Matching distributions may not be correct')
  %   xpts = [pd1.mu-2*pd1.sigma,pd1.mu+2*pd1.sigma,pd2.mu-2*pd1.sigma, ...
  %     pd2.mu+2*pd1.sigma];
  %   x = linspace(min(xpts),max(xpts));
  %   figure;plot(x,pdfun(pd1,x),x,pdfun(pd2,x)); xline([pd1.mu,pd2.mu])
  end
  if exitflag < 0
    warning('fzero problem')
  end
end

function ci = Crooks_ci(pdu,pdr)
% Monte Carlo calculation of the confidence interval of the intersection of pdr and pdu
  
  pdu_ci = pdu.paramci;
  pdu_mu_std = pdu.mu - pdu_ci(1,1);
  pdu_sigma_std = pdu.sigma - pdu_ci(1,2);

  pdr_ci = pdr.paramci;
  pdr_mu_std = pdr.mu - pdr_ci(1,1);
  pdr_sigma_std = pdr.sigma - pdr_ci(1,2);

  nsamples = 1000; 

  DG = zeros(nsamples,1);
  for i = 1:nsamples
    try  % normrnd may occasionally return negative values
         % This will crash makedist
      umu = normrnd(pdu.mu,pdu_mu_std);
      usigma = normrnd(pdu.sigma,pdu_sigma_std);
      rand_pdu = makedist('normal','mu',umu,'sigma',usigma);
      % plot(rand_pdu);
  
      rmu = normrnd(pdr.mu,pdr_mu_std);
      rsigma = normrnd(pdr.sigma,pdr_sigma_std);
      rand_pdr = makedist('normal','mu',rmu,'sigma',rsigma); 
      % plot(rand_pdr);
      DG(i) = match(rand_pdr,rand_pdu);
    catch
      DG(i) = NaN;
    end
  end
  DG(isnan(DG)) = [];
  pd = fitdist(DG,'normal');
  ci = norminv([0.025 0.975],pd.mu,pd.sigma);
end

function W = stretchwork(force,deltax,P,T,L0)
% Calcuate the work done stretching to the unfolding force
%
% Input:
%  force: Unfolding force (nm)
%  P: Persistence length (nm)
%  T: Temperature (K)
%  L0: Contour length (Molecule length at maximun extension) (nm)
% simple: Do not use the improved fit to WLC

  if nargin < 6
    simple = 1;
  end
  x0 = 0;
  W = zeros(size(force));
  for i = 1:numel(force)
    x1 = wlc_inverse(force(i),P,T,L0,simple);
    scale = deltax(i)/x1;
    fun = @(x) wlc(x,P,T,L0,simple);
    W(i) = integral(fun,x0,x1)*scale;
  end
end