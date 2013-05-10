within IDEAS.Buildings.Validation.BaseClasses.HeatingSystem;
model ThermostatSetback "BESTEST thermostat setback heating system"

  extends IDEAS.Interfaces.BaseClasses.HeatingSystem(
                                         final nLoads = 1, QNom = zeros(nZones));

  IDEAS.Occupants.Components.Schedule occ(occupancy=3600*{7, 23},firstEntryOccupied=true)
    "Occupancy shedule";
  parameter Modelica.SIunits.Temperature Tbase = 293.15
    "Heating on below 10degC if non-occupied";
  parameter Modelica.SIunits.Temperature Theat = 293.15
    "Heating on below 20degC if occupied";
  parameter Modelica.SIunits.Temperature Tcool = 300.15
    "Cooling on above 27degC always";

equation
for i in 1:nZones loop
  if (Tbase > TSensor[i]) and not occ.occupied then
    heatPortCon[i].Q_flow =  max(-10*C[i]*(Tbase -  TSensor[i]),-1e7);
  elseif (Theat > TSensor[i]) and occ.occupied then
    heatPortCon[i].Q_flow =  max(-10*C[i]*(Theat -  TSensor[i]),-1e7);
  elseif (Tcool < TSensor[i]) then
    heatPortCon[i].Q_flow =  min(-10*C[i]*(Tcool - TSensor[i]),1e7);
  else
    heatPortCon[i].Q_flow =  0;
  end if;
  heatPortRad[i].Q_flow =  0;
  heatPortEmb[i].Q_flow =  0;
end for;

QHeatTotal = sum(heatPortCon.Q_flow);

wattsLawPlug.P[1] = -1*sum(heatPortCon.Q_flow);
wattsLawPlug.Q[1] = 0
  annotation (Diagram(graphics));
end ThermostatSetback;
