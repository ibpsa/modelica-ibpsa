within Annex60.Experimental.Pipe.BaseClasses;
model TempDelaySD "Temperature delay using spatialDistribution operator"
  extends Annex60.Fluid.Interfaces.PartialTwoPortTransport;

  parameter Real initialPoints[:](each min=0, each max=1) = {0.0, 1.0}
    "Initial points for spatialDistribution";
    // fixme: use T_start[:] and propagate to top level, then use it to assign h_start (or initialValuesH)
  parameter Modelica.SIunits.SpecificEnthalpy initialValuesH[:]=
     {Medium.h_default, Medium.h_default}
    "Inital enthalpy values for spatialDistribution";

  parameter Modelica.SIunits.Diameter D "Pipe diameter"; // fixme call it diameter
  parameter Modelica.SIunits.Length L "Pipe length";   // fixme: call it lenghth
  final parameter Modelica.SIunits.Area A = Modelica.Constants.pi * (D/2)^2
    "Cross-sectional area of pipe";
  Modelica.SIunits.Length x(start=0)
    "Spatial coordiante for spatialDistribution operator";
  Modelica.SIunits.Velocity v "Flow velocity of medium in pipe";

protected
  parameter Modelica.SIunits.SpecificEnthalpy h_default=Medium.specificEnthalpy(sta_default)
    "Specific enthalpy";
  parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
equation
  dp = 0;

  der(x) = v;
  v = V_flow / A;

  // fixme: this also need to be applied on Xi_outflow and C_outflow.
  // Otherwise, for air, it can give wrong temperatures at the outlet.
  // To assign Xi_outflow and C_outflow, you will need to use Annex60.Fluid.Interfaces.PartialTwoPort
  (port_a.h_outflow,
   port_b.h_outflow) = spatialDistribution(inStream(port_a.h_outflow),
                                           inStream(port_b.h_outflow),
                                           x/L,
                                           v>=0,
                                           initialPoints,
                                           initialValuesH);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-72,-28}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=0.5,
          smooth=Smooth.None),
        Rectangle(
          extent={{-80,80},{80,-60}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-40},{-60,-40},{-60,20},{80,20}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-80,-40},{4,-40},{8,-38},{16,16},{20,20},{80,20}},
          color={255,0,0},
          pattern=LinePattern.Dot,
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-80,60},{-80,-60},{80,-60}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5,
          arrow={Arrow.Filled,Arrow.Filled})}),
    Documentation(revisions="<html>
<ul>
<li>
June 23, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>A simple model to account for the effect of the temperature delay for a fluid flow throurgh a pipe. It uses the spatialDistribution operator to delay changes in input enthalpy depending on the flow velocity.</p>
</html>"));
end TempDelaySD;
