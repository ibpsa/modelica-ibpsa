within Annex60.Experimental.Pipe.BaseClasses;
model HeatLossDoubleParallel
  "Heat loss model for pipe when second pipe with parallel flow is present with delay calculation at pipe level"
  extends Fluid.Interfaces.PartialTwoPortTransport;

  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.Diameter diameter "Pipe diameter";

  parameter Types.ThermalCapacityPerLength C
    "Capacitance of the water volume in J/(K.m)";
  parameter Types.ThermalResistanceLength Ra
    "Resistance for asymmetric problem, in Km/W";
  parameter Types.ThermalResistanceLength Rs
    "Resistance for symmetric problem, in Km/W";
  final parameter Modelica.SIunits.Time tau_charSymm=Rs*C
    "Time constant for symmetric problem";
  final parameter Modelica.SIunits.Time tau_charAsymm=Ra*C
    "Time constant for asymmetric problem";

  Modelica.SIunits.Temperature Tin_a
    "Temperature at port_a for in-flowing fluid";
  Modelica.SIunits.Temperature Tout_b
    "Temperature at port_b for out-flowing fluid";

  Modelica.SIunits.Temperature T_amb=heatPort.T "Environment temperature";
  Modelica.SIunits.HeatFlowRate Qloss "Heat losses from pipe to environment";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5;

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Ambient temperature of pipe's surroundings" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealInput T_2in(unit="K", displayUnit="degC")
    "Inlet temperature of other pipe if present" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-60,-100})));
  Modelica.Blocks.Interfaces.RealOutput T_2out(unit="K", displayUnit="degC")
    "Ambient temperature of pipe's surroundings" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={60,-100})));
  Modelica.Blocks.Interfaces.RealInput Tau_in(unit="s") "Delay time input"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,100})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,38})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Qloss)
    annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));
equation
  dp = 0;

  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = Medium.specificEnthalpy_pTX(
    port_a.p,
    Tout_b,
    inStream(port_a.Xi_outflow)) "Calculate enthalpy of output state";

  Tin_a = Medium.temperature_phX(
    port_a.p,
    inStream(port_a.h_outflow),
    inStream(port_a.Xi_outflow));

  Tout_b = T_amb + ((Tin_a + T_2in)/2 - T_amb)*Modelica.Math.exp(-Tau_in/
    tau_charSymm) + (Tin_a - T_2in)/2*Modelica.Math.exp(-Tau_in/tau_charAsymm);
  T_2out = Tin_a;

  Qloss = Annex60.Utilities.Math.Functions.spliceFunction(
    pos=(Tin_a - Tout_b)*cp_default,
    neg=0,
    x=port_a.m_flow,
    deltax=m_flow_nominal/1000)*port_a.m_flow;

  connect(heatPort, prescribedHeatFlow.port)
    annotation (Line(points={{0,100},{0,100},{0,48}}, color={191,0,0}));
  connect(realExpression.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-11,0},{0,0},{0,28}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-80,80},{80,-68}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,2},{44,2},{44,8},{68,0},{44,-8},{44,-2},{-50,-2},{-50,2}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Solid,
          fillColor={170,213,255}),
        Polygon(
          points={{0,60},{38,2},{20,2},{20,-46},{-18,-46},{-18,2},{-36,2},{0,60}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,80},{-38,38}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{24,22},{-24,-22}},
          lineColor={28,108,200},
          startAngle=30,
          endAngle=90,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={-40,80},
          rotation=180)}),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Heat losses are only considered in design direction. For heat loss consideration in both directions use one of these models at both ends of a <code></span><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow</code></span><span style=\"font-family: MS Shell Dlg 2;\"> model.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This component requires the delay time and the instantaneous ambient temperature as an input. This component is to be used in double pipes and models influence from other pipes for flow in both directions. </span></p>
</html>", revisions="<html>
<ul>
<li>December 1, 2015 by Bram van der Heijde:<br>First implementation as double pipe version with delay as input.</li>
<li>September, 2015 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end HeatLossDoubleParallel;
