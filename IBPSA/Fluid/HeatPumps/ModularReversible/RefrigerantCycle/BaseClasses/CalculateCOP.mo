within IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
model CalculateCOP
  "Calculate the COP or EER of a device"

  parameter Modelica.Units.SI.Power PEleMin(min=Modelica.Constants.eps)
    "If eletrical power consumption falls below this value, COP will not be calculated";

  Modelica.Blocks.Interfaces.RealInput PEle(final unit="W", final displayUnit="kW")
    "Electrical power consumed by the system" annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(extent=
           {{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput QUse_flow(final unit="W", final
      displayUnit="kW") "Useful heat flow" annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},{-100,
            60}})));
  Modelica.Blocks.Interfaces.RealOutput COP "Output for calculated COP value"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Logical.Hysteresis hys(uLow=PEleMin, uHigh=PEleMin*1.1)
    "Hysteresis to switch between calculation and no calculation"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
initial equation
  assert(PEleMin > 0,
    "PEleMin must be greater than zero. Disable efficiency calculation using 
    calEff=false to debug why PEle_nominal is lower than zero.",
    AssertionLevel.error);

equation
  if hys.y then
    COP = QUse_flow/PEle;
  else
    COP = 0;
  end if;

  connect(hys.u, PEle)
    annotation (Line(points={{-62,-40},{-120,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This model is used to calculate the COP or the EER of a device. As
  the electrical power can get zero, a lower boundary is used to
  avoid division by zero.
</p>
</html>"));
end CalculateCOP;
