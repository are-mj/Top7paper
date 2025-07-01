function [TRIPL,TZIP] = analyse_many(files,plotting,par)
% Analyses all experiments in files.  Compensates for calibration error in
% September 2023.
  if nargin < 2
    plotting = 0;
  end
  if nargin < 3
    par = params;
  end
  TRIPL = [];
  TZIP = [];
  for i = 1:numel(files)
    [Trip,Tzip]  = analyse_experiment(files(i),plotting,par);
    drawnow;
    if isempty(Trip)
      continue
    end
    fprintf('Rips: %4d, Zips: %4d Filename: %s\n', ...
      sum(Trip.Fdot>0),height(Tzip),files(i));
    TRIPL = [TRIPL;Trip];
    TZIP = [TZIP;Tzip];
  end
  TRIPL = correct_bias(TRIPL);
  TZIP = correct_bias(TZIP);
end

function T = correct_bias(T)
% Correct calibration error in Top7 experiments in August and September
% Top7 experiment files from 2023-08-01 through 2023-09-16 suffer from 
% calibration  error in Trapx.  Corret by multiplying deltax by 1.11

% Remember to do this for both pull and relax tables

  recalib = T.Filename > "20230800" & T.Filename < "20230916";
  T.Deltax(recalib) = T.Deltax(recalib)*1.11;
end