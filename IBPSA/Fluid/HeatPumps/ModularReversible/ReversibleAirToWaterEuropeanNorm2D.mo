within IBPSA.Fluid.HeatPumps.ModularReversible;
model ReversibleAirToWaterEuropeanNorm2D
  "Reversible air to water heat pump based on 2D manufacturer data in Europe"
  extends IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible(
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
        IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D (redeclare
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal, final datTab=datTabCoo),
    redeclare model RefrigerantCycleHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D (redeclare
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal, final datTab=datTabHea),
    final use_rev=true,
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia);

  replaceable parameter
    IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericAirToWater datTabHea
    constrainedby IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericAirToWater
    "Data Table of HP" annotation (choicesAllMatching=true);
  replaceable parameter IBPSA.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic
    datTabCoo constrainedby IBPSA.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic
    "Data Table of Chiller" annotation (choicesAllMatching=true);
  replaceable parameter
    IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021 safCtrParEurNor
    constrainedby IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic(
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
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversibleUsersGuide\">
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
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D</a>.
</p>
<p>
  For cooling, the assumptions are similar.
  Check this documentation:
  <a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D\">
  IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D</a>
</p>
</html>"));
end ReversibleAirToWaterEuropeanNorm2D;
