within IBPSA.Fluid.Chillers.ModularReversible;
model LargeScaleWaterToWater "Large scale water to water chiller"
  extends ModularReversible(
    final safCtrPar=safCtrParEurNor,
    dpEva_nominal=datTab.dpEva_nominal*scaFac^2,
    dpCon_nominal=datTab.dpCon_nominal*scaFac^2,
    final dTEva_nominal=QUse_flow_nominal/cpEva/mEva_flow_nominal,
    final dTCon_nominal=(QUse_flow_nominal - PEle_nominal)/cpCon/mCon_flow_nominal,
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
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia,
    redeclare model RefrigerantCycleChillerHeating =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.NoHeating,
    redeclare model RefrigerantCycleChillerCooling =
        IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D (
        redeclare
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal, datTab=datTab),
    final use_rev=false,
    final QHea_flow_nominal=0,
    final mCon_flow_nominal=autCalMasCon_flow,
    final mEva_flow_nominal=autCalMasEva_flow,
    final tauCon=autCalVCon*rhoCon/autCalMasCon_flow,
    final tauEva=autCalVEva*rhoEva/autCalMasEva_flow);

  extends IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.LargeScaleWaterToWaterDeclarations(
    final autCalMasCon_flow=max(5E-5*QUse_flow_nominal + 0.3161,
        autCalMMin_flow),
    final autCalMasEva_flow=max(5E-5*QUse_flow_nominal - 0.5662,
        autCalMMin_flow),
    final autCalVCon=max(2E-7*QUse_flow_nominal - 84E-4, autCalVMin),
    final autCalVEva=max(1E-7*QUse_flow_nominal - 66E-4, autCalVMin));
  replaceable parameter
    IBPSA.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Carrier30XWP1012_1MW
    datTab constrainedby Data.TableData2D.Generic "Data Table of Chiller"
    annotation (choicesAllMatching=true);
  replaceable parameter
    IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
    safCtrParEurNor constrainedby
    IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic(
    final tabUppHea=datTab.tabLowBou,
    final tabLowCoo=datTab.tabLowBou,
    final use_TUseSidOut=datTab.use_TEvaOutForOpeEnv,
    final use_TAmbSidOut=datTab.use_TConOutForOpeEnv) "Safety control parameters"
    annotation (Dialog(enable=use_intSafCtr, group="Safety Control"),
      choicesAllMatching=true);
    // Upper boundary has no influence as use_rev=false
  annotation (Documentation(info="<html>
<p>
  Model using parameters for a large scale water-to-water chiller,
  using the ModularReversible model approach.
</p>
<p>
  Contrary to the standard sizing approach for ModularReversible models,
  the parameters are based on an automatic estimation, see:
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.LargeScaleWaterToWaterDeclarations\">
  IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.LargeScaleWaterToWaterDeclarations</a>.
</p>
<p>
  For more information on the approach, please read the
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversibleUsersGuide\">
  UsersGuide</a>.
</p>
<p>
  Please read the documentation of the model for heating here:
  <a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D\">
  IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D</a>.
</p>
<p>
  Currently the only data sheets for chillers that large is the record
  <a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Carrier30XWP1012_1MW\">
  IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2DData.EN14511.Carrier30XWP1012_1MW</a>,
  hence, the default value.
</p>
<p>
  But you are free to insert custom data based on
  the heat pump you want to analyze in your simulations.
</p>
<h4>Assumptions</h4>
<ul>
<li>
  As heat losses are implicitly included in measured
  data in manufacturer dataseheets, heat losses are disabled.
</li>
<li>
  Pressure losses are not provided in datasheets. As typical
  values are unknown, the pressure loss is set to 0 to enable
  easier usage. However, the parameter is not final and should be
  replaced if mover electrical power consumption is of interest for your simulation aim.
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
