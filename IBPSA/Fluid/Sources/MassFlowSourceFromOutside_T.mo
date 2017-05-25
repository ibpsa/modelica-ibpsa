within IBPSA.Fluid.Sources;
model MassFlowSourceFromOutside_T
  "Ideal flow source that produces a prescribed mass flow with prescribed trace substances, outside temperature and mass fraction "
  extends Modelica.Fluid.Sources.BaseClasses.PartialSource;
  parameter Boolean use_m_flow_in = false
    "Get the mass flow rate from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Boolean use_C_in = false
    "Get the trace substances from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Modelica.SIunits.MassFlowRate m_flow = 0
    "Fixed mass flow rate going out of the fluid port"
    annotation (Dialog(enable = not use_m_flow_in));
  parameter Medium.ExtraProperty C[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Fixed values of trace substances"
    annotation (Dialog(enable = (not use_C_in) and Medium.nC > 0));
  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s") if use_m_flow_in
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-120,60},{-80,100}}), iconTransformation(extent={{-120,60},{-80,100}})));
  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC](
    final quantity=Medium.extraPropertiesNames) if use_C_in
    "Prescribed boundary trace substances"
    annotation (Placement(transformation(extent={{-120,-100},{-80,-60}})));
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-120,-18},{-80,22}})));

protected
  final parameter Boolean singleSubstance = (Medium.nX == 1)
    "True if single substance medium";
  IBPSA.Utilities.Psychrometrics.X_pTphi x_pTphi if (not singleSubstance)
     "Block to compute water vapor concentration";
  Modelica.Blocks.Interfaces.RealOutput m_flow_in_internal(final unit="kg/s")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealOutput T_in_internal(final unit="K",
                                                     displayUnit="degC")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealOutput X_in_internal[Medium.nX](
    each final unit = "kg/kg",
    final quantity=Medium.substanceNames)
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealOutput C_in_internal[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Needed to connect to conditional connector";

equation
  Modelica.Fluid.Utilities.checkBoundary(
    Medium.mediumName,
    Medium.substanceNames,
    Medium.singleState,
    true,
    medium.X,
    "MassFlowSourceFromOutside_T");

  // Connections to compute species concentration
  connect(weaBus.pAtm, x_pTphi.p_in);
  connect(weaBus.TDryBul, x_pTphi.T);
  connect(weaBus.relHum, x_pTphi.phi);

  connect(m_flow_in, m_flow_in_internal);
  connect(weaBus.TDryBul, T_in_internal);
  connect(X_in_internal, x_pTphi.X);
  connect(C_in, C_in_internal);

  if singleSubstance then
    X_in_internal = ones(Medium.nX);
  end if;
  if not use_m_flow_in then
    m_flow_in_internal = m_flow;
  end if;
  if not use_C_in then
    C_in_internal = C;
  end if;

  sum(ports.m_flow) = -m_flow_in_internal;
  medium.T = T_in_internal;
  medium.Xi = X_in_internal[1:Medium.nXi];
  ports.C_outflow = fill(C_in_internal, nPorts);
  annotation (defaultComponentName="boundary",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{35,45},{100,-45}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Ellipse(
          extent={{-100,80},{60,-80}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,70},{60,0},{-60,-68},{-60,70}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,32},{16,-30}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Text(
          extent={{-150,130},{150,170}},
          textString="%name",
          lineColor={0,0,255}),
        Ellipse(
          extent={{-26,30},{-18,22}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          visible=use_m_flow_in,
          extent={{-185,132},{-45,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m_flow"),
        Text(
          visible=use_C_in,
          extent={{-155,-98},{-35,-126}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C")}),
    Documentation(info="<html>
<p>
Models an ideal flow source, with prescribed values of flow rate and trace substances, with temperature and composition from outside:
</p>
<ul>
<li> Prescribed mass flow rate.</li>
<li> Boundary composition (trace-substance flow).</li>
<li> Outside temperature.</li>
<li> Multi-substance composition (e.g. water vapor) from outside.</li>
</ul>
<p>If <code>use_m_flow_in</code> is false (default option), the <code>m_flow</code> parameter
is used as boundary flow rate, and the <code>m_flow_in</code> input connector is disabled; 
if <code>use_m_flow_in</code> is true, then the <code>m_flow</code> parameter is ignored, and the value provided by the input connector is used instead.</p>
<p>The <a href=\"modelica://IBPSA.Utilities.Psychrometrics.X_pTphi\">IBPSA.Utilities.Psychrometrics.X_pTphi</a> block is used with the input data 
including <code>pAtm</code>, <code>TDryBul</code>, <code>relHum</code> from weather bus <code>weaBus</code>, to calculate <code>X</code>.</p>

<p>
Note, that boundary temperature,
mass fractions and trace substances have only an effect if the mass flow
is from the boundary into the port. If mass is flowing from
the port into the boundary, the boundary definitions,
with exception of boundary flow rate, do not have an effect.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 21, 2017, by Jianjun Hu:<br/>
Changed the speficication of temperature and composition inputs with outside condition. Weather bus is used.
</li>
<li>
April 18, 2017, by Filip Jorissen:<br/>
Changed <code>checkBoundary</code> implementation
such that it is run as an initial equation
when it depends on parameters only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/728\">#728</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Added <code>unit</code> and <code>quantity</code> attributes.
</li>
<li>
September 29, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassFlowSourceFromOutside_T;
