within IDEAS.Occupants.Appliances.Elements;
function StateChange

input Integer stateBefore;
input Boolean action;
input Real minLeftBefore;
input Integer occ;
input Real r1;
input Real r2;
input Real lengthCycle;
input Real[3] seed;

output Integer state;
output Real minLeft;

algorithm
if occ < 0.1 then
  state := 0;
  minLeft := 0;
elseif stateBefore > 0 and minLeftBefore >= 1 then
  state := stateBefore;
  minLeft := minLeftBefore-1;
elseif stateBefore > 0 and minLeftBefore < 1 then
  state := 0;
  minLeft := 0;
elseif stateBefore < 1 and action then
  if lengthCycle > 72 and lengthCycle < 74 then
    state := 1;
    minLeft := 70*(0-Modelica.Math.log(1-r2))^1.1 "exception for TV";
  else
    state := 1;
    minLeft := IDEAS.Occupants.Occupancy.Random.NormalVariate(
                                                          mu=lengthCycle,sigma=lengthCycle/10,si=seed);
  end if;
else
  state := 0;
  minLeft := 0;
  end if;

end StateChange;
