within IBPSA.Fluid.HeatPumps.ModularReversible;
model ReversibleCarnotWithLosses
  "Use a carnot approach, but add reversibility and losses (heat, frost, inertia)"
  extends IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible(
    redeclare model RefrigerantCycleHeatPumpCooling =
        IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade
        (
        QUseNoSca_flow_nominal=QUse_flow_nominal,
        redeclare
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        useAirForCon=cpCon < 1500,
        useAirForEva=cpEva < 1500,
        quaGra=quaGra,
        use_constAppTem=true,
        TAppCon_nominal=TAppCon_nominal,
        TAppEva_nominal=TAppEva_nominal),
    redeclare model RefrigerantCycleHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantQualityGrade
        (
        redeclare
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.FunctionalIcingFactor
          iceFacCal(redeclare function icingFactor =
              IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions.wetterAfjei1997),
        useAirForCon=cpCon < 1500,
        useAirForEva=cpEva < 1500,
        quaGra=quaGra,
        TAppCon_nominal=TAppCon_nominal,
        TAppEva_nominal=TAppEva_nominal),
    final use_evaCap,
    final use_conCap,
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.VariableOrder
        (
        refIneFreConst=1/refIneTimCon,
        nthOrd=nthOrd,
        initType=Modelica.Blocks.Types.Init.InitialOutput));

  parameter Real quaGra=0.3 "Constant quality grade";
  parameter Modelica.Units.SI.TemperatureDifference TAppCon_nominal=if
      cpCon < 1500 then 5 else 2
    "Temperature difference between refrigerant and working fluid outlet in condenser";
  parameter Modelica.Units.SI.TemperatureDifference TAppEva_nominal=if
      cpEva < 1500 then 5 else 2
    "Temperature difference between refrigerant and working fluid outlet in evaporator";
  parameter Modelica.Units.SI.Time refIneTimCon = 300
    "Refrigerant cycle inertia time constant for first order delay";
  parameter Integer nthOrd=1 "Order of refrigerant cycle interia";


  annotation (Documentation(info="<html>
<p>
  This model extends
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible\">
  IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible</a> and selects the
  constant quality grade module for heat pumps
  (<a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantQualityGrade\">IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantQualityGrade</a>)
  and chillers
  (<a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade\">IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade</a>)
  to model a reversible heat pump.
  For the heating operation, the approach temperatures are fixed
  at nominal values to avoid nonlinear solving issues.
</p>
<p>
  Furthermore, losses are enabled to model
  the heat pump with a more realistic behaviour:
</p>
<ul>
<li>Heat losses to the ambient (can be disabled)</li>
<li>Refrigerant inertia using a first order delay</li>
<li>Evaporator frosting assuming an air-sink chiller</li>
</ul>
<p>
  For more information on the approach, please read the
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversibleUsersGuide\">
  UsersGuide</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"));
end ReversibleCarnotWithLosses;
