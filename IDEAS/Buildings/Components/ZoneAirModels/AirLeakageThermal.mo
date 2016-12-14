within IDEAS.Buildings.Components.ZoneAirModels;
model AirLeakageThermal
  extends IDEAS.Buildings.Components.ZoneAirModels.BaseClasses.PartialAirLeakage;
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,-50})));
equation
  hDiff = cp_default*(heatPort.T - Te.y);
  connect(prescribedHeatFlow.port, heatPort)
    annotation (Line(points={{0,-60},{0,-100},{0,-100}}, color={191,0,0}));
  connect(Qgai.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-18.1,44},{0,44},{0,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AirLeakageThermal;
