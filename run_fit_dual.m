function Tout = run_fit_dual
% Create averaged properties for all combinations of 
%   Temperature
%   Pulling speed
%   Cluster
% Output: Tout (Table of fitted parameters for all combinations and models)

% NOTE: Comment out line 126 (n = 100;) in fit_Crooks.m for more accurate 
%       (but slower) calculation of standard deviations for DGCrooks

load Top7Tables.mat Tun Tre


[ok,Cluster1,Cluster2,par] = no_outliers(Tun);
Clusters = [Cluster1,Cluster2];
Tre_ok = true(size(Tre.Force)); % Use all refolding events


% Unfold cases:
speed = Tun.Pullingspeed;
fast = speed>500;
normal = speed<500 & speed>50;
slow = speed<14;
speedtext = ["fast","normal","slow"];

T = Tun.Temperature;
Tclass = [4<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=27];
% Ttext = ["4°C<T<=7°C","7°C<T<=14°C","14°C<T<=19°C","19°C<T<=24°C"];
Ttext = ["4-7","7-14","14-20","20-27"];

ucase(1).selected = Tclass(:,1)&fast;
ucase(2).selected = Tclass(:,4)&fast;
ucase(3).selected = Tclass(:,1)&normal;
ucase(4).selected = Tclass(:,2)&normal;
ucase(5).selected = Tclass(:,3)&normal;
ucase(6).selected = Tclass(:,4)&normal;
ucase(7).selected = Tclass(:,1)&slow;
ucase(8).selected = Tclass(:,4)&slow;

ucase(1).text = strcat("Unfolding, ",speedtext(1),", ",Ttext(1));
ucase(2).text = strcat("Unfolding, ",speedtext(1),", ",Ttext(4));
ucase(3).text = strcat("Unfolding, ",speedtext(2),", ",Ttext(1));
ucase(4).text = strcat("Unfolding, ",speedtext(2),", ",Ttext(2));
ucase(5).text = strcat("Unfolding, ",speedtext(2),", ",Ttext(3));
ucase(6).text = strcat("Unfolding, ",speedtext(2),", ",Ttext(4));
ucase(7).text = strcat("Unfolding, ",speedtext(3),", ",Ttext(1));
ucase(8).text = strcat("Unfolding, ",speedtext(3),", ",Ttext(4));

% refold cases:
speed = Tre.Pullingspeed;
T = Tre.Temperature;
fast = speed>500;
normal = speed<500 & speed>50;
slow = speed<14;
Tclass = [4<T&T<=7 , 7<T&T<=14 , 14<T&T<=19,19<T&T<=24];

rcase(1).selected = Tclass(:,1)&fast;
rcase(2).selected = Tclass(:,4)&fast;
rcase(3).selected = Tclass(:,1)&normal;
rcase(4).selected = Tclass(:,2)&normal;
rcase(5).selected = Tclass(:,3)&normal;
rcase(6).selected = Tclass(:,4)&normal;
rcase(7).selected = Tclass(:,1)&slow;
rcase(8).selected = Tclass(:,4)&slow;  

rcase(1).text = strcat("Refolding, ",speedtext(1),", ",Ttext(1));
rcase(2).text = strcat("Refolding, ",speedtext(1),", ",Ttext(4));
rcase(3).text = strcat("Refolding, ",speedtext(2),", ",Ttext(1));
rcase(4).text = strcat("Refolding, ",speedtext(2),", ",Ttext(2));
rcase(5).text = strcat("Refolding, ",speedtext(2),", ",Ttext(3));
rcase(6).text = strcat("Refolding, ",speedtext(2),", ",Ttext(4));
rcase(7).text = strcat("Refolding, ",speedtext(3),", ",Ttext(1));
rcase(8).text = strcat("Refolding, ",speedtext(3),", ",Ttext(4));



% fprintf('Speed    Temp. Cluster Direction     ΔG‡        x‡      log10(k0)    n    Residual norm\n');
% fprintf('%9s %6s %6s %7s %7s  %7s    %9s  %2s   %5s\n', ...
%   'Direction','Speed','Temp.','Cluster','ΔG ','Δx','log10(k0)','n', ...
%   'Resid')
thetau = cell(7,1);
thetar = cell(7,1);
thetad = cell(7,1);
thetaustd = cell(7,1);
thetarstd = cell(5,1);
thetadstd = cell(7,1);
unorm = zeros(7,2);
rnorm = zeros(7,1);
dnorm = zeros(7,2);

