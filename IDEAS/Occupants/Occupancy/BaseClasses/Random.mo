within IDEAS.Occupants.Occupancy.BaseClasses;
function Random "random number generator with external storage of the seed"
input Real[3] si
    "input of a random seed, preferably as output of a previous random function";
output Real x
    "output of the requested uniform random variate between zero and one";
output Real[3] so
    "Output of a random seed for input of the following random function";

algorithm
so[1] := abs(rem((171 * si[1]),30269));
so[2] := abs(rem((172 * si[2]),30307));
so[3] := abs(rem((170 * si[3]),30323))
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

x := rem((so[1]/30269.0 +so[2]/30307.0 + so[3]/30323.0),1.0);
end Random;
