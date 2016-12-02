within Annex60.Fluid.FixedResistances.Validation;
model HydraulicDiameter
  "Validation test for model with hydraulic diameter"
  import Annex60;
  extends Modelica.Icons.Example;

 package Medium = Annex60.Media.Air "Medium model";

    Modelica.Blocks.Sources.Constant PAtm(k=101325)
      annotation (Placement(transformation(extent={{40,60},{60,80}})));
   parameter Modelica.SIunits.PressureDifference dp_nominal = 5
    "Nominal pressure drop for each resistance";
    Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=2*dp_nominal,
    offset=101325 - dp_nominal)
                 annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Annex60.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    nPorts=1)
    annotation (Placement(transformation(
          extent={{-40,20},{-20,40}})));
  Annex60.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    use_p_in=true,
    nPorts=1)
    annotation (Placement(transformation(
          extent={{56,20},{36,40}})));

  Annex60.Fluid.FixedResistances.HydraulicDiameter res(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    dp_nominal=dpStraightPipe_nominal/aaa,
    dh=0.2,
    deltaM=0.3) "Fixed resistance with specified hydraulic diameter"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

equation
  connect(PAtm.y, sin.p_in) annotation (Line(points={{61,70},{70,70},{70,38},{
          58,38}}, color={0,0,127}));
  connect(P.y, sou.p_in) annotation (Line(points={{-59,70},{-52,70},{-52,38},{
          -42,38}}, color={0,0,127}));
  connect(sou.ports[1], res.port_a)
    annotation (Line(points={{-20,30},{0,30}},          color={0,127,255}));
  connect(res.port_b, sin.ports[1])
    annotation (Line(points={{20,30},{20,30},{36,30}}, color={0,127,255}));
  annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/HydraulicDiameter.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for a fixed resistance that takes as a parameter the hydraulic diameter.
</p>
</html>", revisions="<html>
<ul>
<li>
December 1, 2016, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/480\">#480</a>.
</li>
</ul>
</html>"));
end HydraulicDiameter;
