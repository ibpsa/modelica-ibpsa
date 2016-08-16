within Annex60.Experimental.Pipe.BaseClasses;
model HeatLossPipeDelay
  "Heat loss model for pipe with delay as an input variable"
  extends Fluid.Interfaces.PartialTwoPortTransport;

  parameter Modelica.SIunits.Diameter diameter "Pipe diameter";
  parameter Modelica.SIunits.Length length "Pipe length";

  parameter Modelica.SIunits.Area A_cross=Modelica.Constants.pi*diameter*
      diameter/4 "Cross sectional area";

  parameter Types.ThermalCapacityPerLength C;
  parameter Types.ThermalResistanceLength R;
  final parameter Modelica.SIunits.Time tau_char=R*C;

  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Tin_a
    "Temperature at port_a for in-flowing fluid";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Tout_b
    "Temperature at port_b for out-flowing fluid";

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";

public
  Modelica.Blocks.Interfaces.RealInput T_amb(unit="K", displayUnit="degC")
    "Ambient temperature of pipe's surroundings" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
public
  Modelica.Blocks.Interfaces.RealInput tau(unit="s") "Time delay at pipe level"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,100})));
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

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-80,80},{80,-68}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,2},{42,2},{42,8},{66,0},{42,-8},{42,-2},{-52,-2},{-52,2}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Solid,
          fillColor={170,213,255}),
        Ellipse(
          extent={{-82,80},{-40,38}},
          lineColor={28,108,200},
          startAngle=30,
          endAngle=90,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-82,80},{-40,38}}, lineColor={28,108,200}),
                                          Polygon(
          points={{0,60},{38,2},{20,2},{20,-46},{-18,-46},{-18,2},{-36,2},{0,60}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>Heat losses are only considered in design direction. For heat loss consideration in both directions use one of these models at both ends of a <code><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow</span></code> model.</p>
<p>This component requires the delay time and the instantaneous ambient temperature as an input. This component is to be used in single pipes or in more advanced configurations where no influence from other pipes is considered. </p>
</html>", revisions="<html>
<ul>
<li>November 6, 2015 by Bram van der Heijde:<br>Make time delay input instead of calculation inside this model. </li>
<li>September, 2015 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end HeatLossPipeDelay;
