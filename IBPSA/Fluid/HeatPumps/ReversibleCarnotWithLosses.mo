within IBPSA.Fluid.HeatPumps;
model ReversibleCarnotWithLosses
  "Use a carnot approach, but add reversibility and losses (heat, frost, inertia)"
  extends ModularReversible(
    redeclare model RefrigerantCycleHeatPumpCooling =
        IBPSA.Fluid.Chillers.RefrigerantCycleModels.ConstantQualityGrade (
        QUseNoSca_flow_nominal=QUse_flow_nominal,
        redeclare
          IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Frosting.NoFrosting
          iceFacCal,
        useAirForCon=cpCon < 1500,
        useAirForEva=cpEva < 1500,
        quaGra=quaGra),
    redeclare model RefrigerantCycleHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.ConstantQualityGrade (
        redeclare
          IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Frosting.FunctionalApproach
          iceFacCal(redeclare function iceFacFun =
              IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Frosting.Functions.WetterAfjei1997),
        useAirForCon=cpCon < 1500,
        useAirForEva=cpEva < 1500,
        quaGra=quaGra),
    final use_evaCap,
    final use_conCap,
    redeclare model RefrigerantCycleInertia =
        IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.RefrigerantCycleInertias.VariableOrderInertia
        (refIneFreConst=refIneFreConst, nthOrd=nthOrd));

  parameter Real quaGra=0.3 "Constant quality grade";
  parameter Modelica.Units.SI.Frequency refIneFreConst
    "Cut off frequency for inertia of refrigerant cycle";
  parameter Integer nthOrd=3 "Order of refrigerant cycle interia";

  annotation (Documentation(info="<html>
<p>
  This model extends the model 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible\">
  IBPSA.Fluid.HeatPumps.ModularReversible</a> and selects the 
  constant quality grade model approaches for heat pumps 
  (<a href=\"modelica://IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.ConstantQualityGrade\">IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.ConstantQualityGrade</a>) 
  and chillers 
  (<a href=\"modelica://IBPSA.Fluid.Chillers.RefrigerantCycleModels.ConstantQualityGrade\">IBPSA.Fluid.Chillers.RefrigerantCycleModels.ConstantQualityGrade</a>)
  to model a reversible heat pump.
</p>
<p>
  Furthermore, losses are enabled to model 
  the heat pump with a more realistic behaviour:
</p>
<ul>
<li>Heat losses to the ambient</li>
<li>Refrigerant inertia using a first order delay</li>
<li>Evaporator frosting assuming an air-sink chiller</li>
</ul>
  You can disable the heat losses if required.
<p>
  For more information on the approach, please read the 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversibleUsersGuide\">
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
