within IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety;
model MinimalFlowRate "Safety control for minimum mass flow rate"
  extends BaseClasses.PartialSafetyWithCounter;

  parameter Modelica.Units.SI.MassFlowRate mEvaMin_flow
    "Minimal mass flow rate in evaporator required to operate the device";
  parameter Modelica.Units.SI.MassFlowRate mConMin_flow
    "Minimal mass flow rate in condenser required to operate the device";
  Modelica.Blocks.Logical.Hysteresis hysCon(
    final uLow=mConMin_flow,
    final uHigh=max(mConMin_flow*1.1, Modelica.Constants.eps),
    final pre_y_start=false)
    "Check if condenser mass flow rate is high enough"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Logical.Hysteresis hysEva(
    final uLow=mEvaMin_flow,
    final uHigh=max(mEvaMin_flow*1.1, Modelica.Constants.eps),
    final pre_y_start=false)
    "Check if evaporator mass flow rate is high enough"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Logical.And and1
    "Both condenser and evaporator have sufficient flow"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
equation
  connect(hysCon.y, and1.u1) annotation (Line(points={{-39,20},{-28,20},{-28,0},
          {-22,0}},      color={255,0,255}));
  connect(hysEva.y, and1.u2) annotation (Line(points={{-39,-20},{-30,-20},{-30,-8},
          {-22,-8}},     color={255,0,255}));
  connect(and1.y, booPasThr.u) annotation (Line(points={{1,0},{78,0}},
             color={255,0,255}));
  connect(hysEva.u, sigBus.mEvaMea_flow) annotation (Line(points={{-62,-20},{
          -84,-20},{-84,-61},{-119,-61}},
                                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hysCon.u, sigBus.mConMea_flow) annotation (Line(points={{-62,20},{-84,
          20},{-84,-62},{-119,-62},{-119,-61}},
                                     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html>
<p>
  Safety control to prevent the device from turning on
  if the mass flow rate is too low in either
  condenser or evaporator.
</p>
<p>
  Used in real devices to prevent overheating
  or freezing of components.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>May 27, 2025</i> by Fabian Wuellhorst:<br/>
    Make safety checks parallel (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/2015\">IBPSA #2015</a>)
  </li>
  <li>
    <i>May 26, 2025</i> by Fabian Wuellhorst and Michael Wetter:<br/>
    Increase error counter only when device should turn on (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/2011\">IBPSA #2011</a>)
  </li>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>
"));
end MinimalFlowRate;
