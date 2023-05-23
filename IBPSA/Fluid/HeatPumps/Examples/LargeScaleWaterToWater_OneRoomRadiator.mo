within IBPSA.Fluid.HeatPumps.Examples;
model LargeScaleWaterToWater_OneRoomRadiator
  "Large scale water to water heat pump connected to a simple room model with radiator"
  extends BaseClasses.PartialOneRoomRadiator(
    witCoo=false,
    mAirRoo_flow_nominal=V*1.2*6/3600*10,
    Q_flow_nominal=200000,
    sin(nPorts=1),
    booToReaPumEva(realTrue=larScaWatToWatHeaPum.mEva_flow_nominal));
  IBPSA.Fluid.HeatPumps.LargeScaleWaterToWater larScaWatToWatHeaPum(
    redeclare package MediumCon = MediumW,
    redeclare package MediumEva = MediumW,
    QUse_flow_nominal=Q_flow_nominal,
    y_nominal=1,
    use_intSafCtr=true,
    TCon_nominal=TRadSup_nominal,
    dTCon_nominal=TRadSup_nominal - TRadRet_nominal,
    dpCon_nominal(displayUnit="Pa") = 2000,
    use_conCap=false,
    CCon=0,
    GConOut=0,
    GConIns=0,
    TEva_nominal=sou.T,
    dTEva_nominal=5,
    dpEva_nominal(displayUnit="Pa") = 2000,
    use_evaCap=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare
      IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.DefaultHeatPumpSafetyControl
      safCtrPar(use_antFre=true, TAntFre=275.15),
    datTab=
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN14511.WAMAK_WaterToWater_150kW())
    "Large scale water to water heat pump"
    annotation (Placement(transformation(extent={{20,-160},{0,-136}})));
equation
  connect(larScaWatToWatHeaPum.port_b2, sin.ports[1]) annotation (Line(points={
          {20,-154},{38,-154},{38,-200},{60,-200}}, color={0,127,255}));
  connect(larScaWatToWatHeaPum.port_a2, pumHeaPumSou.port_b) annotation (Line(
        points={{0,-154},{-30,-154},{-30,-170}}, color={0,127,255}));
  connect(larScaWatToWatHeaPum.port_b1, pumHeaPum.port_a) annotation (Line(
        points={{0,-142},{-70,-142},{-70,-120}}, color={0,127,255}));
  connect(larScaWatToWatHeaPum.port_a1, temRet.port_b) annotation (Line(points=
          {{20,-142},{60,-142},{60,-30}}, color={0,127,255}));
  connect(oneRooRadHeaPumCtrl.ySet, larScaWatToWatHeaPum.ySet) annotation (Line(
        points={{-139,-66},{-62,-66},{-62,-76},{21.6,-76},{21.6,-146}}, color={
          0,0,127}));
  annotation (Documentation(info="<html>
<p>This example demonstrates the usage of the model <a href=\"IBPSA.Fluid.HeatPumps.LargeScaleWaterToWater\">IBPSA.Fluid.HeatPumps.LargeScaleWaterToWater</a>.</p>
<p>Contrary to the other models, parameters for heat exchanger inertia (tau) and mass flow rates are calculated automatically based on the heat demand.</p>
<p>Furthermore, this example demonstrates the warnings which are raised if the table data boundary conditions (e.g. mEva_flow_nominal) deviates from the parameter in use.</p>
<p>To fix this issue, the user has to either</p>
<p>1. Check the assumption of using a different mass flow rate</p>
<p>2. Adjust the mass flow rates in the hydraulic system. If the deviation is too big, the system would not work in reality anyways.</p>
</html>"));
end LargeScaleWaterToWater_OneRoomRadiator;
