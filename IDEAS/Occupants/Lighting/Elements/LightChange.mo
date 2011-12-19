within IDEAS.Occupants.Lighting.Elements;
function LightChange

input Integer stateBefore;
input Boolean action;
input Real minLeftBefore;
input Real effOcc;
input Real relUse;
input Real r1;
input Real r2;

output Integer state;
output Real minLeft;

algorithm
if effOcc < 0.1 then
  state := 0;
  minLeft := 0;
elseif stateBefore > 0 and minLeftBefore >= 1 then
  state := stateBefore;
  minLeft := minLeftBefore-1;
elseif stateBefore > 0 and minLeftBefore < 1 then
  state := 0;
  minLeft := 0;
elseif stateBefore < 1 and action and r1 < effOcc*relUse then
  state := 1;
  minLeft :=exp((r2 - 0.1084)/0.1664);
else
  state := 0;
  minLeft := 0;
  end if;

end LightChange;
