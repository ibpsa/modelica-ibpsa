within IBPSA.Fluid.HeatPumps;
model LargeScaleWaterToWater
  "Model with automatic parameter estimation for large scale water-to-water heat pumps"
  extends ModularReversible(
    final GEvaIns=0,
    final GEvaOut=0,
    final CEva=0,
    final use_evaCap=false,
    final GConIns=0,
    final GConOut=0,
    final CCon=0,
    final use_conCap=false,
    redeclare model RefrigerantCycleHeatPumpCooling =
        IBPSA.Fluid.Chillers.RefrigerantCycleModels.BaseClasses.NoCooling,
    redeclare model RefrigerantCycleHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2D (redeclare
          IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Frosting.NoFrosting
          iceFacCal, datTab=datTab),
    final use_rev=false,
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.RefrigerantCycleInertias.NoInertia,
    final mCon_flow_nominal=autCalMasCon_flow*scaFac,
    final mEva_flow_nominal=autCalMasEva_flow*scaFac,
    final tauCon=autCalVCon*rhoCon/autCalMasCon_flow,
    final tauEva=autCalVEva*rhoEva/autCalMasEva_flow);

  extends BaseClasses.LargeScaleWaterToWaterParameters(
    final autCalMasCon_flow=max(4E-5*QUse_flow_nominal - 0.6162,
        autCalMMin_flow),
    final autCalMasEva_flow=max(4E-5*QUse_flow_nominal - 0.3177,
        autCalMMin_flow),
    final autCalVCon=max(1E-7*QUse_flow_nominal - 94E-4, autCalVMin),
    final autCalVEva=max(1E-7*QUse_flow_nominal - 75E-4, autCalVMin));

  parameter
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.HeatPumpBaseDataDefinition datTab=
     IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN14511.WAMAK_WaterToWater_150kW()
         "Data Table of HP" annotation (choicesAllMatching=true);
  annotation (Documentation(info="<html>
<p>Model using parameters for a large scale water-to-water heat pump. </p>
<p>Parameters are based on an automatic estimation, see: <a href=\"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.LargeScaleWaterToWaterParameters\">IBPSA.Fluid.HeatPumps.BaseClasses.LargeScaleWaterToWaterParameters</a>.</p>
<p>Currently the only data sheets for heat pumps that large is the record <a href=\"modelica://IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN14511.WAMAK_WaterToWater_150kW\">IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN14511.WAMAK_WaterToWater_150kW</a>, hence, the default value.</p>
<p>But you are free to insert custom data based on the heat pump you want to analyze in your simulations.</p>
</html>", revisions="<html><ul>
  <li>
    <i>Novemeber 11, 2022</i> by Fabian Wuellhorst:<br/>
    Implemented <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end LargeScaleWaterToWater;
