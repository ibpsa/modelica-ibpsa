within IBPSA.Fluid.HeatPumps.ModularReversible;
model ReversibleAirToWaterTableData2D
  "Reversible air to water heat pump based on 2D manufacturer data in Europe"
  extends IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible(
    final QCoo_flow_nominal=refCyc.refCycHeaPumCoo.QCooNoSca_flow_nominal*scaFac,
    dpEva_nominal=datTabHea.dpEva_nominal*scaFac^2,
    dpCon_nominal=datTabHea.dpCon_nominal*scaFac^2,
    redeclare replaceable
    IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021 safCtrPar
      constrainedby
      IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic(
      final tabUppHea=datTabHea.tabUppBou,
      final tabLowCoo=datTabCoo.tabLowBou,
      final use_TUseSidOut=datTabHea.use_TConOutForOpeEnv,
      final use_TAmbSidOut=datTabCoo.use_TEvaOutForOpeEnv),
    dTEva_nominal=(QHea_flow_nominal - PEle_nominal)/cpEva/mEva_flow_nominal,
    mEva_flow_nominal=datTabHea.mEva_flow_nominal*scaFac,
    mCon_flow_nominal=datTabHea.mCon_flow_nominal*scaFac,
    dTCon_nominal=QHea_flow_nominal/cpCon/mCon_flow_nominal,
    final GEvaIns=0,
    final GEvaOut=0,
    final CEva=0,
    final use_evaCap=false,
    final GConIns=0,
    final GConOut=0,
    final CCon=0,
    final use_conCap=false,
    redeclare model RefrigerantCycleHeatPumpCooling =
      IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D (
        redeclare IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting iceFacCal,
        final datTab=datTabCoo),
    redeclare model RefrigerantCycleHeatPumpHeating =
      IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D (
        redeclare IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting iceFacCal,
        final datTab=datTabHea),
    final use_rev=true,
    redeclare model RefrigerantCycleInertia =
      IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia);

  replaceable parameter
    IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericAirToWater datTabHea
    constrainedby IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericAirToWater
    "Data table of heat pump"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{82,-18},{98,-2}})));
  replaceable parameter IBPSA.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic datTabCoo
    constrainedby IBPSA.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic
    "Data table of chiller"    annotation (choicesAllMatching=true,
    Placement(transformation(extent={{114,-18},{130,-2}})));

  annotation (Documentation(info="<html>
<p>
  Reversible air-to-water heat pump based on
  two-dimensional data from manufacturer data, (e.g. based on EN 14511),
  using the
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible\">
  IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible</a> approach.
</p>
<p>
  For more information on the approach, see
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.UsersGuide\">
  IBPSA.Fluid.HeatPumps.ModularReversible.UsersGuide</a>.
</p>
<p>
  Internal inertias and heat losses are neglected,
  as these are implicitly obtained in measured
  data from manufacturers.
  Also, icing is disabled as the performance degradation
  is already contained in the data.
</p>
<p>
Please read the documentation of the model for heating at
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D</a>.
</p>
<p>
For cooling, the assumptions are similar, and described at
  <a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D\">
  IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D</a>
</p>
<h4>References</h4>
<p>
EN 14511-2018: Air conditioners, liquid chilling packages and heat pumps for space
heating and cooling and process chillers, with electrically driven compressors
<a href=\"https://www.beuth.de/de/norm/din-en-14511-1/298537524\">
https://www.beuth.de/de/norm/din-en-14511-1/298537524</a>
</p>

</html>"));
end ReversibleAirToWaterTableData2D;