G = zeros(2,7);
Gstd = zeros(2,7);
n = zeros(7,2);
% Create output table columns
Tout = cell2table(cell(0,18),'VariableNames',{'Text','Cluster', ...
  'DG_Crooks','stdCrooks','DG_kin','stdkin','GDudko','stdGDudko',...
  'DeltaxDudko','stddxDudko','log10k0Dudko','stdk0Dudko', ...
  'Deltax','stddx','log10k0','stdk0','Events','Residual_norm'});

for i = 1:numel(ucase)
% for i =1:2 % Case 8: slow unfolding at high T has too few data points
  if sum(ucase(i).selected) <10
    continue
  end
  [thetau{i},thetaustd{i},unorm(i,:),n(i,:)] = fit_dual_Bell(Tun,ucase(i),Clusters,0);
  [thetar{i},thetarstd{i},rnorm(i),nre] = fit_dual_Bell(Tre,rcase(i),Tre_ok,0);  
  [thetad{i},thetadstd{i},dnorm(i,:)] = fit_Dudko(Tun,ucase(i),Clusters,0);
  [G(:,i),Gstd(:,i)] = fit_Crooks(Tun,Tre,ucase(i),rcase(i),Clusters,0);
  Tmean = mean(Tun.Temperature(ucase(1).selected))+273.15;
  [Gkin,Gkinstd] = kinetic_DG(thetau{i},thetaustd{i},thetar{i},thetarstd{i},Tmean);
  Text = ucase(i).text;
  for cl = find(thetau{i}(1,:)>0)  % Nonzero parameter columns
    Cluster = cl;
    DG_Crooks = G(cl,i);
    stdCrooks = Gstd(cl,i);
    DG_kin = Gkin(cl);
    stdkin = Gkinstd(cl);
    GDudko = thetad{i}(1,cl);
    stdGDudko = thetadstd{i}(1,cl);
    DeltaxDudko = thetad{i}(2,cl);
    stddxDudko = thetadstd{i}(2,cl);
    log10k0Dudko = thetad{i}(3,cl);
    stdk0Dudko = thetadstd{i}(3,cl);
    Deltax = thetau{i}(1,cl);
    stddx = thetaustd{i}(1,cl);
    log10k0 = thetau{i}(2,cl);
    stdk0 = thetaustd{i}(2,cl);
    Events = n(i,cl);
    Residual_norm = unorm(i,cl);
    Tout = [Tout;table(Text,Cluster, ...
      DG_Crooks,stdCrooks,DG_kin,stdkin,GDudko,stdGDudko,...
      DeltaxDudko,stddxDudko,log10k0Dudko,stdk0Dudko, ...
      Deltax,stddx,log10k0,stdk0,Events,Residual_norm)];
  end
  Cluster = 0;
  DG_Crooks = 0;
  stdCrooks = 0;
  DG_kin = 0;
  stdkin = 0;
  GDudko = 0;
  stdGDudko = 0;
  DeltaxDudko = 0;
  stddxDudko = 0;
  log10k0Dudko = 0;
  stdk0Dudko = 0;  
  Deltax = thetar{i}(1);
  stddx = thetarstd{i}(1);
  log10k0 = thetar{i}(2);
  stdk0 = thetarstd{i}(2);
  Events = nre;
  Residual_norm = rnorm(i,1);
  Text = rcase(i).text;
  Tout = [Tout;table(Text,Cluster, ...
    DG_Crooks,stdCrooks,DG_kin,stdkin,GDudko,stdGDudko,...
    DeltaxDudko,stddxDudko,log10k0Dudko,stdk0Dudko, ...
    Deltax,stddx,log10k0,stdk0,Events,Residual_norm)]; 
  % Sort in logical order:
end
index = [19,21,7,10,13,16,1,4,8,11,14,17,2,5,20,22,9,12,15,18,3,6]; 
Tout = Tout(index,:);
