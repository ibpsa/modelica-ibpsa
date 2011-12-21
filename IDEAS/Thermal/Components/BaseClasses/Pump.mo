within IDEAS.Thermal.Components.BaseClasses;
model Pump "Enforces constant mass flow rate"

  extends Thermal.Components.Interfaces.Partials.TwoPort;
  parameter Boolean useInput = false "Enable / disable MassFlowRate input"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate m_flowNom(min=0, start=1)
    "Nominal mass flowrate"
    annotation(Dialog(enable=not useVolumeFlowInput));
  parameter Modelica.SIunits.Pressure dpFix=50000
    "Fixed pressure drop, used for determining the electricity consumption";
  parameter Real etaTot = 0.8 "Fixed total pump efficiency";
  Modelica.SIunits.Power PEl "Electricity consumption";
  Modelica.Blocks.Interfaces.RealInput m_flowSet(start = 0, min = 0, max = 1) = m_flow/m_flowNom if useInput
    annotation (Placement(transformation(
        origin={0,100},
        extent={{-10,-10},{10,10}},
        rotation=270)));
protected
  Modelica.SIunits.MassFlowRate m_flow;

equation
  if not useInput then
    m_flow = m_flowNom;
  end if;

  Q_flow = 0;
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
        Ellipse(
          extent={{-90,90},{90,-90}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-90},{150,-150}},
          lineColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{-60,68},{90,10},{90,-10},{-60,-68},{-60,68}},
          lineColor={255,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-40,20},{0,-20}},
          lineColor={0,0,0},
          textString="V")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),
                    graphics));
end Pump;
