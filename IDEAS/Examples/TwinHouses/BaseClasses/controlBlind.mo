within IDEAS.Examples.TwinHouses.BaseClasses;
model controlBlind

  Modelica.Blocks.Interfaces.RealOutput y(start = 0)
    annotation (Placement(transformation(extent={{92,-10},{112,10}})));

equation
  if time <=20044800+2*3600*24 then
    y=1;
  elseif time >20044800+2*3600*24 and time <= 20044800+24*3600*23 then
    y=0;
  elseif time >20044800 + 24*3600*23 and time <=20044800 + 24*3600*30 then
    y = 1;
  elseif time >20044800 + 24*3600*30 then
    y = 0;
  else
    y = 0;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end controlBlind;
