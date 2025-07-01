function TableS3
  load Tables.mat TPTop7 TPTop7Top7 TPTop7BSA TPTop7FOXP1

  Ttext = ["3-7°C","7-14°C","14-20°C","20-30°C"];
  speedtext = ["<50nm/s","50-250nm/s",">250nm/s"];
  speedtext = ["<50","50-250",">250"];
  soltables = {TPTop7Top7,TPTop7BSA,TPTop7FOXP1};
  soltext = ["Top7/Top7","Top7/BSA","Top7/FOXP1"];

  % Top7 WLC parameters
  P = 0.65;
  L0 = 29.28;  

  tbl = strings(19,7);
  tbl(1,2) = "Solute";
  tbl(1,3) = "Pulling speednm/s";
  for col = 4:7
    tbl(1,col) = Ttext(col-3);
  end

  % TPTop7 results:
  force = TPTop7.Force;
  deltax = TPTop7.Deltax;
  T = TPTop7.Temperature;
  n = numel(force);
  L = zeros(n,1);
  for i = 1:n
    deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);
    L(i) = L0*deltax(i)/deltax0;
  end
  [cl1,cl2,cl3] = clusterdefinitions(TPTop7);
  Clusters = [cl1,cl2,cl3];
  
  Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=30];
  speed = TPTop7.Pullingspeed;
  speedclass = [speed<50,speed>50&speed<250,speed>250];    

  for clusterno = 1:3
    for speedno = 1:3
      startrow = 2 + (clusterno-1)*6;
      tbl(startrow,1) = strcat("Cluster",num2str(clusterno));      
      row = startrow-1+speedno;
      tbl(row,2) = "-";
      tbl(row,3) = speedtext(speedno);
      for temp = 1:4
        LL = L(Tclass(:,temp)&speedclass(:,speedno)&Clusters(:,clusterno));
        tbl(row,3+temp) = sprintf('%4.1f ± %3.1f',mean(LL),std(LL));
        if isnan(mean(LL))
          tbl(row,3+temp) = "-";
        end        
      end
    end
  end

  % Solution results:
  for solno = 1:3
    T = soltables{solno}.Temperature;
    Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=30];
    speed = soltables{solno}.Pullingspeed;
    speedclass = [speed<50,speed>50&speed<250,speed>250];
    [cl1,cl2,cl3] = clusterdefinitions(soltables{solno});
    Clusters = [cl1,cl2,cl3]; 
    force = soltables{solno}.Force;
    deltax = soltables{solno}.Deltax;
    n = numel(force);
    L = zeros(n,1);
    for i = 1:n
      deltax0 = wlc_inverse(force(i),P,T(i)+273.15,L0);
      L(i) = L0*deltax(i)/deltax0;
    end
    for clusterno = 1:3
      row = 4 + (clusterno-1)*6 + solno;     
      tbl(row,2) = soltext(solno);
      tbl(row,3) = speedtext(2);
      for temp = 1:4
        LL = L(Tclass(:,temp)&speedclass(:,2)&Clusters(:,clusterno));
        tbl(row,3+temp) = sprintf('%4.1f ± %3.1f',mean(LL),std(LL));
        if isnan(mean(LL))
          tbl(row,3+temp) = "-";
        end
      end
    end
  end
  
  for row = 1:19
    for col = 1:7
      fprintf('%s\t',tbl(row,col));
    end
    fprintf('\n');
  end
end