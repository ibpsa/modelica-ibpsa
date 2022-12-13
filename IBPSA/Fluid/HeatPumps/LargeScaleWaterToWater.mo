within IBPSA.Fluid.HeatPumps;
model LargeScaleWaterToWater
  "Model with automatic parameter estimation for large scale water-to-water heat pumps"
  extends ModularReversible(
    redeclare model BlackBoxHeatPumpCooling =
        IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.NoCooling,
    redeclare model BlackBoxHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2D (redeclare
          IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.NoFrosting iceFacCal,
          datTab=datTab),
    use_rev=false,
    redeclare model VapourCompressionCycleInertia =
        IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias.NoInertia,
    mCon_flow_nominal=autCalMCon_flow*scaFac,
    mEva_flow_nominal=autCalMEva_flow*scaFac,
    tauCon=autCalVCon*rhoCon/autCalMCon_flow,
    tauEva=autCalVEva*rhoEva/autCalMEva_flow);
  extends BaseClasses.LargeScaleWaterToWaterParameters(
    final autCalMCon_flow=max(4E-5*QUse_flow_nominal - 0.6162, autCalMMin_flow),
    final autCalMEva_flow=max(4E-5*QUse_flow_nominal - 0.3177, autCalMMin_flow),
    final autCalVCon=max(1E-7*QUse_flow_nominal - 94E-4, autCalVMin),
    final autCalVEva=max(1E-7*QUse_flow_nominal - 75E-4, autCalVMin));

  parameter BlackBoxData.EuropeanNorm2DData.HeatPumpBaseDataDefinition datTab=
      IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.EN14511.WAMAK_WaterToWater_150kW()
         "Data Table of HP" annotation(choicesAllMatching=true);
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
