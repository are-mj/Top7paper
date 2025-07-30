function Tout = run_fit(TRIP,TZIP)
% Fits parameters for  Bell_unfold, Bell_refold, Dudko, DGkin and DGCrooks
% and calcuates parameter 95% conficence interval using bootstrapping
% function bootci
% Output: Table of fitted parameters for all sets of themperature, pulling
% speed and clusters
%
% Supersedes earlier versions that used anaytical confidence intervals  
% from function nlparci. This often gives incorrect results in combiantion
% with bounded parameters search.
%
% NOTE: Energy values are in kcal/mol!

% Version 2.0 2025-06-25 Calculate confidence intervals by bootci

  conversion = 0.1439326;  % Energy units kcal/kmol
  theta0BellP = [1;-3];
  theta0BellR = [4;4];
  theta0Dudko = [100;2;-3];
  nboot = 500;   % Bootstrap samples for calculating confdence intervals
  kB = 0.01380649; % Boltzmann's constant (zJ/K/molecule)

  Tout = cell2table(cell(0,17),'VariableNames',{'Text','Clusterno',...
    'events','dx','cidx','log10k0','cilog10k0'...
    'DGDudko','ciDGDudko','dxDudko','cidxDudko','log10k0Dudko',...
    'cilog10k0Dudko','DGkin','ciDGkin','DGCrooks','ciDGCrooks'});
  [ucases,rcases] = cases(TRIP,TZIP);
  dF = 1;
  k = 1;  % Rowno in Tout
  for i = 1:numel(ucases)  
    Tmean = mean(TRIP.Temperature(ucases(i).selected));
    Fdot = mean(TRIP.Fdot(ucases(i).selected));
    Text = rcases(i).text;
  
    % Refold
    Clusterno = 0;
    DGDudko = 0;
    ciDGDudko = [0,0];
    dxDudko = 0;
    cidxDudko = [0,0];
    log10k0Dudko = 0;
    cilog10k0Dudko = [0,0];
    DGkin = 0;
    ciDGkin = [0,0];
    DGCrooks = 0;
    ciDGCrooks = [0,0];

    usel = ucases(i).selected;
    rsel = rcases(i).selected;
    cls = ucases(i).clusters;
    events = sum(rsel);
    if events > 10
      texts = strcat(ucases(i).text,rcases(i).text);
      forceR = TZIP.Force(rsel);
      thfun = @(f) BellfunR(f,dF,Tmean,Fdot,theta0BellR);
      thR = thfun(forceR);
      dx = thR(1);
      log10k0 = thR(2);
      log10k0R = log10k0;  % For use in DGkin
      if length(forceR) > 10
        cithR = bootci(nboot,thfun,forceR)';
      else
        cithR = NaN*ones(2);
      end
      cidx = cithR(1,:);
      cilog10k0 = cithR(2,:);
      cilogk0widthZip = kB*(Tmean+273.15)*diff(cilog10k0); % For use in DGkin
      Tout = [Tout;table(Text,Clusterno,events,dx,cidx,log10k0,cilog10k0,DGDudko,...
        ciDGDudko,dxDudko,cidxDudko,log10k0Dudko,cilog10k0Dudko,DGkin,...
        ciDGkin,DGCrooks,ciDGCrooks)];
      k = k+1;
    end
    % Unfold
    Text = ucases(i).text;
    usel = ucases(i).selected;  
    DG = zeros(3,1);
    DGci = zeros(3,2);

    if sum(rsel) > 10
      [G(:,i),Gciu(:,2*i+[1,2])] = fit_Crooks(TRIP,TZIP,usel,rsel,cls,texts,0);
    end

    okclusters = find(sum(ucases(i).clusters)>9);
    for j = okclusters
      Clusterno = j;
      selection = ucases(i).selected & ucases(i).clusters(:,j);
      events = sum(selection);
      if sum(selection) < 10
        continue
      end
      % fprintf('%25s,  %d\n',ucases(i).text,j);
      force = TRIP.Force(selection);

      % Bell_unfold
      thfun = @(f) BellfunP(f,dF,Tmean,Fdot,theta0BellP);
      theta = thfun(force);
      dx = theta(1);
      log10k0 = theta(2);
      cith = bootci(nboot,thfun,force)';
      cidx = cith(1,:);
      cilog10k0 = cith(2,:);

      % Dudko
      thfun = @(f) Dudkofun(f,dF,Tmean,Fdot,theta0Dudko);
      theta = thfun(force);
      DGDudko = theta(1)*conversion;
      dxDudko = theta(2);
      log10k0Dudko = theta(3);
      try
        cith = bootci(nboot,thfun,force)';
      catch
        cith = bootci(nboot,thfun,force)';
      end
      ciDGDudko = cith(1,:)*conversion;
      cidxDudko = cith(2,:);
      cilog10k0Dudko = cith(3,:);

      DGkin = -kB*(Tmean+273.15)*(log10k0-log10k0R)*log(10)*conversion;
      cilogk0widthRip = kB*(Tmean+273.15)*diff(cilog10k0);
      ciDGkin = DGkin + sqrt(cilogk0widthRip.^2 + cilogk0widthZip.^2)/2*...
        [-1,1]*log(10)*conversion;

      DGCrooks = G(j,i)*conversion;
      ciDGCrooks = Gciu(j,2*i+[1,2])*conversion;
      fprintf('%30s %4d %4d\n',Text,Clusterno,sum(selection));

      Tout = [Tout;table(Text,Clusterno,events,dx,cidx,log10k0,cilog10k0,DGDudko,...
        ciDGDudko,dxDudko,cidxDudko,log10k0Dudko,cilog10k0Dudko,DGkin,...
        ciDGkin,DGCrooks,ciDGCrooks)];
      k = k+1;
    end
  end
  % Move the refolding lines to the end
  cluster0rows = find(Tout.Clusterno == 0); 
  normalrows = find(Tout.Clusterno > 0);
  Tout = Tout([normalrows;cluster0rows],:);
end

function [th,rms] = BellfunP(fs,dF,Tmean,Fdot,theta0)
% Bell function for pulling trace
  [pd,edges] = probdens(fs,dF);
  [th,rms] = fit_Bell_unfold(pd,edges,Tmean,Fdot,theta0);
end

function [th,rms] = BellfunR(fs,dF,Tmean,Fdot,theta0)
% Bell function for relaxing trace
  [pd,edges] = probdens(fs,dF);
  [th,rms] = fit_Bell_refold(pd,edges,Tmean,Fdot,theta0);
  if rms > 0.05
    % If the fit is bad, try with another theta0
    theta0 = [9;4];
    [th,rms] = fit_Bell_refold(pd,edges,Tmean,Fdot,theta0);
    if rms > 0.05
      warning('No convergence');
    end
  end
end

function [th,rms] = Dudkofun(fs,dF,Tmean,Fdot,theta0)
% Dudko function for puling trace
  par.nu = 1/2;
  par.model = 'DHS';
  [pd,edges] = probdens(fs,dF);
  [th,rms] = fit_Dudko_unfold(pd,edges,Tmean,Fdot,theta0,par);
end

