within IBPSA.Fluid.HeatPumps;
model LargeScaleWaterToWater
  "Model with automatic parameter estimation for large scale water-to-water heat pumps"
  extends ModularReversible(
    GEvaIns=0,
    GEvaOut=0,
    CEva=0,
    use_evaCap=false,
    GConIns=0,
    GConOut=0,
    CCon=0,
    use_conCap=false,
    redeclare model RefrigerantCycleHeatPumpCooling =
        IBPSA.Fluid.Chillers.RefrigerantCycleModels.BaseClasses.NoCooling,
    redeclare model RefrigerantCycleHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2D (redeclare
          IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Frosting.NoFrosting
          iceFacCal, datTab=datTab),
    final use_rev=false,
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.RefrigerantCycleInertias.NoInertia,
    mCon_flow_nominal=autCalMCon_flow*scaFac,
    mEva_flow_nominal=autCalMEva_flow*scaFac,
    tauCon=autCalVCon*rhoCon/autCalMCon_flow,
    tauEva=autCalVEva*rhoEva/autCalMEva_flow);

  extends BaseClasses.LargeScaleWaterToWaterParameters(
    final autCalMCon_flow=max(4E-5*QUse_flow_nominal - 0.6162, autCalMMin_flow),
    final autCalMEva_flow=max(4E-5*QUse_flow_nominal - 0.3177, autCalMMin_flow),
    final autCalVCon=max(1E-7*QUse_flow_nominal - 94E-4, autCalVMin),
    final autCalVEva=max(1E-7*QUse_flow_nominal - 75E-4, autCalVMin));

  parameter
    RefrigerantCycleModels.EuropeanNorm2DData.HeatPumpBaseDataDefinition datTab=
     IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.EN14511.WAMAK_WaterToWater_150kW()
         "Data Table of HP" annotation (choicesAllMatching=true);
  annotation (Documentation(info="<html>
<p>Model using parameters for a large scale water-to-water heat pump. </p>
<p>Parameters are based on an automatic estimation, see: <a href=\"IBPSA.Fluid.HeatPumps.BaseClasses.LargeScaleWaterToWaterParameters\">IBPSA.Fluid.HeatPumps.BaseClasses.LargeScaleWaterToWaterParameters</a></p>
</html>", revisions="<html><ul>
  <li>
    <i>Novemeber 11, 2022</i> by Fabian Wuellhorst:<br/>
    Implemented <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end LargeScaleWaterToWater;
