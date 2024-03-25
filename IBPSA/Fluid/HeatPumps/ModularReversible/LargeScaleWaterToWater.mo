within IBPSA.Fluid.HeatPumps.ModularReversible;
model LargeScaleWaterToWater
  "Model with automatic parameter estimation for large scale water-to-water heat pumps"
  extends IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible(
    TEvaCoo_nominal=273.15,
    TConCoo_nominal=273.15,
    redeclare package MediumCon = IBPSA.Media.Water,
    redeclare package MediumEva = IBPSA.Media.Water,
    dpEva_nominal=datTab.dpEva_nominal*scaFac^2,
    dpCon_nominal=datTab.dpCon_nominal*scaFac^2,
    final dTEva_nominal=(QHea_flow_nominal - PEle_nominal)/cpEva/
        mEva_flow_nominal,
    final dTCon_nominal=QHea_flow_nominal/cpCon/mCon_flow_nominal,
    final GEvaIns=0,
    final GEvaOut=0,
    final CEva=0,
    final use_evaCap=false,
    final GConIns=0,
    final GConOut=0,
    final CCon=0,
    final use_conCap=false,
    redeclare replaceable
    IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021 safCtrPar
      constrainedby
      IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic(
      final tabUppHea=datTab.tabUppBou,
      final tabLowCoo=datTab.tabUppBou,
      final use_TConOutHea=datTab.use_TConOutForOpeEnv,
      final use_TEvaOutHea=datTab.use_TEvaOutForOpeEnv),
    redeclare model RefrigerantCycleHeatPumpCooling =
        IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling,
    redeclare model RefrigerantCycleHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D (
        redeclare IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting iceFacCal,
        final datTab=datTab),
    final use_rev=false,
    final QCoo_flow_nominal=0,
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia,
    final mCon_flow_nominal=autCalMasCon_flow,
    final mEva_flow_nominal=autCalMasEva_flow,
    final tauCon=autCalVCon*rhoCon/autCalMasCon_flow,
    final tauEva=autCalVEva*rhoEva/autCalMasEva_flow);

  extends IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.LargeScaleWaterToWaterDeclarations(
    final autCalMasCon_flow=max(4E-5*QHea_flow_nominal - 0.6162, autCalMMin_flow),
    final autCalMasEva_flow=max(4E-5*QHea_flow_nominal - 0.3177, autCalMMin_flow),
    final autCalVCon=max(1E-7*QHea_flow_nominal - 94E-4, autCalVMin),
    final autCalVEva=max(1E-7*QHea_flow_nominal - 75E-4, autCalVMin));
  final parameter Real scaFac=refCyc.refCycHeaPumHea.scaFac "Scaling factor of heat pump";
  replaceable parameter
    IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump datTab
    "Data table of heat pump" annotation (choicesAllMatching=true,
    Placement(transformation(extent={{42,12},{58,28}})));

  annotation (Documentation(info="<html>
<p>
  Model using parameters for a large scale water-to-water heat pump,
  using the ModularReversible model approach.
</p>
<p>
  Contrary to the standard sizing approach for the
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible\">
  IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible</a> models,
  the parameters are based on an automatic estimation as described in
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.LargeScaleWaterToWaterDeclarations\">
  IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.LargeScaleWaterToWaterDeclarations</a>.
</p>
<p>
  For more information on the approach, please read the
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.UsersGuide\">
  UsersGuide</a>.
</p>
<p>
  Please read the documentation of the model for heating here:
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D</a>.
</p>
<h4>Assumptions</h4>
<ul>
<li>
  As heat losses are implicitly included in the table
  data given by manufacturers, heat losses are disabled.
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
