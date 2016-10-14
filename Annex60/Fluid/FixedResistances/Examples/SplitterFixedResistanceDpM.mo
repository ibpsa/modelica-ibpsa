within Annex60.Fluid.FixedResistances.Examples;
model SplitterFixedResistanceDpM
  "Test model for the three way splitter/mixer model"
  extends Modelica.Icons.Example;

 package Medium = Annex60.Media.Air "Medium model";

  Annex60.Fluid.FixedResistances.SplitterFixedResistanceDpM spl(
    m_flow_nominal={1,2,3},
    dh={1,2,3},
    redeclare package Medium = Medium,
    dp_nominal(each displayUnit="Pa") = {5,10,15},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Splitter"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Annex60.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    use_p_in=true,
    nPorts=1)
    "Pressure boundary condition"
     annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Annex60.Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{40,-10},{20,10}})));
  Annex60.Fluid.Sources.Boundary_pT bou3(
    redeclare package Medium = Medium,
    T=273.15 + 30,
    use_p_in=true,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{-52,-66},{-32,-46}})));
    Modelica.Blocks.Sources.Constant P2(k=101325)
    "Constant pressure signal"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,40})));
    Modelica.Blocks.Sources.Ramp P1(
    offset=101320,
    height=10,
    duration=0.5)
    "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-90,-2},{-70,18}})));
    Modelica.Blocks.Sources.Ramp P3(
      offset=101320,
      height=10,
    duration=0.5,
    startTime=0.5)
    "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-92,-58},{-72,-38}})));
equation
  connect(P1.y, bou1.p_in)
    annotation (Line(points={{-69,8},{-69,8},{-52,8}},
                    color={0,0,127}));
  connect(P2.y, bou2.p_in) annotation (Line(points={{61,40},{74,40},{74,8},{42,
          8}}, color={0,0,127}));
  connect(bou3.p_in, P3.y)
    annotation (Line(points={{-54,-48},{-54,-48},{-71,-48}},
                                                   color={0,0,127}));
  connect(bou1.ports[1], spl.port_1) annotation (Line(
      points={{-30,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou3.ports[1], spl.port_3) annotation (Line(
      points={{-32,-56},{0,-56},{0,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(spl.port_2, bou2.ports[1]) annotation (Line(
      points={{10,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/SplitterFixedResistanceDpM.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model demonstrates the use of the splitter and mixer model
for different flow directions.
</p>
</html>", revisions="<html>
<ul>
<li>
October 14, 2017 by Michael Wetter:<br/>
Updated documentation and added to Annex 60 library.<br/>
This is for
<a href=\"modelica://https://github.com/iea-annex60/modelica-annex60/issues/451\">issue 451</a>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>
</html>"));
end SplitterFixedResistanceDpM;
