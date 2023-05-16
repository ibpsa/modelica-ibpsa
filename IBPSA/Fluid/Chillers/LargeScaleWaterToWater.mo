within IBPSA.Fluid.Chillers;
model LargeScaleWaterToWater
  extends ModularReversible(
    final GEvaIns=0,
    final GEvaOut=0,
    final CEva=0,
    final use_evaCap=false,
    final GConIns=0,
    final GConOut=0,
    final CCon=0,
    final use_conCap=false,
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.RefrigerantCycleInertias.NoInertia,
    redeclare model RefrigerantCycleChillerHeating =
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.BaseClasses.NoHeating,
    redeclare model RefrigerantCycleChillerCooling =
        IBPSA.Fluid.Chillers.RefrigerantCycleModels.EuropeanNorm2D (redeclare
          IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Frosting.NoFrosting
          iceFacCal, datTab=datTab),
    final use_rev=false,
    final mCon_flow_nominal=autCalMCon_flow*scaFac,
    final mEva_flow_nominal=autCalMEva_flow*scaFac,
    final tauCon=autCalVCon*rhoCon/autCalMCon_flow,
    final tauEva=autCalVEva*rhoEva/autCalMEva_flow);
  extends IBPSA.Fluid.HeatPumps.BaseClasses.LargeScaleWaterToWaterParameters(
    final autCalMCon_flow=max(5E-5*QUse_flow_nominal + 0.3161, autCalMMin_flow),
    final autCalMEva_flow=max(5E-5*QUse_flow_nominal - 0.5662, autCalMMin_flow),
    final autCalVCon=max(2E-7*QUse_flow_nominal - 84E-4, autCalVMin),
    final autCalVEva=max(1E-7*QUse_flow_nominal - 66E-4, autCalVMin));
  replaceable parameter RefrigerantCycleModels.EuropeanNorm2DData.ChillerBaseDataDefinition
    datTab constrainedby RefrigerantCycleModels.EuropeanNorm2DData.ChillerBaseDataDefinition
         "Data Table of Chiller" annotation(choicesAllMatching=true);
  annotation (Documentation(info="<html>
<p>Model using parameters for a large scale water-to-water chiller. </p>
<p>Parameters are based on an automatic estimation, see: <a href=\"IBPSA.Fluid.HeatPumps.BaseClasses.LargeScaleWaterToWaterParameters\">IBPSA.Fluid.HeatPumps.BaseClasses.LargeScaleWaterToWaterParameters</a>.</p>
</html>", revisions="<html><ul>
  <li>
    <i>Novemeber 11, 2022</i> by Fabian Wuellhorst:<br/>
    Implemented <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end LargeScaleWaterToWater;
