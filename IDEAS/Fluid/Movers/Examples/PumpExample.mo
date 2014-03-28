within IDEAS.Fluid.Movers.Examples;
model PumpExample "Example of how a pump can be used"
  import IDEAS;
  extends Modelica.Icons.Example;

  IDEAS.BaseClasses.Pump pump(redeclare package Medium = Medium, m_flow_nominal
      =1) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Annex60.Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Annex60.Fluid.Sources.Boundary_pT bou1(nPorts=1, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{68,-10},{48,10}})));
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
equation
  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{-38,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, bou1.ports[1]) annotation (Line(
      points={{10,0},{48,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end PumpExample;
