within IDEAS.Buildings.Validation.BaseClasses.HeatingSystem;
model ThermostatSetback "BESTEST thermostat setback heating system"

  extends IDEAS.Interfaces.BaseClasses.HeatingSystem(
    radiators=true,
    floorHeating=true,
    final nLoads=1,
    QNom=zeros(nZones));

protected
  IDEAS.Occupants.Components.Schedule occ(occupancy=3600*{7,23},
      firstEntryOccupied=true) "Occupancy shedule";
  parameter Modelica.SIunits.Temperature Tbase=283.15
    "Heating on below 10degC if non-occupied";
  parameter Modelica.SIunits.Temperature Theat=293.15
    "Heating on below 20degC if occupied";
  parameter Modelica.SIunits.Temperature Tcool=300.15
    "Cooling on above 27degC always";

  Modelica.Blocks.Sources.RealExpression realP(y=0.0)
    annotation (Placement(transformation(extent={{116,18},{136,38}})));
  Modelica.Blocks.Sources.RealExpression realQ(y=0.0)
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
equation
  for i in 1:nZones loop
    if (Tbase > TSensor[i]) and not occ.occupied then
      heatPortCon[i].Q_flow = max(-10*C[i]*(Tbase - TSensor[i]),-1e7);
    elseif (Theat > TSensor[i]) and occ.occupied then
      heatPortCon[i].Q_flow = max(-10*C[i]*(Theat - TSensor[i]),-1e7);
    elseif (Tcool < TSensor[i]) then
      heatPortCon[i].Q_flow = min(-10*C[i]*(Tcool - TSensor[i]),1e7);
    else
      heatPortCon[i].Q_flow = 0;
    end if;
    heatPortRad[i].Q_flow = 0;
    heatPortEmb[i].Q_flow = 0;
  end for;

  QHeatTotal = -1*sum(heatPortCon.Q_flow);

  connect(realQ.y, wattsLawPlug.Q[1]) annotation (Line(
      points={{141,-10},{174,-10},{174,2},{170,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realP.y, wattsLawPlug.P[1]) annotation (Line(
      points={{137,28},{174,28},{174,6},{170,6}},
      color={0,0,127},
      smooth=Smooth.None));
end ThermostatSetback;
