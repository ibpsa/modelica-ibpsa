within Annex60.Experimental.Pipe.Archive;
model HeatLoss "Heat loss model for pipe"
  extends Fluid.Interfaces.PartialTwoPortTransport;

  parameter Modelica.SIunits.Diameter diameter "Pipe diameter";
  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.Length thicknessIns "Thickness of pipe insulation";

  parameter Modelica.SIunits.Area A_surf = 2 * Modelica.Constants.pi *
                                           (diameter/2 + thicknessIns) *
                                           length
    "Outer surface area of the pipe";

  parameter Real thermTransmissionCoeff(unit="W/(m2/K)")
    "Thermal transmission coefficient between pipe medium and surrounding";

  Real theta(min=0) "Dimensionless temperature";

  Real a "Argument for theta exponential: kM/(m'c)";

  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Tin_a
    "Temperature at port_a for in-flowing fluid";
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Tout_b
    "Temperature at port_b for out-flowing fluid";

  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Tenv = 5
    "Temperature of pipe's environment";

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(state=sta_default) "Heat capacity of medium";

protected
  parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(
       T=Medium.T_default,
       p=Medium.p_default,
       X=Medium.X_default) "Default medium state";
  /*parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(state=sta_default) "Heat capacity of medium";*/

equation
  dp = 0;

  a = Annex60.Utilities.Math.Functions.inverseXRegularized(
                                          (m_flow * cp_default)/
                                          (thermTransmissionCoeff * A_surf), 1e-5);
  theta = Annex60.Utilities.Math.Functions.smoothExponential(a, 1e-5);

  Tin_a * cp_default = inStream(port_a.h_outflow);

  Tout_b - Tenv = theta * (Tin_a - Tenv);

  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = Tout_b * cp_default;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-80,80},{80,-68}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Polygon(
          points={{0,60},{38,2},{20,2},{20,-46},{-18,-46},{-18,2},{-36,2},{0,60}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>Heat losses are only considered in design direction. For heat loss consideration in both directions use one of these models at both ends of a <code><span style=\"font-family: Courier New,courier;\">TempDelaySD</span></code> model.</p>
<p>This is a simple reference model for more sophisticated implementations and does not work correctly with zero-mass flow.</p>
</html>", revisions="<html>
<ul>
<li>
September, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatLoss;
