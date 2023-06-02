within IBPSA.Fluid.HeatPumps;
model ReversibleAirToWaterEuropeanNorm2D
  "Reversibel air to water heat pump based on 2D manufacturer data in europe"
  extends IBPSA.Fluid.HeatPumps.ModularReversible(
    final safCtrPar=safCtrParEurNor,
    dTEva_nominal=0,
    mEva_flow_nominal=datTabHea.mEva_flow_nominal*scaFac,
    mCon_flow_nominal=datTabHea.mCon_flow_nominal*scaFac,
    dTCon_nominal=QUse_flow_nominal/cpCon/mCon_flow_nominal,
    final GEvaIns=0,
    final GEvaOut=0,
    final CEva=0,
    final use_evaCap=false,
    final GConIns=0,
    final GConOut=0,
    final CCon=0,
    final use_conCap=false,
    redeclare model RefrigerantCycleHeatPumpCooling =
        IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2D (redeclare
          IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Frosting.NoFrosting
          iceFacCal, final datTab=datTabCoo),
    redeclare model RefrigerantCycleHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2D (redeclare
          IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Frosting.NoFrosting
          iceFacCal, final datTab=datTabHea),
    final use_rev=true,
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.RefrigerantCycleInertias.NoInertia);

  replaceable parameter
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.AirToWaterBaseDataDefinition
    datTabHea constrainedby
    IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData.AirToWaterBaseDataDefinition
    "Data Table of HP" annotation (choicesAllMatching=true);
  replaceable parameter
    IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2DData.ChillerBaseDataDefinition
    datTabCoo constrainedby
    IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2DData.ChillerBaseDataDefinition
    "Data Table of Chiller" annotation (choicesAllMatching=true);
  replaceable parameter
    IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.DefaultHeatPumpSafetyControl safCtrParEurNor
    constrainedby
    IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.PartialRefrigerantMachineSafetyControlBaseDataDefinition(
      final tabUppHea=datTabHea.tabUppBou,
      final tabLowCoo=datTabCoo.tabLowBou,
      final use_TUseOut=datTabHea.use_TConOutForOpeEnv,
      final use_TNotUseOut=datTabCoo.use_TEvaOutForOpeEnv)
    "Safety control parameters" annotation (Dialog(enable=
          use_internalSafetyControl, group="Safety Control"),
      choicesAllMatching=true);

  annotation (Documentation(info="<html>
<p>
  Reversible air-to-water heat pump based on 
  European Norm 2D data from the standard EN 14511,
  using the ModularReversible model approach.
</p>
<p>
  For more information on the approach, please read the 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversibleUsersGuide\">
  UsersGuide</a>.
</p>
<p>
  Internal inertias and heat losses are neglected, 
  as these are implicitly obtained in the measured 
  data from EN 14511. 
  Also, icing is disabled as the performance degradation 
  is already contained in the data.
</p>
<p>
  Please read the documentation of the model for heating here: 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2D\">
  IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2D</a>.
</p>
<p>
  For cooling, the assumptions are similar. 
  Check this documentation: 
  <a href=\"modelica://IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2D\">
  IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2D</a>
</p>
</html>"));
end ReversibleAirToWaterEuropeanNorm2D;
