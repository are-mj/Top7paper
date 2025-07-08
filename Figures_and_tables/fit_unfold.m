function Tout = fit_unfold(Tp,Tr)
% Fit Bell model for pulling results table Tp
% Create averaged properties for all combinations of 
%   Temperature
%   Pulling speed
%   Cluster
% Output: Tout (Table of fitted parameters for all combinations and models
% Used by: TableS6.m

% See also: run_fit

conversion = 0.1439326;  % Energy units kcal/kmol 
nboot = 100;
[ucases,rcases] = cases(Tp,Tr);
[thetau,ciu,rmsu] = runbootRip(Tp,"Bell",nboot);

nrips = zeros(8,3);
G = zeros(3,8);
Gciu = zeros(3,16);
% Create output table columns
Tout = cell2table(cell(0,10),'VariableNames',{'Text','Cluster', ...
  'dx','ciudx','log10k0','ciuk0','DGCrooks','ciCrooks','Events','RMS'});

k = 1;
for i = 1:numel(ucases)
  nr = ucases(i).nrips;
  if sum(nr) >9
    nrips(i,1:length(nr)) = nr;
    usel = ucases(i).selected;
    rsel = rcases(i).selected;
    cls = ucases(i).clusters;
    texts = strcat(ucases(i).text,rcases(i).text);
    [G(:,i),Gciu(:,2*i+[1,2])] = fit_Crooks(Tp,Tr,usel,rsel,cls,texts,0);
      
    for cl = find(nr>9)  % Nonzero parameter columns
      Cluster = cl;
      dx = thetau(k,1);
      ciudx = ciu(k,1:2);
      log10k0 = thetau(k,2);
      ciuk0 = ciu(k,3:4);
      Text = ucases(i).text;
      DGCrooks = G(cl,i)*conversion;
      ciCrooks = Gciu(cl,2*i+[1,2])*conversion;
      Events = nr(cl);
      RMS = rmsu(k); % Root of the means square difference between model and observabtions
      Tout = [Tout;table(Text,Cluster,dx,ciudx,log10k0,ciuk0,DGCrooks,ciCrooks,Events,RMS)];
      k = k+1;
    end
  end
end


