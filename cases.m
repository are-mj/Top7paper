function [ucases,rcases] = cases(TP,TR)
% Create logical arrays for combinations of 
%   Temperature
%   Pulling speed
%   Cluster
% Output:
%   ucases : Unfoldig cases
%     ucases(m).selected is a logical column vector
%       True if TP.Temperature is in ucases(m).Tclass
%       and TP.Pullingspeed is in ucases(m).speedclass
%     ucases(m).clusters is a n by 3 (or 2) logical array
%     ucases(m).text describes tha case
%   rcases : Refolding cases
%     Similar to ucases but lacking clusters

  if nargin < 1
    load tables TP TR
  end
  
  % Unfold cases:
  T = TP.Temperature;
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=30];
  Ttext = ["3-7","7-14","14-20","20-30"];
  
  speed = TP.Pullingspeed;
  fast = speed>250;
  normal = speed<250 & speed>50;
  slow = speed<50;
  speedclass = [slow,normal,fast];
  speedtext = ["<50","50-250",">250"];
  
  [cl1,cl2,cl3] = clusterdefinitions(TP);
  Clusters = [cl1,cl2,cl3]; 
  
  m = 0;
  for i = 1:4  % Temp
    if i == 2 ||  i == 3
      speeds = 2;
    else 
      speeds = 1:3;
    end  
    for j = speeds % Speed
      m = m+1;
      ucases(m).selected = Tclass(:,i) & speedclass(:,j);
      ucases(m).text = strcat("Unfolding, ",Ttext(i),", ",speedtext(j));
      ucases(m).clusters = Clusters & ucases(m).selected;
      if i==4 && j == 3
        ucases(m).clusters = [cl1,cl2|cl3] & ucases(m).selected;
      end
      ucases(m).nrips = sum(ucases(m).clusters);
    end
  end

  if nargin > 1
    % refold cases:
    T = TR.Temperature;
    Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=30];
    Ttext = ["3-7","7-14","14-20","20-30"];
    
    speed = TR.Pullingspeed;
    fast = speed>250;
    normal = speed<250 & speed>50;
    slow = speed<50;
    speedclass = [slow,normal,fast];
    speedtext = ["<50","50-250",">250"];
    
    m = 0;
    for i = 1:4  % Temp
      if i == 2 ||  i == 3
        speeds = 2;
      else 
        speeds = 1:3;
      end
      for j = speeds % Speed
          m = m+1;
          rcases(m).selected = Tclass(:,i) & speedclass(:,j);
          rcases(m).text = strcat("Refolding, ",Ttext(i),", ",speedtext(j));
          rcases(m).nrips = sum(ucases(m).selected);
      end
    end
  else
    rcases = NaN;
  end
end