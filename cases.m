function [ripcases,zipcases] = cases(TRIP,TZIP)
% Create logical arrays for combinations of 
%   Temperature
%   Pulling speed
%   Cluster
% Output:
%   ripcases : Unfoldig cases
%     ripcases(m).selected is a logical column vector
%       True if TRIP.Temperature is in ripcases(m).Tclass
%       and TRIP.Pullingspeed is in ripcases(m).speedclass
%     ripcases(m).clusters is a n by 3 (or 2) logical array
%     ripcases(m).text describes tha case
%   zipcases : Refolding cases
%     Similar to ripcases but lacking clusters

  if nargin < 1
    load Tables TRIP TZIP
  end
  
  % Unfold cases:
  T = TRIP.Temperature;
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=30];
  Ttext = ["3-7","7-14","14-20","20-30"];
  
  speed = TRIP.Pullingspeed;
  fast = speed>250;
  normal = speed<250 & speed>50;
  slow = speed<50;
  speedclass = [slow,normal,fast];
  speedtext = ["<50","50-250",">250"];
  
  [cl1,cl2,cl3] = clusterdefinitions(TRIP);
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
      ripcases(m).selected = Tclass(:,i) & speedclass(:,j);
      ripcases(m).text = strcat("Unfolding, ",Ttext(i),", ",speedtext(j));
      ripcases(m).clusters = Clusters & ripcases(m).selected;
      if i==4 && j == 3
        ripcases(m).clusters = [cl1,cl2|cl3] & ripcases(m).selected;
      end
      ripcases(m).nrips = sum(ripcases(m).clusters);
    end
  end

  if nargin > 1
    % refold cases:
    T = TZIP.Temperature;
    Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=30];
    Ttext = ["3-7","7-14","14-20","20-30"];
    
    speed = TZIP.Pullingspeed;
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
          zipcases(m).selected = Tclass(:,i) & speedclass(:,j);
          zipcases(m).text = strcat("Refolding, ",Ttext(i),", ",speedtext(j));
          zipcases(m).nrips = sum(ripcases(m).selected);
      end
    end
  else
    zipcases = NaN;
  end
end