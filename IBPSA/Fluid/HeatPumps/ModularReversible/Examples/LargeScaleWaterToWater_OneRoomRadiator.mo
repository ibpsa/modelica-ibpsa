within IBPSA.Fluid.HeatPumps.ModularReversible.Examples;
model LargeScaleWaterToWater_OneRoomRadiator
  "Large scale water to water heat pump connected to a simple room model with radiator"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialOneRoomRadiator(
    mEva_flow_nominal=heaPum.mEva_flow_nominal,
    mCon_flow_nominal=heaPum.mCon_flow_nominal,
    V=6*100*3,
    witCoo=false,
    mAirRoo_flow_nominal=V*1.2*6/3600*10,
    Q_flow_nominal=200000,
    sin(nPorts=1),
    booToReaPumEva(realTrue=heaPum.mEva_flow_nominal),
    oneRooRadHeaPumCtr(PIDHea(Ti=10)),
    pumHeaPum(
      redeclare IBPSA.Fluid.Movers.Data.Pumps.Wilo.VeroLine80slash115dash2comma2slash2 per),
    pumHeaPumSou(
      redeclare IBPSA.Fluid.Movers.Data.Pumps.Wilo.VeroLine80slash115dash2comma2slash2 per));

  IBPSA.Fluid.HeatPumps.ModularReversible.LargeScaleWaterToWater heaPum(
    QUse_flow_nominal=Q_flow_nominal,
    y_nominal=1,
    use_intSafCtr=true,
    TCon_nominal=TRadSup_nominal,
    dpCon_nominal(displayUnit="Pa"),
    TEva_nominal=sou.T,
    dpEva_nominal(displayUnit="Pa"),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
      safCtrParEurNor,
    redeclare
      IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.WAMAK_WaterToWater_220kW
      datTab)
    "Large scale water to water heat pump"
    annotation (Placement(transformation(extent={{20,-160},{0,-136}})));
equation
  connect(heaPum.port_b2, sin.ports[1]) annotation (Line(points={
          {20,-154},{38,-154},{38,-200},{60,-200}}, color={0,127,255}));
  connect(heaPum.port_a2, pumHeaPumSou.port_b) annotation (Line(
        points={{0,-154},{-30,-154},{-30,-170}}, color={0,127,255}));
  connect(heaPum.port_b1, pumHeaPum.port_a) annotation (Line(
        points={{0,-142},{-70,-142},{-70,-120}}, color={0,127,255}));
  connect(heaPum.port_a1, temRet.port_b) annotation (Line(points=
          {{20,-142},{60,-142},{60,-30}}, color={0,127,255}));
  connect(oneRooRadHeaPumCtr.ySet, heaPum.ySet) annotation (Line(
        points={{-139,-66},{-62,-66},{-62,-76},{21.6,-76},{21.6,-146}}, color={
          0,0,127}));
  annotation (
     __Dymola_Commands(file=
     "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/LargeScaleWaterToWater_OneRoomRadiator.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-08),
  Documentation(
   info="<html>
<p>
  This example demonstrates how to use the
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.LargeScaleWaterToWater\">
  IBPSA.Fluid.HeatPumps.ModularReversible.LargeScaleWaterToWater</a>
  heat pump model. Please check the associated documentation for
  further information.
</p>
<p>
  Contrary to the other models, parameters for heat exchanger
  inertia (tau) and mass flow rates are calculated
  automatically based on the heat demand.
</p>
<p>
  Furthermore, this example demonstrates the warnings which
  are raised if the table data boundary conditions
  (e.g. <code>mEva_flow_nominal</code>) deviates from
  the parameter in use.
</p>
<p>
  To fix this issue, the user has to either
</p>
<ol>
<li>
Check the assumption of using a different mass flow rate, or
</li>
<li>
adjust the mass flow rates in the hydraulic system.
If the deviation is too big, the system would also not
work in reality.
</li>
</ol>
<p>
  Please check the documentation of
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator\">
  IBPSA.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator</a>
  for further information on the example.
</p>
</html>", revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-240,-220},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end LargeScaleWaterToWater_OneRoomRadiator;
