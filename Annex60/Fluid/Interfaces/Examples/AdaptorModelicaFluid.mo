within Annex60.Fluid.Interfaces.Examples;
model AdaptorModelicaFluid "Model that tests the adaptor to Modelica Fluid"
  import Annex60;
extends Modelica.Icons.Example;
 package MediumAnnex60 = Modelica.Media.Air.MoistAir "Medium model";
 package MediumMSL = Modelica.Media.Air.MoistAir "Medium model";

  Annex60.Fluid.Sources.Boundary_pT sin(
    use_p_in=false,
    nPorts=1,
    redeclare package Medium = MediumAnnex60,
    p=101325,
    T=283.15)
      annotation (Placement(
        transformation(extent={{100,-10},{80,10}}, rotation=0)));
  Annex60.Fluid.Sources.MassFlowSource_T bou(
    nPorts=1,
    redeclare package Medium = MediumAnnex60,
    use_m_flow_in=false,
    use_T_in=true,
    m_flow=1) "Boundary condition for mass flow rate"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Annex60.Fluid.Interfaces.AdaptorModelicaFluid ada1(redeclare package
      MediumAnnex60 = MediumAnnex60, redeclare package MediumMSL = MediumMSL)
    "Adaptor"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Annex60.Fluid.Interfaces.AdaptorModelicaFluid ada2(redeclare package
      MediumAnnex60 = MediumAnnex60, redeclare package MediumMSL = MediumMSL)
    "Adaptor"
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort TA60_1(
    redeclare package Medium = MediumAnnex60,
    m_flow_nominal=1,
    tau=0) "Temperature sensor from Annex 60 library"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort TMSL(redeclare package Medium =
        MediumMSL) "Temperature sensor from Modelica Standard Library"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort TA60_2(
    redeclare package Medium = MediumAnnex60,
    m_flow_nominal=1,
    tau=0) "Temperature sensor from Annex 60 library"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=50,
    duration=1,
    offset=273.15) "Medium temperature"
    annotation (Placement(transformation(extent={{-130,-6},{-110,14}})));
equation

  connect(TA60_1.port_b, ada1.portAnnex60) annotation (Line(
      points={{-50,0},{-40,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(TA60_1.port_a, bou.ports[1]) annotation (Line(
      points={{-70,0},{-80,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(ada1.portMSL, TMSL.port_a) annotation (Line(
      points={{-20,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TMSL.port_b, ada2.portMSL) annotation (Line(
      points={{10,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ada2.portAnnex60, TA60_2.port_a) annotation (Line(
      points={{40,0},{50,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(TA60_2.port_b, sin.ports[1]) annotation (Line(
      points={{70,0},{80,0}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(ramp.y, bou.T_in) annotation (Line(
      points={{-109,4},{-102,4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  experiment(StopTime=1),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/AdaptorModelicaFluid.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Model that tests the adaptor between
<a href=\"modelica://Annex60.Fluid\">Annex60.Fluid</a>
and
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{120,
            100}}), graphics));
end AdaptorModelicaFluid;
