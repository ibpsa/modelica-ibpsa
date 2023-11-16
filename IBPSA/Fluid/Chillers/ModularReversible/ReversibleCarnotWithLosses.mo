within IBPSA.Fluid.Chillers.ModularReversible;
model ReversibleCarnotWithLosses
  "Reversible chiller using carnot approach with losses (frost, heat, inertia)"
  extends IBPSA.Fluid.Chillers.ModularReversible.ModularReversible(
    y_nominal=1,
    redeclare model RefrigerantCycleChillerHeating =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantQualityGrade
        (
        QUseNoSca_flow_nominal=QUse_flow_nominal,
        redeclare
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        quaGra=quaGra,
        use_constAppTem=true,
        useAirForCon=cpCon < 1500,
        useAirForEva=cpEva < 1500,
        TAppCon_nominal=TAppCon_nominal,
        TAppEva_nominal=TAppEva_nominal),
    redeclare model RefrigerantCycleChillerCooling =
        IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade
        (
        redeclare
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.FunctionalIcingFactor
          iceFacCal(redeclare function icingFactor =
              IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions.wetterAfjei1997),
        useAirForCon=cpCon < 1500,
        useAirForEva=cpEva < 1500,
        TAppCon_nominal=TAppCon_nominal,
        TAppEva_nominal=TAppEva_nominal,
        quaGra=quaGra),
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.VariableOrder
        (
        final refIneFreConst=1/refIneTimCon,
        final nthOrd=1,
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

  annotation (Documentation(revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>", info="<html>
<p>
  This model extends
  <a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.ModularReversible\">
  IBPSA.Fluid.Chillers.ModularReversible.ModularReversible</a> and selects the
  constant quality grade module for chillers
  (<a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade\">
  IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade</a>)
  and heat pumps
  (<a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantQualityGrade\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantQualityGrade</a>)
  to model a reversible chiller.
  For the heating operation, the nominal approach temperatures are used 
  as a constant to avoid nonlinear solving issues.
</p>
<p>
  Furthermore, losses are enabled to model
  the chiller with a more realistic behaviour:
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
</html>"));
end ReversibleCarnotWithLosses;
