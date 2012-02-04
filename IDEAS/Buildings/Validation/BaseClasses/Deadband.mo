within IDEAS.Buildings.Validation.BaseClasses;
model Deadband "BesTest deadband heating system"
  extends IDEAS.Interfaces.HeatingSystem(nZones=1,nLoads=1);

parameter Modelica.SIunits.Temperature[2] Tset={273.15+20,273.15+27}
    "Heating on below 20°C and cooling on above 27°C";

algorithm
if (Tset[1] > TSensor) then
  heatPortCon.Q_flow := -10*C*(Tset[1] -  TSensor);
elseif (Tset[2] < TSensor) then
  heatPortCon.Q_flow := -10*C*(Tset[2] - TSensor);
else
  heatPortCon.Q_flow := 0;
end if;

equation
heatPortRad.Q_flow =  0;
heatPortEmb.Q_flow =  0;

  annotation (Diagram(graphics));
end Deadband;
