function TableS4
% Data for TableS4 in Supplement.
% Input: Tout 
% Prints tab-sepatated table that can be copied into a Word table
% In Word: Insert > Table > Insert Table... 
%   5 Columns, 9 Rows, Autofit to contents
%   Mark table and paste

  load Tables Tout;

  tbl = strings(9,5);
  tbl(1,3) = "Speed (nm/s)";
  tbl(1,2) = "Temperature (°C)";
  tbl(1,4) = "x‡";
  tbl(1,5) = "k0";
  tbl(2,1) = "Refolding";
  for Tout_row = 22:29
    textparts = regexp(Tout.Text(Tout_row),',','split');
    speed = textparts{3};
    tablerow = Tout_row-22 + 2;
    temp = strtrim(string(textparts{2}));
    
    tbl(tablerow,2) = temp;
    tbl(tablerow,3) = speed;
    tbl(tablerow,4) = string(sprintf('%5.2f ± %4.2f',Tout.dx(Tout_row),diff(Tout.cidx(Tout_row,:))/2));

    k0 = 10^Tout.log10k0(Tout_row);
    cik0 = 10.^Tout.cilog10k0(Tout_row,:);
    k0string = scientific(k0,1);
    tbl(tablerow,5) = strcat(k0string," [",scientific(cik0(1),0),", ",scientific(cik0(2),0),"]");    
  end
  for i = 1:9
    for j = 1:5
      fprintf('%s\t',tbl(i,j));
    end
    fprintf('\n');
  end
    