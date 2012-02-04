within IDEAS.Buildings.Validation.BaseClasses;
model Deadband "BesTest deadband heating system"
  extends IDEAS.Interfaces.HeatingSystem(nZones=1,nLoads=1);

parameter Modelica.SIunits.Temperature[1] Theat={273.15+20}
    "Heating on below 20°C and cooling on above 27°C";
parameter Modelica.SIunits.Temperature[1] Tcool={273.15+27}
    "Heating on below 20°C and cooling on above 27°C";

algorithm
if Theat[1] > TSensor[1] then
  heatPortCon.Q_flow := -ones(nZones)*10*C*(Theat -  TSensor);
elseif Tcool[1] < TSensor[1] then
  heatPortCon.Q_flow := -ones(nZones)*10*C*(Tcool - TSensor);
else
  heatPortCon.Q_flow := zeros(nZones);
end if;

equation
heatPortRad.Q_flow =  zeros(nZones);
heatPortEmb.Q_flow =  zeros(nZones);

  annotation (Diagram(graphics));
end Deadband;
