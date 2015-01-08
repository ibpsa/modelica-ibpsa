within IDEAS.Electric.Batteries.Examples;
model TestBattery
  // Test the charging and discharging of a battery

  Modelica.SIunits.Power Pnet;

  Distribution.GridGeneral gridGeneral(redeclare
      IDEAS.Electric.Data.Grids.TestGrid2Nodes grid)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  BatterySystemGeneral batterySystemGeneral(
    redeclare IDEAS.Electric.Data.Batteries.LiIon technology,
    SoC_start=0.6,
    Pnet=Pnet,
    EBat=10) annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=1500,
    startTime=2700,
    height=-8000)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=4000,
    duration=1500,
    startTime=600)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  BaseClasses.WattsLaw wattsLaw
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Math.Add3 add3_1
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    height=4000,
    duration=1500,
    startTime=4800)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  Pnet = ramp1.y + ramp2.y + ramp3.y;
  connect(gridGeneral.gridNodes[2], batterySystemGeneral.pin[1]) annotation (
      Line(
      points={{-60,-30},{0.4,-30}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(wattsLaw.vi[1], gridGeneral.gridNodes[2]) annotation (Line(
      points={{20,50},{40,50},{40,0},{-30,0},{-30,-30},{-60,-30}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(const.y, wattsLaw.Q) annotation (Line(
      points={{-19,20},{-10,20},{-10,48},{0,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, add3_1.u1) annotation (Line(
      points={{-59,90},{-50,90},{-50,58},{-42,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, add3_1.u2) annotation (Line(
      points={{-59,50},{-42,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp3.y, add3_1.u3) annotation (Line(
      points={{-59,10},{-50,10},{-50,42},{-42,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add3_1.y, wattsLaw.P) annotation (Line(
      points={{-19,50},{-10,50},{-10,54},{0,54}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end TestBattery;
