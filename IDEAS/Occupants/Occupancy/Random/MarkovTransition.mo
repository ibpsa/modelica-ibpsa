within IDEAS.Occupants.Occupancy.Random;
function MarkovTransition

input Integer size;
input Real[size,size+1] transMatrixCumul;
input Integer occBefore;
input Real random;

output Integer occ;

algorithm
    for m in 2:size+1 loop
      if random < transMatrixCumul[occBefore+1,m] and random >  transMatrixCumul[occBefore+1,m-1] then
        occ := m-2;
      end if;
    end for;

end MarkovTransition;
