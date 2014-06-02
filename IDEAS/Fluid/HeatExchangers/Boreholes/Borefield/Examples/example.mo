within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Examples;
model example
  "Model of a borefield with axb borefield and a constant heat injection rate"

  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.HeatFlowRate q = 30
    "heat flow rate which is injected per meter depth of borehole";

  parameter Data.BorefieldData.example
    bfData
    annotation (Placement(transformation(extent={{-70,52},{-50,72}})));
  parameter Integer lenSim=3600*24*20 "length of the simulation";

  MultipleBoreHoles_MBL multipleBoreholes(lenSim=lenSim, bfData=bfData)
    "borefield"
    annotation (Placement(transformation(extent={{-34,-68},{36,2}})));
  Modelica.Blocks.Sources.RealExpression load(y=q*bfData.geo.hBor)
    "load for the borefield"
    annotation (Placement(transformation(extent={{-82,2},{-62,22}})));
  Modelica.Blocks.Interfaces.RealOutput T_fts
    "Average of the in and outlet temperature of the borefield"
    annotation (Placement(transformation(extent={{92,-10},{112,10}})));

equation
  connect(multipleBoreholes.T_fts, T_fts)  annotation (Line(
      points={{1.5,-57.5},{62,-57.5},{62,0},{102,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load.y, multipleBoreholes.Q_flow) annotation (Line(
      points={{-61,12},{1,12},{1,-11.5}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=1.7e+006, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end example;
