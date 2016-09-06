within Annex60.Experimental.Pipe.BaseClasses;
model HeatLossPipeDelay
  "Heat loss model for pipe with delay as an input variable"
  extends Fluid.Interfaces.PartialTwoPortTransport;

  parameter Modelica.SIunits.Diameter diameter "Pipe diameter";
  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.Length thicknessIns "Thickness of pipe insulation";

  parameter Modelica.SIunits.Area A_surf=2*Modelica.Constants.pi*(diameter/2 +
      thicknessIns)*length "Outer surface area of the pipe";

  parameter Modelica.SIunits.Area A_cross=Modelica.Constants.pi*diameter*
      diameter/4 "Cross sectional area";

  parameter Types.ThermalCapacityPerLength C;
  parameter Types.ThermalResistanceLength R;
  final parameter Modelica.SIunits.Time tau_char=R*C;

  Modelica.SIunits.Temp_K Tin_a "Temperature at port_a for in-flowing fluid";
  Modelica.SIunits.Temp_K Tout_b "Temperature at port_b for out-flowing fluid";
  Modelica.SIunits.Temperature T_amb=heatPort.T "Environment temperature";
  Modelica.SIunits.HeatFlowRate Qloss "Heat losses from pipe to environment";
  Modelica.SIunits.EnthalpyFlowRate portA=inStream(port_a.h_outflow);
  Modelica.SIunits.EnthalpyFlowRate portB=inStream(port_b.h_outflow);

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";

public
  Modelica.Blocks.Interfaces.RealInput tau(unit="s") "Time delay at pipe level"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,100})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port to connect environment"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatLoss annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,38})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Qloss)
    annotation (Placement(transformation(extent={{-34,-10},{-14,10}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5;
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

  // Heat losses
  Tout_b = T_amb + (Tin_a - T_amb)*Modelica.Math.exp(-tau/tau_char);
  Qloss = Annex60.Utilities.Math.Functions.spliceFunction(
    pos= (Tin_a-Tout_b)*cp_default,
    neg= 0,
    x= port_a.m_flow,
    deltax= m_flow_nominal/1000)  *port_a.m_flow;

  connect(heatLoss.port, heatPort)
    annotation (Line(points={{0,48},{0,100}}, color={191,0,0}));
  connect(realExpression.y, heatLoss.Q_flow)
    annotation (Line(points={{-13,0},{-6,0},{0,0},{0,28}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-80,80},{80,-68}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,2},{42,2},{42,8},{66,0},{42,-8},{42,-2},{-52,-2},{-52,2}},
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
<p>Heat losses are only considered in design direction. For heat loss consideration in both directions use one of these models at both ends of a <code><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow</span></code> model.</p>
<p>This component requires the delay time and the instantaneous ambient temperature as an input. This component is to be used in single pipes or in more advanced configurations where no influence from other pipes is considered. </p>
</html>", revisions="<html>
<ul>
<li>November 6, 2015 by Bram van der Heijde:<br>Make time delay input instead of calculation inside this model. </li>
<li>September, 2015 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end HeatLossPipeDelay;
