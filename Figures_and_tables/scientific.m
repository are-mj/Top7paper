
function s = scientific(x,digits)
%  Create representation of x suited for use in a paper in Word
%   Input: x: number
%       digits: number of digits after decimal points (defult: 2)
%  Examples:
%     s = scientific(2.34567e-5,2)
%       s = "2.35 × 10-05"
%     s = scientific(2.34567e5)
%       s = "2.35 × 105"
% In Word, format the exponent as superscript

  if nargin < 2
    digits = 2;
  end
  times= " × ";
  times = "·";  % Alternative multiplication notation

  if x == 0
    s = "0";
    return
  elseif x == Inf
    s = "Inf";
    return
  end
  format = strcat('%',sprintf(".%de",digits));
  s1 = char(sprintf(format,x));
  [p1,p2] = regexp(s1,'e-?');
  if p1==p2 % No exponent sign
    exponent = strip(s1(p1+1:end),"left","+");
    exponent = strip(exponent,"left",'0');
  else
    exp = strip(s1(p2+1:end),"left",'0');
    exponent = strcat(s1(p2),exp);
  end
  if isempty(exponent)
    exponent = "0";
  end
  s = strcat(s1(1:p1-1),times,"10",exponent);
end