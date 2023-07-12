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
        useAirForCon=cpCon < 1500,
        useAirForEva=cpEva < 1500,
        quaGra=quaGra),
    redeclare model RefrigerantCycleChillerCooling =
        IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade
        (
        redeclare
          IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.FunctionalIcingFactor
          iceFacCal(redeclare function icingFactor =
              IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions.wetterAfjei1997),
        useAirForCon=cpCon < 1500,
        useAirForEva=cpEva < 1500,
        quaGra=quaGra),
    use_evaCap,
    use_conCap,
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.VariableOrder
        (
        final refIneFreConst=1/refIneTimCon,
        final nthOrd=1,
        initType=Modelica.Blocks.Types.Init.InitialOutput));

  parameter Real quaGra=0.3 "Constant quality grade";
  parameter Modelica.Units.SI.Time refIneTimCon = 300
    "Delay time of first order element for inertia of refrigerant cycle";
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
  This model extends the model 
  <a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.ModularReversible\">
  IBPSA.Fluid.Chillers.ModularReversible.ModularReversible</a> and selects the 
  constant quality grade model approaches for chillers 
  (<a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade\">
  IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantQualityGrade</a>) 
  and heat pumps 
  (<a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantQualityGrade\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantQualityGrade</a>)
  to model a reversible chiller.
</p>
<p>
  Furthermore, losses are enabled to model 
  the chiller with a more realistic behaviour:
</p>
<ul>
<li>Heat losses to the ambient</li>
<li>Refrigerant inertia using a first order delay</li>
<li>Evaporator frosting assuming an air-sink chiller</li>
</ul>
You can disable the heat losses if required.
<p>
  For more information on the approach, please read the 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversibleUsersGuide\">
  UsersGuide</a>.
</p>
</html>"));
end ReversibleCarnotWithLosses;
