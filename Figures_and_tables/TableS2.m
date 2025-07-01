function TableS2
  load Tables.mat TPTop7 TPTop7Top7 TPTop7BSA TPTop7FOXP1

  Ttext = ["3-7°C","7-14°C","14-20°C","20-30°C"];
  speedtext = ["<50nm/s","50-250nm/s",">250nm/s"];
  soltables = {TPTop7Top7,TPTop7BSA,TPTop7FOXP1};
  % soltext = ["Top7/Top7","Top7/BSA","Top7/FOXP1"];
  soltext = ["Top7","BSA","FOXP1"];
 
  tbl = strings(19,7);
  tbl(1,2) = "Solute";
  tbl(1,3) = "Pulling speed";
  for col = 4:7
    tbl(1,col) = Ttext(col-3);
  end
  for clusterno = 1:3
    T = TPTop7.Temperature;
    Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=30];
    speed = TPTop7.Pullingspeed;
    speedclass = [speed<50,speed>50&speed<250,speed>250];    
    startrow = 2 + (clusterno-1)*6;
    tbl(startrow,1) = strcat("Cluster",num2str(clusterno));
    [cl1,cl2,cl3] = clusterdefinitions(TPTop7);
    Clusters = [cl1,cl2,cl3];     
    for speedno = 1:3
      row = startrow-1+speedno;
      tbl(row,2) = "-";
      tbl(row,3) = speedtext(speedno);
      for temp = 1:4
        f = TPTop7.Force(Tclass(:,temp)&speedclass(:,speedno)&Clusters(:,clusterno));
        tbl(row,3+temp) = sprintf('%4.1f ± %3.1f',mean(f),std(f));
        if isnan(mean(f))
          tbl(row,3+temp) = "-";
        end        
      end
    end
    for solno = 1:3
      % Define Tclass and speedclass for current result table
      T = soltables{solno}.Temperature;
      Tclass = [3<T&T<=7 , 7<T&T<=14 , 14<T&T<=20,20<T&T<=30];
      speed = soltables{solno}.Pullingspeed;
      speedclass = [speed<50,speed>50&speed<250,speed>250];
      [cl1,cl2,cl3] = clusterdefinitions(soltables{solno});
      Clusters = [cl1,cl2,cl3]; 

      row = startrow+2+solno;
      tbl(row,2) = soltext(solno);
      tbl(row,3) = speedtext(2);
      for temp = 1:4
        f = soltables{solno}.Force(Tclass(:,temp)&speedclass(:,2)&Clusters(:,clusterno));
        tbl(row,3+temp) = sprintf('%4.1f ± %3.1f',mean(f),std(f));
        if isnan(mean(f))
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

  