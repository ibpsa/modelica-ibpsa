within IDEAS.Buildings.Validation.BaseClasses;
model ThermostatSetback "BesTest thermostat setback heating system"

  extends IDEAS.Interfaces.HeatingSystem(nZones=1,nLoads=1);

IDEAS.Occupants.Components.Schedule occ(occupancy=3600*{7, 23},firstEntryOccupied=true);
parameter Modelica.SIunits.Temperature[3] Tset={273.15+10,273.15+20,273.15+27}
    "Heating on below 10C or 20C and cooling on above 27C";

algorithm
if (Tset[1] > TSensor[1]) and not occ.occupied then
  heatPortCon.Q_flow := ones(nZones)*max(-10*C[1]*(Tset[1] -  TSensor[1]),-1e7);
elseif (Tset[2] > TSensor[1]) and occ.occupied then
  heatPortCon.Q_flow := ones(nZones)*max(-10*C[1]*(Tset[2] -  TSensor[1]),-1e7);
elseif (Tset[3] < TSensor[1]) then
  heatPortCon.Q_flow := ones(nZones)*min(-10*C[1]*(Tset[3] - TSensor[1]),1e7);
else
  heatPortCon.Q_flow := zeros(nZones);
end if;

heatPortRad.Q_flow := zeros(nZones);
heatPortEmb.Q_flow := zeros(nZones);

end ThermostatSetback;
