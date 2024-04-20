% correct_bias.m
% A series of experiments was done without proper instrument calibration
% This script brings results in line with the other data

% correct calibration error in files from 2023-08-01 through 2023-09-15
recalibu = Tun.Filename > "20230800" & Tun.Filename < "20230916";
Tun.Deltax(recalibu) = Tun.Deltax(recalibu)*1.11;
recalibr= Tre.Filename > "20230800" & Tre.Filename < "20230916";
Tre.Deltax(recalibr) = Tre.Deltax(recalibr)*1.11;