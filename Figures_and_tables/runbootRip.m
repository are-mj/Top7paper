function [theta,ci,rms] = runbootRip(Tp,model,nboot)
% Running bootstrap calculation of 95% confidence intervals for all
% combinations of temperature and pulling speed, and for all clusters with
% more than 9 rips.
% Input:  Tp: Rip table from analyse_many
%         model:  "Bell" or "Dudko"
% Output ci: cols 1:2: ci for theta(1) etc.
% NOTE that I skip 20<T<= 30, cluster 2. This has only 9 rips and crashes 
%   fit_Bell_unfold most of the time.

  switch model
    case "Bell"
      ntheta = 2;
      theta0 = [1,-3];
    case "Dudko"
      ntheta = 3;
      theta0 = [40;1;-3];
  end
  theta = zeros(21,ntheta);
  ci = zeros(21,2*ntheta); 
  rms = zeros(21,1);
  ucases = cases(Tp);
  dF = 1;
  k = 1;
  for i = 1:length(ucases)
    Tmean = mean(Tp.Temperature(ucases(i).selected));
    Fdot = mean(Tp.Fdot(ucases(i).selected));
    okclusters = find(sum(ucases(i).clusters)>9);
    for j = okclusters
      selection = ucases(i).selected & ucases(i).clusters(:,j);
      fprintf('%25s,  %d\n',ucases(i).text,j);
      force = Tp.Force(selection);
      switch model
        case "Bell"
          thetafun = @(f) Bellfun(f,dF,Tmean,Fdot,theta0);
        case "Dudko"
          thetafun = @(f) Dudkofun(f,dF,Tmean,Fdot,theta0);
      end
      [th,rms(k)] = thetafun(force);
      theta(k,:) = th';
      ci0 = bootci(nboot,thetafun,force);
      ci(k,:) = ci0(:)';
      k = k+1;
    end
  end
end

function [th,rms] = Bellfun(fs,dF,Tmean,Fdot,theta0)
  [pd,edges] = probdens(fs,dF);
  [th,rms] = fit_Bell_unfold(pd,edges,Tmean,Fdot,theta0);
end

function [th,rms] = Dudkofun(fs,dF,Tmean,Fdot,theta0)
  par.nu = 1/2;
  par.model = 'DHS';
  [pd,edges] = probdens(fs,dF);
  [th,rms] = fit_Dudko_unfold(pd,edges,Tmean,Fdot,theta0,par);
end