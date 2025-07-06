function TableS5
% Data for TableS5
% Prints tab-sepatated table that can be copied into a Word table
% in Word: Insert > Table > Insert Table... 
%   8 Columns, 19 Rows, Autofit to contents
%   Mark table and paste
%   Some post-processing in Word required (e.g. subscript/superscript)

  load Tables.mat TRIP TZIP Tout

  DGkin = Tout.DGkin;
  ciDGkin = Tout.ciDGkin;
  DG = Tout.DGDudko;
  ciDG = Tout.ciDGDudko;
  dx = Tout.dxDudko;
  cidx = Tout.cidxDudko;
  k0 = 10.^Tout.log10k0Dudko;
  cik0 = 10.^Tout.cilog10k0Dudko;
 
  ucases = cases;
  temptext = strings(21,1);
  speedtext = strings(21,1);
  Clusters = zeros(21,1);
  rips = zeros(21,1);
  k = 1;
  for i = 1:8
    textparts = regexp(ucases(i).text,',','split');
    temptext(k) = textparts(2);
    for j = find(ucases(i).nrips>9)
      speedtext(k) = textparts(3);
      Clusters(k) = j;
      rips(k) = ucases(i).nrips(j);
      k = k+1;
    end
  end

  nrows = 22;
  
  tbl = strings(22,8);
  tbl(2,1) = "Temperature";
  tbl(2,2) = "Speed (m/s)";
  tbl(2,3) = "Cluster";
  tbl(1,4) = "x‡ (nm)";
  tbl(1,5) = "k0 (s-1)";
  tbl(1,6) = "ΔG‡D (kcal/min)";
  tbl(1,7) = "ΔGkin (kcal/min)";
  tbl(1,8) = "Rips";

  k = 1;
  for rowno = 2:nrows
    temp = strcat(temptext(k),'°C');
    speed = strtrim(speedtext(k));
    cluster = sprintf('%d',Clusters(k));
    if ismember(rowno,[2,11,14,17])
      tbl(rowno,1) = temp;
    end
    tbl(rowno,2) = string(speed);
    tbl(rowno,3) = cluster;
    tbl(rowno,4) = string(sprintf('%5.2f ±%5.2f',dx(k),diff(cidx(k,:)/2)));
    k0string = scientific(k0(k),1);
    tbl(rowno,5) = strcat(k0string," [",scientific(cik0(k,1),0),", ",scientific(cik0(k,2),0),"]");
    tbl(rowno,6) = string(sprintf('%5.1f ±%4.1f',DG(k),diff(ciDG(k,:))/2));
    tbl(rowno,7) = string(sprintf('%5.1f ±%4.1f',DGkin(k),diff(ciDGkin(k,:))/2));
    tbl(rowno,8) = rips(k);
    k = k+1;
  end  
  for i = 1:22
    for j = 1:8
      fprintf('%s\t',tbl(i,j));
    end
    fprintf('\n');
  end  
end
    