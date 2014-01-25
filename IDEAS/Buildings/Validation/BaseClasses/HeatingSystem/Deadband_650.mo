within IDEAS.Buildings.Validation.BaseClasses.HeatingSystem;
model Deadband_650 "BESTEST deadband heating system"
  extends IDEAS.Interfaces.BaseClasses.HeatingSystem(
    radiators=true,
    floorHeating=true,
    final nLoads=1,
    QNom=zeros(nZones));

protected
  parameter Modelica.SIunits.Temperature Theat=0 "No Heating";
  parameter Modelica.SIunits.Temperature Tcool=300.15 "Cooling on above 27degC";

  Modelica.Blocks.Sources.RealExpression realP(y=QHeatTotal)
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Modelica.Blocks.Sources.RealExpression realQ(y=0.0)
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));

equation
  for i in 1:nZones loop
    if Theat > TSensor[i] then
      heatPortCon[i].Q_flow = -1*C[i]*(Theat - TSensor[i]);
    elseif Tcool < TSensor[i] then
      heatPortCon[i].Q_flow = -1*C[i]*(Tcool - TSensor[i]);
    else
      heatPortCon[i].Q_flow = 0;
    end if;
    heatPortRad[i].Q_flow = 0;
    heatPortEmb[i].Q_flow = 0;
  end for;

  QHeatTotal = sum(heatPortRad.Q_flow) + sum(heatPortCon.Q_flow) + sum(
    heatPortEmb.Q_flow);

  connect(realP.y, wattsLawPlug.P[1]) annotation (Line(
      points={{141,20},{154,20},{154,6},{170,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realQ.y, wattsLawPlug.Q[1]) annotation (Line(
      points={{141,-20},{154,-20},{154,2},{170,2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -100},{200,100}}), graphics));
end Deadband_650;
