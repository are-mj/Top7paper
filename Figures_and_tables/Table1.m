function tbl = Table1(Tout)
% Data for Table1 in main paper.
% Prints tab-sepatated table that can be copied into a Word table
% in Word: Insert > Table > Insert Table... 
%   6 Columns, 23 Rows, Autofit to contents
%   Mark table and paste
%   Some post-processing in Word required (e.g. subscript/superscript)

  nrows = 24;
  tbl = strings(nrows,6);
  tbl(1,2) = "Kinetic properties";
  tbl(1,5) = "Thermodynamic properties";
  tbl(2,1) = "Temperature";
  tbl(2,2) = "Speedm/s";
  tbl(2,3) = "Cluster";
  tbl(2,4) = "x‡ (nm)";
  tbl(2,5) = "k0 (s-1)";
  tbl(2,6) = "ΔGCrooks";
  for rowno = 3:nrows
    textparts = regexp(Tout.Text(rowno-2),',','split');
    speed = strtrim(textparts{3});
    temp = strcat(string(textparts{2}),'°C');
    cluster = sprintf('%d',Tout.Clusterno(rowno-2));
    dx = Tout.dx(rowno-2);
    cidx = Tout.cidx(rowno-2,:);
    k0 = 10^Tout.log10k0(rowno-2);
    cik0 = 10.^Tout.cilog10k0(rowno-2,:);
    DGCrooks = Tout.DGCrooks(rowno-2);
    ciCrooks = Tout.ciDGCrooks(rowno-2,:);
    
    if ismember(rowno,[3,12,15,18])
      tbl(rowno,1) = temp;
    end
    tbl(rowno,2) = string(speed);
    tbl(rowno,3) = cluster;
    % tbl(rowno,4) = string(sprintf('%5.2f ±%5.2f',Tout.dx(rowno-2),diff(Tout.cidx(rowno-2,:)/2)));
    tbl(rowno,4) = string(sprintf('%5.2f ±%5.2f',dx,diff(cidx)/2));
    k0string = scientific(k0,1);
    tbl(rowno,5) = strcat(k0string," [",scientific(cik0(1),0),", ",scientific(cik0(2),0),"]");
    tbl(rowno,6) = string(sprintf('%4.1f ± %-4.1f',DGCrooks,diff(ciCrooks)/2));
  end
  for i = 1:nrows
    for j = 1:6
      fprintf('%s\t',tbl(i,j));
    end
    fprintf('\n');
  end
    