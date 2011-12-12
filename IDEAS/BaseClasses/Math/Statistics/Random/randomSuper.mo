within IDEAS.BaseClasses.Math.Statistics.Random;
function randomSuper
  "random number generator with external storage of the seed"
input Real[4] si
    "input of a random seed, preferably as output of a previous random function";
output Real x
    "output of the requested uniform random variate between zero and one";
output Real[4] so
    "Output of a random seed for input of the following random function";

algorithm
so[1] := abs(rem((11600 * si[1]),2147483579));
so[2] := abs(rem((47003 * si[2]),2147483543));
so[3] := abs(rem((23000 * si[3]),2147483423));
so[4] := abs(rem((33000 * si[3]),2147483123))
    "zero is a poor new input and will be replaced by 1";

 //--> rem-function depicts the 'rest bij deling' or 'remainder after division'...

if so[1] == 0 then
  so[1] := 1;
end if;

if so[2] == 0 then
  so[2] := 1;
end if;

if so[3] == 0 then
  so[3] := 1;
end if;

if so[4] == 0 then
  so[3] := 1;
end if;

x := rem((so[1]/2147483579 +so[2]/2147483543 + so[3]/2147483423 + so[4]/2147483123),1.0);
end randomSuper;
