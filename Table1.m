function tbl = Table1(Tout)
% Data for Table1 in main paper.
% Prints tab-sepatated table that can be copied into a Word table
% In Word: Insert > Table > Insert Table... 
%   6 Columns, 22 Rows, Autofit to contents
%   Mark table and paste

  if nargin < 1
    Tout = run_fit_dual;
  end

  tbl = strings(22,8);
  for rowno = 1:22
    textparts = regexp(Tout.Text(rowno),',','split');
    switch strtrim(textparts{2})
      case 'slow'
        speed = '10';
      case 'normal'
        speed = '100';
      case 'fast'
        speed = '1000';
    end
    temp = strtrim(string(textparts{3}));
    k0 = 10^Tout.log10k0(rowno);
    ci1 = 10^(Tout.log10k0(rowno)-Tout.stdk0(rowno));
    ci2 = 10^(Tout.log10k0(rowno)+Tout.stdk0(rowno));
    DGkin = Tout.DG_kin(rowno)*0.1439;
    stdkin = Tout.stdkin(rowno)*0.1439;
    DGCrooks = Tout.DG_Crooks(rowno);
    stdCrooks = Tout.stdCrooks(rowno);
    DGC = Tout.DG_Crooks(rowno);
    stdC = Tout.stdCrooks(rowno);
    
    tbl(rowno,1) = speed;
    tbl(rowno,2) = temp;
    tbl(rowno,3) = Tout.Cluster(rowno);
    tbl(rowno,4) = string(sprintf('%5.2f ±%5.2f',Tout.Deltax(rowno),Tout.stddx(rowno)));
    % tbl(rowno,4) = string(sprintf('%6.1e (%6.1e-%6.1e)',k0,ci1,ci2)); 
    deltak = (ci2-ci1)/2;
    if k0>1e4
      k0s = sprintf('%0.1f×10%i', 10^mod(log10(k0),1),floor(log10(k0)));
      deltaks = sprintf('%0.1f×10%i', 10^mod(log10(deltak),1),floor(log10(deltak)));
      tbl(rowno,5) = [k0s,' ± ',deltaks];
    else
      tbl(rowno,5) = string(sprintf('%6.2g ± %-6.2g',k0,deltak));
    end
    % tbl(rowno,6) = string(sprintf('%4.1f ± %-4.1f',DGkin,stdkin));
    tbl(rowno,6) = string(sprintf('%4.1f ± %-4.1f',DGCrooks,stdCrooks));

  end
  for i = 1:22
    for j = 1:6
      fprintf('%s\t',tbl(i,j));
    end
    fprintf('\n');
  end
    