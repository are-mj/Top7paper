function TableS6
% Bell model results for the experiments with solutes Top7, BSA and FoxP1
% Prints tab-sepatated table that can be copied into a Word table
% in Word: Insert > Table > Insert Table... 
%   12 Columns, 12 Rows, Autofit to contents
%   Mark table and paste
%   Some post-processing in Word required (e.g. subscript/superscript)

  load Tables.mat TRIPTop7Top7 TRIPTop7BSA TRIPTop7FOXP1
  load Tables.mat TZIPTop7Top7 TZIPTop7BSA TZIPTop7FOXP1
  Result_tables = {TRIPTop7Top7 TRIPTop7BSA TRIPTop7FOXP1; ...
    TZIPTop7Top7 TZIPTop7BSA TZIPTop7FOXP1};

  Texts = [  % Unique members of Tout.Text
    "Unfolding, 3-7, <50"
    "Unfolding, 3-7, 50-250"
    "Unfolding, 3-7, >250"
    "Unfolding, 7-14, 50-250"
    "Unfolding, 14-20, 50-250"
    "Unfolding, 20-30, <50"
    "Unfolding, 20-30, 50-250"
    "Unfolding, 20-30, >250"];

  % tbl = strings(25,12);
  tbl(1,4) = "Top7";
  tbl(1,7) = "BSA";
  tbl(1,10) = "FoxP1";
  tbl(2,1) = "Temperature (°C)";
  tbl(2,2) = "Speed (nm/s)";
  tbl(2,3) = "Cluster";
  tbl(2,4:3:10) = "x‡ (nm)";
  tbl(2,5:3:11) = "k0 (s-1)";
  tbl(2,6:3:12) = "ΔGCrooks (kcal/mol)";
  
  for soluteno = 1:3
    TRIP = Result_tables{1,soluteno};
    TZIP = Result_tables{2,soluteno};
    Tout = fit_unfold(TRIP,TZIP);
    for Toutrow = 1:height(Tout)
      textrow = find(Tout.Text(Toutrow)==Texts);
      if isempty(textrow)
        continue
      end
      row = (textrow-1)*3 + Tout.Cluster(Toutrow) + 2;  % Row in table
      textparts = regexp(Tout.Text(Toutrow),',','split');
      speed = strtrim(textparts{3});
      % temp = strcat(string(textparts{2}),'°C');
      temp = string(textparts{2});
      tbl(row,1) = temp;
      tbl(row,2) = speed;
      tbl(row,3) = sprintf('%d',Tout.Cluster(Toutrow));
      dx = Tout.dx(Toutrow);
      ciudx = Tout.ciudx(Toutrow,:);

      tbl(row,1+3*soluteno) = sprintf("%6.2f ± %3.2f",dx,diff(ciudx)/2);

      % k0 = scientific(10^Tout.log10k0(Toutrow),1);        
      % % k0std = scientific(10^Tout.stdk0(Toutrow),1);    
      % k0std = sprintf('%3.1f',10^Tout.stdk0(Toutrow));
      % tbl(row,2+3*soluteno) = sprintf("%6s ± %3s",k0,k0std);

      k0string = scientific(10^Tout.log10k0(Toutrow),1); 
      cik0 = 10.^Tout.ciuk0(Toutrow,:);
      tbl(row,2+3*soluteno) = strcat(k0string," [",scientific(cik0(1),0),", ",scientific(cik0(2),0),"]");      

      DGCrooks = Tout.DGCrooks(Toutrow);
      ciCrooks = Tout.ciCrooks(Toutrow,:);
      tbl(row,3+3*soluteno) = sprintf("%6.1f ± %4.2f",DGCrooks,diff(ciCrooks)/2);  
    end
    switch soluteno
      case 1
        ToutTop7Top7 = Tout;
      case 2
        ToutTop7BSA = Tout;
      case 3
        ToutTop7FOXP = Tout;
    end    
  end
  save Fitted_results ToutTop7Top7 ToutTop7BSA ToutTop7FOXP 
  for i = 1:height(tbl)
    if all(ismissing(tbl(i,:)))
      continue   % skip empty rows
    end
    tbl(i,ismissing(tbl(i,:))) = "";  % Fill in missing entries with ""
    for j = 1:12
      fprintf('%s\t',tbl(i,j));
    end
    fprintf('\n');
  end  
end



    