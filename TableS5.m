function TableS5
  load Top7tables Tout;
  tbl = strings(14,7);
  for rowno = 1:14
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
    k0 = 10^Tout.log10k0Dudko(rowno);
    deltak = Tout.stdk0Dudko(rowno);
    % ci1 = 10^(Tout.log10k0Dudko(rowno)-Tout.stdk0Dudko(rowno));
    % ci2 = 10^(Tout.log10k0Dudko(rowno)+Tout.stdk0Dudko(rowno));
    dx = Tout.DeltaxDudko(rowno);
    stddx = Tout.stddxDudko(rowno);
    G = Tout.GDudko(rowno)*0.1439;
    stdG = Tout.stdGDudko(rowno)*0.1439;
    Gkin = Tout.DG_kin(rowno)*0.1439;
    stdGkin = Tout.stdkin(rowno)*0.1439;
    
    tbl(rowno,1) = Tout.Cluster(rowno); 
    tbl(rowno,2) = speed;
    tbl(rowno,3) = temp;
    tbl(rowno,4) = sprintf('%4.2f± %4.2f',dx,stddx);
    if k0>1e4
      k0s = sprintf('%0.1f×10%i', 10^mod(log10(k0),1),floor(log10(k0)));
      deltaks = sprintf('%0.1f×10%i', 10^mod(log10(deltak),1),floor(log10(deltak)));
      tbl(rowno,5) = [k0s,' ± ',deltaks];
    else
      tbl(rowno,5) = string(sprintf('%6.2g ± %-6.2g',k0,deltak));
    end    
    tbl(rowno,6) = sprintf('%4.2f± %4.2f',G,stdG);
    tbl(rowno,7) = sprintf('%4.1f± %3.1f',Gkin,stdGkin);
  end
  for i = 1:14
    for j = 2:7
      fprintf('%s\t',tbl(i,j));
    end
    fprintf('\n');
  end
    