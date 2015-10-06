within Annex60.Experimental.Pipe;
model PipeLosslessPlugFlow
  "Lossless pipe model with spatialDistribution plug flow implementation"
  extends Annex60.Fluid.Interfaces.PartialTwoPort;

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

  // Advanced
  // Note: value of dp_start shall be refined by derived model,
  // based on local dp_nominal
  parameter Medium.AbsolutePressure dp_start = 0
    "Guess value of dp = port_a.p - port_b.p"
    annotation(Dialog(tab = "Advanced", enable=from_dp));
  parameter Medium.MassFlowRate m_flow_start = 0
    "Guess value of m_flow = port_a.m_flow"
    annotation(Dialog(tab = "Advanced", enable=not from_dp));
  // Note: value of m_flow_small shall be refined by derived model,
  // based on local m_flow_nominal
  parameter Medium.MassFlowRate m_flow_small
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  // Diagnostics
  parameter Boolean show_T = true
    "= true, if temperatures at port_a and port_b are computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  parameter Boolean show_V_flow = true
    "= true, if volume flow rate at inflowing port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Modelica.SIunits.Length x(start=0)
    "Spatial coordiante for spatialDistribution operator";
  Modelica.SIunits.Velocity v "Flow velocity of medium in pipe";

  // Variables
  Medium.MassFlowRate m_flow(
     min=if allowFlowReversal then -Modelica.Constants.inf else 0,
     start = m_flow_start) "Mass flow rate in design flow direction";
  Modelica.SIunits.Pressure dp(start=dp_start)
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";

  Modelica.SIunits.VolumeFlowRate V_flow=
      m_flow/Modelica.Fluid.Utilities.regStep(m_flow,
                  Medium.density(
                    Medium.setState_phX(
                      p=  port_a.p,
                      h=  inStream(port_a.h_outflow),
                      X=  inStream(port_a.Xi_outflow))),
                  Medium.density(
                       Medium.setState_phX(
                         p=  port_b.p,
                         h=  inStream(port_b.h_outflow),
                         X=  inStream(port_b.Xi_outflow))),
                  m_flow_small) if show_V_flow
    "Volume flow rate at inflowing port (positive when flow from port_a to port_b)";

  Medium.Temperature port_a_T=
      Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                  Medium.temperature(
                    Medium.setState_phX(
                      p=  port_a.p,
                      h=  inStream(port_a.h_outflow),
                      X=  inStream(port_a.Xi_outflow))),
                  Medium.temperature(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow)),
                  m_flow_small) if show_T
    "Temperature close to port_a, if show_T = true";
  Medium.Temperature port_b_T=
      Modelica.Fluid.Utilities.regStep(port_b.m_flow,
                  Medium.temperature(
                    Medium.setState_phX(
                      p=  port_b.p,
                      h=  inStream(port_b.h_outflow),
                      X=  inStream(port_b.Xi_outflow))),
                  Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow)),
                  m_flow_small) if show_T
    "Temperature close to port_b, if show_T = true";

protected
  parameter Modelica.SIunits.SpecificEnthalpy h_default=Medium.specificEnthalpy(sta_default)
    "Specific enthalpy";
  parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
equation
  // Pressure drop in design flow direction
  dp = port_a.p - port_b.p;
  dp = 0;

  // Design direction of mass flow rate
  m_flow = port_a.m_flow;
  assert(m_flow > -m_flow_small or allowFlowReversal,
      "Reverting flow occurs even though allowFlowReversal is false");

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

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

  // Transport of substances
  port_a.Xi_outflow = if allowFlowReversal then inStream(port_b.Xi_outflow) else Medium.X_default[1:Medium.nXi];
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = if allowFlowReversal then inStream(port_b.C_outflow) else zeros(Medium.nC);
  port_b.C_outflow = inStream(port_a.C_outflow);

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
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,256}),
        Rectangle(
          extent={{-20,50},{20,-48}},
          lineColor={175,175,175},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={175,175,175})}),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2015 by Marcus Fuchs:<br/>
Copy Icon from KUL implementation and rename model.
</li>
<li>
June 23, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>A simple model to account for the effect of the temperature delay for a fluid flow throurgh a pipe. It uses the spatialDistribution operator to delay changes in input enthalpy depending on the flow velocity.</p>
</html>"));
end PipeLosslessPlugFlow;
