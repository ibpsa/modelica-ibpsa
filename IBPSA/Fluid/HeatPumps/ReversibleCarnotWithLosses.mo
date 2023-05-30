within IBPSA.Fluid.HeatPumps;
model ReversibleCarnotWithLosses
  "Use a carnot approach, but add reversibility and losses (heat, frost, inertia)"
  extends ModularReversible(
    redeclare model RefrigerantCycleHeatPumpCooling =
        IBPSA.Fluid.Chillers.RefrigerantCycleModels.ConstantQualityGrade (
        QUseNoSca_flow_nominal=QCoo_flow_nominal,
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
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal=QUse_flow_nominal
    "Nominal heat flow rate of cooling operation"
      annotation(Dialog(group="Nominal Design"));
  annotation (Documentation(info="<html>
<p>This model uses a simple carnot approache with a constant quality grade, similar to the model <a href=\"IBPSA.Fluid.HeatPumps.Carnot_y\">IBPSA.Fluid.HeatPumps.Carnot_y</a>.</p>
<p>However, it adds the option for reversibility, refrigerant inertia, and heat losses at the heat exchangers.</p>
</html>"));
end ReversibleCarnotWithLosses;
