within IBPSA.Fluid.HeatPumps.ModularReversible;
model LargeScaleWaterToWater
  "Model with automatic parameter estimation for large scale water-to-water heat pumps"
  extends IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible(
    final safCtrPar=safCtrParEurNor,
    final dTEva_nominal=(QUse_flow_nominal - PEle_nominal)/cpEva/
        mEva_flow_nominal,
    final dTCon_nominal=QUse_flow_nominal/cpCon/mCon_flow_nominal,
    redeclare package MediumCon = IBPSA.Media.Water,
    redeclare package MediumEva = IBPSA.Media.Water,
    final GEvaIns=0,
    final GEvaOut=0,
    final CEva=0,
    final use_evaCap=false,
    final GConIns=0,
    final GConOut=0,
    final CCon=0,
    final use_conCap=false,
    redeclare model RefrigerantCycleHeatPumpCooling =
        IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling,
    redeclare model RefrigerantCycleHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D (redeclare
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal, datTab=datTab),
    final use_rev=false,
    final QCoo_flow_nominal=0,
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia,
    final mCon_flow_nominal=autCalMasCon_flow,
    final mEva_flow_nominal=autCalMasEva_flow,
    final tauCon=autCalVCon*rhoCon/autCalMasCon_flow,
    final tauEva=autCalVEva*rhoEva/autCalMasEva_flow);

  extends IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.LargeScaleWaterToWaterDeclarations(
    final autCalMasCon_flow=max(4E-5*QUse_flow_nominal - 0.6162,
        autCalMMin_flow),
    final autCalMasEva_flow=max(4E-5*QUse_flow_nominal - 0.3177,
        autCalMMin_flow),
    final autCalVCon=max(1E-7*QUse_flow_nominal - 94E-4, autCalVMin),
    final autCalVEva=max(1E-7*QUse_flow_nominal - 75E-4, autCalVMin));

  replaceable parameter
    IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump datTab=
      IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.WAMAK_WaterToWater_150kW()
    "Data Table of HP" annotation (choicesAllMatching=true);
  replaceable parameter
    IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021 safCtrParEurNor
    constrainedby IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic(
      final tabUppHea=datTab.tabUppBou,
      final tabLowCoo=datTab.tabUppBou,
      final use_TUseOut=datTab.use_TConOutForOpeEnv,
      final use_TNotUseOut=datTab.use_TEvaOutForOpeEnv)
    "Safety control parameters" annotation (Dialog(enable=
          use_internalSafetyControl, group="Safety Control"),
      choicesAllMatching=true);
    // Lower boundary has no influence as use_rev=false
  annotation (Documentation(info="<html>
<p>
  Model using parameters for a large scale water-to-water heat pump,
  using the ModularReversible model approach.
</p>
<p>
  For more information on the approach, please read the
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversibleUsersGuide\">
  UsersGuide</a>.
</p>
<p>
  Parameters are based on an automatic estimation, see:
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.LargeScaleWaterToWaterDeclarations\">
  IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.LargeScaleWaterToWaterDeclarations</a>.
</p>
<p>
  Please read the documentation of the model for heating here:
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D</a>.
</p>
<p>
  Currently the only data sheets for heat pumps that large is the record
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.WAMAK_WaterToWater_150kW\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2DData.EN14511.WAMAK_WaterToWater_150kW</a>,
  hence, the default value.
</p>
<p>
  But you are free to insert custom data based on
  the heat pump you want to analyze in your simulations.
</p>
<h4>Assumptions</h4>
<ul>
<li>
  As heat losses are implicitly included in the table
  data according to EN 14511, heat losses are disabled.
</li>
</ul>
</html>", revisions="<html><ul>
  <li>
    <i>Novemeber 11, 2022</i> by Fabian Wuellhorst:<br/>
    Implemented <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end LargeScaleWaterToWater;
