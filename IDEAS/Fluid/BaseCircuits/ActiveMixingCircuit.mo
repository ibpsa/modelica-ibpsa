within IDEAS.Fluid.BaseCircuits;
model ActiveMixingCircuit "Active mixing circuit"
  extends IDEAS.Fluid.Interfaces.FourPort;
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;

  parameter SI.Mass m=1 "Mass of medium";
  parameter Boolean dynamicBalance=true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation(Dialog(tab="Dynamics", group="Equations"));
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"));

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (__Dymola_choicesAllMatching=true);
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow";

  Valves.Thermostatic3WayValve threeWayValveMotor(m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Sensors.TemperatureTwoPort senTem(m_flow_nominal=m_flow_nominal, tau=120,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  FixedResistances.LosslessPipe pip(m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  FixedResistances.LosslessPipe pip1(m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,10})));
  FixedResistances.LosslessPipe pip3(m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,100})));
  Modelica.Blocks.Interfaces.RealOutput T annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,100})));
  Modelica.Blocks.Interfaces.RealInput TMixedSet annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,100})));
  Movers.FlowMachine_m_flow pump(
    motorCooledByFluid=false,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
equation
  connect(pip3.port_a, port_a2) annotation (Line(
      points={{60,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip3.port_b, pip1.port_a) annotation (Line(
      points={{40,-60},{-10,-60},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip3.port_b, port_b2) annotation (Line(
      points={{40,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(threeWayValveMotor.port_a2, pip1.port_b) annotation (Line(
      points={{-10,50},{-10,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a1, pip.port_a) annotation (Line(
      points={{-100,60},{-60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip.port_b, threeWayValveMotor.port_a1) annotation (Line(
      points={{-40,60},{-20,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_b, port_b1) annotation (Line(
      points={{80,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.T, T) annotation (Line(
      points={{70,71},{70,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(threeWayValveMotor.TMixedSet, TMixedSet) annotation (Line(
      points={{-10,70},{-10,86},{-10,100},{-20,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow_in, pump.m_flow_in) annotation (Line(
      points={{30,100},{30,86},{30,72},{29.8,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.port_b, senTem.port_a) annotation (Line(
      points={{40,60},{60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(threeWayValveMotor.port_b, pump.port_a) annotation (Line(
      points={{0,60},{20,60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(
          points={{40,100},{44,86},{40,70}},
          color={0,255,128},
          smooth=Smooth.None),
        Line(
          points={{-20,100},{-14,80},{-20,60}},
          color={0,255,128},
          smooth=Smooth.None),
        Ellipse(extent={{20,80},{60,40}}, lineColor={0,0,127}),
        Line(
          points={{0,70},{-20,60},{-40,70},{-40,50},{-20,60},{-30,40},{-10,40},{
              -20,60},{0,50},{0,70}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-20,0},{-30,20},{-10,20},{-30,-20},{-10,-20},{-20,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-40,60},{-100,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,60},{100,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-100,-60},{100,-60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-20,40},{-20,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-20,-20},{-20,-60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{0,60},{20,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,60},{28,76},{28,44},{60,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{70,100},{76,80},{74,60}},
          color={255,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{72,62},{76,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end ActiveMixingCircuit;
