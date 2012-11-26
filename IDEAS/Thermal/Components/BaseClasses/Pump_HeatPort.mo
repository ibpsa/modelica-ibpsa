within IDEAS.Thermal.Components.BaseClasses;
model Pump_HeatPort
  "Enforces constant mass flow rate, with heat port for environmental heat losses"

  extends Thermal.Components.Interfaces.Partials.TwoPort;
  parameter Boolean useInput = false "Enable / disable MassFlowRate input"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate m_flowNom(min=0, start=1)
    "Nominal mass flowrate"
    annotation(Dialog(enable=not useVolumeFlowInput));
  parameter Modelica.SIunits.Pressure dpFix=50000
    "Fixed pressure drop, used for determining the electricity consumption";
  parameter Real etaTot = 0.8 "Fixed total pump efficiency";
  Modelica.Blocks.Interfaces.RealInput m_flowSet(start = 0, min = 0, max = 1) = m_flow/m_flowNom if useInput
    annotation (Placement(transformation(
        origin={0,100},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat exchange with environment"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}},
          rotation=0)));

protected
  Modelica.SIunits.MassFlowRate m_flow;

public
  Modelica.Blocks.Interfaces.RealOutput PEl "Electricity consumption" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-106})));
equation
  // energy exchange with medium
  Q_flow = heatPort.Q_flow;
  // defines heatPort's temperature
  heatPort.T = T;

  if not useInput then
    m_flow = m_flowNom;
  end if;

  flowPort_a.m_flow = m_flow;
  PEl = m_flow / medium.rho * dpFix / etaTot;
  annotation (Documentation(info="<HTML>
Fan resp. pump with constant volume flow rate. Pressure increase is the response of the whole system.
Coolant's temperature and enthalpy flow are not affected.<br>
Setting parameter m (mass of medium within fan/pump) to zero
leads to neglection of temperature transient cv*m*der(T).<br>
Thermodynamic equations are defined by Partials.TwoPort.
</HTML>"),
       Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-150,-94},{150,-154}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-40,20},{0,-20}},
          lineColor={0,0,0},
          textString="V"),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-40,20},{0,-20}},
          lineColor={0,0,0},
          textString="V"),
        Line(
          points={{-100,0},{-60,0}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{100,0},{60,0}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{0,0},{0,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-40,80},{40,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Polygon(
          points={{-38,46},{60,0},{60,0},{-38,-46},{-38,46}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics));
end Pump_HeatPort;
