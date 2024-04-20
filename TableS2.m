function tbl = TableS2
  load Top7tables Tun TunTop7Top7 TunTop7BSA
  [ok,Cluster1,Cluster2] = no_outliers(Tun);
  force = Tun.Force;
  T = Tun.Temperature;
  speed = Tun.Pullingspeed;
  fast = speed>500;
  normal = speed<500 & speed>50;
  slow = speed<14;
  speedclass = [slow,normal,fast];
  speedtext = ["10 nm/s","100 nm/s","1000 nm/s"];
  Tclass = [4<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=27];
  Ttext = ["4°C<T<=7°C","7°C<T<=14°C","14°C<T<=20°C","20°C<T<=27°C"];  

  tbl = strings(11,5);
  Cluster = Cluster1;
  tbl(1,1) = "Temperature (°C)";
  for col = 2:5
    tbl(1,col) = Ttext(col-1);
  end
  for row = 2:4
    tbl(row,1) = speedtext(row-1);
    for col = 2:5
      sel = force(speedclass(:,row-1)&Tclass(:,col-1)&ok&Cluster);
      tbl(row,col) = string(sprintf('%5.2f ± %4.2f',mean(sel),std(sel)));
    end
  end
  Cluster = Cluster2;
  for row = 7:9
    tbl(row,1) = speedtext(row-6);
    for col = 2:5
      sel = force(speedclass(:,row-6)&Tclass(:,col-1)&ok&Cluster);
      tbl(row,col) = string(sprintf('%5.2f ± %4.2f',mean(sel),std(sel)));
    end
  end  
  
  Tun = [TunTop7BSA;TunTop7Top7];
  [ok,Cluster1,Cluster2] = no_outliers(Tun);
  Top7rows = [false(height(TunTop7BSA),1);true(height(TunTop7Top7),1)];
  BSArows = [true(height(TunTop7BSA),1);false(height(TunTop7Top7),1)];

  force = Tun.Force;
  T = Tun.Temperature;
  Tclass = [4<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=27];

  row = 5;
  tbl(row,1) = "Top7/Top7";
  for col = 2:5
    sel = force(Tclass(:,col-1)&ok&Cluster1&Top7rows);
    tbl(row,col) = string(sprintf('%5.2f ± %4.2f',mean(sel),std(sel)));
  end  
  row = 10;
  tbl(row,1) = "Top7/Top7";
  for col = 2:5
    sel = force(Tclass(:,col-1)&ok&Cluster2&Top7rows);
    tbl(row,col) = string(sprintf('%5.2f ± %4.2f',mean(sel),std(sel)));
  end 

  row = 6;
  tbl(row,1) = "Top7/BSA";
  for col = 2:5
    sel = force(Tclass(:,col-1)&ok&Cluster1&BSArows);
    tbl(row,col) = string(sprintf('%5.2f ± %4.2f',mean(sel),std(sel)));
  end  
  row = 11;
  tbl(row,1) = "Top7/BSA";
  for col = 2:5
    sel = force(Tclass(:,col-1)&ok&Cluster2&BSArows);
    tbl(row,col) = string(sprintf('%5.2f ± %4.2f',mean(sel),std(sel)));
  end 
  
  for i = 1:11
    for j = 1:5
      fprintf('%s\t',tbl(i,j));
    end
    fprintf('\n');
  end

  