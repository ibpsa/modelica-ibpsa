within IDEAS.Examples.TwinHouses.BaseClasses;
model controlBlind

  Modelica.Blocks.Interfaces.RealOutput[3] y "outputs 1: south oriented windows , 2: north zones, 3: other"
    annotation (Placement(transformation(extent={{92,-10},{112,10}})));
  parameter Integer Exp = 1 "Parameter to select correct experiment (default =1)";
  parameter Integer BuildCase = 1  "Parameter to select the building case. 1: N2 , 2:O5 (default=1)";
equation
  if Exp==1 and BuildCase==2 then
    if time <=20044800+2*3600*24 then
      y[1]=1;
    elseif time >20044800+2*3600*24 and time <= 20044800+24*3600*23 then
      y[1]=0;
    elseif time >20044800 + 24*3600*23 and time <=20044800 + 24*3600*30 then
      y[1] = 1;
    elseif time >20044800 + 24*3600*30 then
      y[1] = 0;
    else
      y[1] = 0;
    end if;
    y[2]=0;
    y[3]=0;
  elseif Exp==1 and BuildCase==1 then
    y[1]=1;
    y[2]=0;
    y[3]=0;
  else
    y[1]=0;
    y[3]=0;
    y[2]=1;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end controlBlind;
