within IDEAS.Buildings.Validation.BaseClasses;
model ThermostatSetback "BesTest thermostat setback heating system"

  extends IDEAS.Interfaces.HeatingSystem(nZones=1,nLoads=1);

parameter IDEAS.Occupants.Components.Schedule occ(occupancy=3600*{7, 23},firstEntryOccupied=true);
parameter Modelica.SIunits.Temperature[3] Tset={273.15+10,273.15+20,273.15+27}
    "Heating on below 10C or 20C and cooling on above 27C";

algorithm
if Tset[1] > TSensor and not occ.occupied then
  heatPortCon[1].Q_flow := max(-10*C*(Tset[1] -  TSensor),-1e7);
elseif Tset[2] > TSensor and occ.occupied then
  heatPortCon[1].Q_flow := max(-10*C*(Tset[2] -  TSensor),-1e7);
elseif Tset[3] < TSensor then
  heatPortCon[1].Q_flow := min(-10*C*(Tset[3] - TSensor),1e7);
else
  heatPortCon[1].Q_flow := 0;
end if;

heatPortRad[1].Q_flow :=0;
heatPortEmb[1].Q_flow :=0;

end ThermostatSetback;
