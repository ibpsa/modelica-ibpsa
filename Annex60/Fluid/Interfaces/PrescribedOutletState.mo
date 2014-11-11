within Annex60.Fluid.Interfaces;
model PrescribedOutletState
  "Component that assigns the outlet fluid property at port_a based on an input signal"
  extends Annex60.Fluid.Interfaces.PartialTwoPortTransport;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxHeat
    "Maximum heat flow rate for heating (positive)";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_maxCool
    "Maximum heat flow rate for cooling (negative)";
  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Set point temperature of the fluid that leaves port_b"
    annotation (Placement(transformation(origin={-120,80},
              extent={{20,-20},{-20,20}},rotation=180)));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(
        Medium.setState_pTX(
          p=Medium.p_default,
          T=Medium.T_default,
          X=Medium.X_default)) "Specific heat capacity at default medium state";

  parameter Boolean restrictHeat = Q_flow_maxHeat <> Modelica.Constants.inf
    "Flag, true if maximum heating power is restricted";
  parameter Boolean restrictCool = Q_flow_maxCool <> -Modelica.Constants.inf
    "Flag, true if maximum cooling power is restricted";

  parameter Modelica.SIunits.SpecificEnthalpy deltah=
    cp_default*m_flow_small*0.01
    "Small value for deltah used for regularization";

  Modelica.SIunits.MassFlowRate m_flow_limited
    "Mass flow rate bounded away from zero";

  Modelica.SIunits.SpecificEnthalpy hSet
    "Set point for enthalpy leaving port_b";

  Modelica.SIunits.SpecificEnthalpy dhSetAct
    "Actual enthalpy difference from port_a to port_b";

equation
  // Set point for outlet enthalpy without any limitation
  hSet = Medium.specificEnthalpy(
    Medium.setState_pTX(
      p=  port_a.p,
      T=  TSet,
      X=  inStream(port_a.Xi_outflow)));

  // Compute how much dH may need to be reduced.
  if not restrictHeat and not restrictCool then
    // No capacity limit
    dhSetAct = 0;
    port_b.h_outflow = hSet;
    m_flow_limited = 0;
  else

    m_flow_limited = Annex60.Utilities.Math.Functions.smoothMax(
      x1=  port_a.m_flow,
      x2=  m_flow_small,
      deltaX=m_flow_small/2);

    if restrictHeat and restrictCool then
      // Capacity limits for heating and cooling
      dhSetAct = Annex60.Utilities.Math.Functions.smoothLimit(
        x=hSet-inStream(port_a.h_outflow),
        l=Q_flow_maxCool / m_flow_limited,
        u=Q_flow_maxHeat / m_flow_limited,
        deltaX=deltah);
    elseif restrictHeat then
      // Capacity limit for heating only
      dhSetAct = Annex60.Utilities.Math.Functions.smoothMin(
        x1=hSet-inStream(port_a.h_outflow),
        x2=Q_flow_maxHeat / m_flow_limited,
        deltaX=deltah);
    else
      // Capacity limit for cooling only
      dhSetAct = Annex60.Utilities.Math.Functions.smoothMax(
        x1=hSet-inStream(port_a.h_outflow),
        x2=Q_flow_maxCool / m_flow_limited,
        deltaX=deltah);
    end if;

    port_b.h_outflow = inStream(port_a.h_outflow) + dhSetAct;

  end if;

  // Outflowing property at port_a is unaffected by this model.
  port_a.h_outflow = inStream(port_b.h_outflow);

  // No pressure drop
  dp = 0;

    annotation (
  defaultComponentName="heaCoo",
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                      graphics={
      Text(
        extent={{-154,138},{146,98}},
        textString="%name",
        lineColor={0,0,255}),
        Rectangle(
          extent={{-68,70},{74,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,6},{102,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,-4},{102,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,92},{-78,70}},
          lineColor={0,0,127},
          textString="T")}),
  Documentation(info="<HTML>
<p>
This model sets the temperature of the medium that leaves <code>port_a</code>
to the value given by the input <code>TSet</code>, subject to optional
limitations on the heating and cooling capacity.
</p>
<p>
In case of reverse flow, the set point temperature is still applied to
the fluid that leaves <code>port_b</code>.
</p>
<p>
This model has no pressure drop.
See <a href=\"modelica://Annex60.Fluid.HeatExchangers.HeaterCooler_T\">
Annex60.Fluid.HeatExchangers.HeaterCooler_T</a>
for a model that instantiates this model and that has pressure drop.
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
          {100,100}}), graphics));
end PrescribedOutletState;
