function tbl = TableS4(Tout)
% Data for TableS4 in Supplement.
% Prints tab-sepatated table that can be copied into a Word table
% In Word: Insert > Table > Insert Table... 
%   5 Columns, 8 Rows, Autofit to contents
%   Mark table and paste

  if nargin < 1
    load Top7tables Tout;
  end

  tbl = strings(8,5);
  for rowno = 15:22
    textparts = regexp(Tout.Text(rowno),',','split');
    switch strtrim(textparts{2})
      case 'slow'
        speed = '10';
      case 'normal'
        speed = '100';
      case 'fast'
        speed = '1000';
    end
    newrow = rowno-14;
    temp = strtrim(string(textparts{3}));
    k0 = 10^Tout.log10k0(rowno);
    ci1 = 10^(Tout.log10k0(rowno)-Tout.stdk0(rowno));
    ci2 = 10^(Tout.log10k0(rowno)+Tout.stdk0(rowno));
    
    tbl(newrow,1) = speed;
    tbl(newrow,2) = temp;
    tbl(newrow,3) = Tout.Cluster(rowno);
    tbl(newrow,4) = string(sprintf('%5.2f ±%5.2f',Tout.Deltax(rowno),Tout.stddx(rowno)));
    % tbl(newrow,4) = string(sprintf('%6.1e (%6.1e-%6.1e)',k0,ci1,ci2)); 
    deltak = (ci2-ci1)/2;
    if k0>1e4
      k0s = sprintf('%0.1f×10%i', 10^mod(log10(k0),1),floor(log10(k0)));
      deltaks = sprintf('%0.1f×10%i', 10^mod(log10(deltak),1),floor(log10(deltak)));
      tbl(newrow,5) = [k0s,' ± ',deltaks];
    else
      tbl(newrow,5) = string(sprintf('%6.2g ± %-6.2g',k0,deltak));
    end
    % tbl(newrow,6) = string(sprintf('%4.1f ± %-4.1f',DGkin,stdkin));
    % tbl(newrow,6) = string(sprintf('%4.1f ± %-4.1f',DGCrooks,stdCrooks));

  end
  for i = 1:8
    for j = 1:5
      fprintf('%s\t',tbl(i,j));
    end
    fprintf('\n');
  end
    