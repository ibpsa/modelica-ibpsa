within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Examples;
model example_accurate
  extends Modelica.Icons.Example;

  parameter Data.BorefieldData.example_accurate
    bfData
    annotation (Placement(transformation(extent={{-70,52},{-50,72}})));
  parameter Integer lenSim=3600*24*20;

  MultipleBoreHoles_MBL multipleBoreholes(lenSim=lenSim, bfData=bfData)
    annotation (Placement(transformation(extent={{-34,-68},{36,2}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=30*bfData.geo.hBor)
    annotation (Placement(transformation(extent={{-88,-22},{-68,-2}})));
  Modelica.Blocks.Interfaces.RealOutput T_fts
    annotation (Placement(transformation(extent={{92,-10},{112,10}})));

equation
  connect(realExpression.y, multipleBoreholes.Q_flow)  annotation (Line(
      points={{-67,-12},{-47.35,-12},{-47.35,-11.5},{1,-11.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multipleBoreholes.T_fts, T_fts)  annotation (Line(
      points={{1.5,-57.5},{62,-57.5},{62,0},{102,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=1.7e+006, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end example_accurate;
