within Annex60.Fluid.FixedResistances.Examples;
model FixedResistances3Way "Test of multiple resistances in series"
  extends Modelica.Icons.Example;

 package Medium = Annex60.Media.Water;

   parameter Modelica.SIunits.Pressure dp_nominal = 5
    "Nominal pressure drop for each resistance";
  parameter Integer nRes( min=2) = 10 "Number of resistances";
  inner Modelica.Fluid.System system(p_ambient=101325)
                                   annotation (Placement(transformation(extent={{-80,-80},
            {-60,-60}},        rotation=0)));
  Modelica.Fluid.Sources.FixedBoundary boundary(redeclare package Medium =
        Medium, nPorts=1)
    annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
  Modelica.Fluid.Vessels.ClosedVolume
                             volume(
    redeclare package Medium = Medium,
    V=1,
    m_flow_nominal=1,
    use_portsData=false,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Modelica.Fluid.Fittings.SimpleGenericOrifice res1(
    redeclare package Medium = Medium,
    diameter=0.01,
    zeta=1,
    m_flow_nominal=1,
    dp_nominal(displayUnit="Pa") = 1) "Resistance"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Fluid.Fittings.SimpleGenericOrifice res2(
    redeclare package Medium = Medium,
    diameter=0.01,
    zeta=1,
    m_flow_nominal=1,
    dp_nominal(displayUnit="Pa") = 1) "Resistance"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
  for i in 1:nRes-1 loop
  end for;
  connect(boundary.ports[1], res1.port_a) annotation (Line(
      points={{-42,0},{-20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, volume.ports[1]) annotation (Line(
      points={{0,0},{38,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volume.ports[2], res2.port_b) annotation (Line(
      points={{42,0},{42,-30},{4.44089e-16,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_a, res1.port_a) annotation (Line(
      points={{-20,-30},{-30,-30},{-30,0},{-20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),
                         graphics),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/FixedResistances3Way.mos"
        "Simulate and plot"));
end FixedResistances3Way;
