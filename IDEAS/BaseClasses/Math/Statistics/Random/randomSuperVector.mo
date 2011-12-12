within IDEAS.BaseClasses.Math.Statistics.Random;
function randomSuperVector
  "random number generator with external storage of the seed"

input Integer n;
input Real[4] si
    "input of a random seed, preferably as output of a previous random function";
output Real r[n]
    "output of the requested uniform random variate between zero and one";
output Real[4] so
    "Output of a random seed for input of the following random function";

protected
Real[n] x;
Real[n] y;

algorithm
so[1] := abs(rem((11600 * si[1]),2147483579));
so[2] := abs(rem((47003 * si[2]),2147483543));
so[3] := abs(rem((23000 * si[3]),2147483423));
so[4] := abs(rem((33000 * si[3]),2147483123))
    "zero is a poor new input and will be replaced by 1";

for i in 1:4 loop
  if so[i] == 0 then
    so[i] := 1;
  end if;
end for;

x[1]:=so[1];
y[1]:=so[2];

for i in 2:n loop
  x[i]:=abs(rem((46340*x[i-1]),46341))-41639*(x[i-1]/46341);
  y[i]:=abs(rem((22000*y[i-1]),97612))-19543*(y[i-1]/97612);
end for;

for i in 2:n loop
  if x[i] == 0 then
    x[i] := 1;
  end if;
  if y[i] == 0 then
    y[i] := 1;
  end if;
end for;

 //--> rem-function depicts the 'rest bij deling' or 'remainder after division'...

r[1] := abs(rem((so[1]/2147483579 +so[2]/2147483543 + so[3]/2147483423 + so[4]/2147483123),1.0));

for i in 2:n loop
  r[i]:=abs(rem((x[i]/46341 +y[i]/97612 + so[3]/2147483423 + so[4]/2147483123),1.0));
  end for;

end randomSuperVector;
