within IBPSA.Fluid.HeatPumps;
model ReversibleCarnotWithLosses
  "Use a carnot approach, but add reversibility and losses (heat, frost, inertia)"
  extends ModularReversible(
    redeclare model BlackBoxHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.BlackBoxData.ConstantQualityGrade (redeclare
          IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.FunctionalApproach
          iceFacCal(redeclare function iceFacFun =
              IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions.WetterAfjei1997),
          quaGra=quaGra),
    final use_evaCap,
    final use_conCap,
    redeclare model VapourCompressionCycleInertia =
        IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias.VariableOrderInertia
        (refIneFre_constant=refIneFre_constant, nthOrder=nthOrder));
  parameter Real quaGra=0.3 "Constant quality grade";
  parameter Modelica.Units.SI.Frequency refIneFre_constant
    "Cut off frequency for inertia of refrigerant cycle";
  parameter Integer nthOrder=3 "Order of refrigerant cycle interia";
end ReversibleCarnotWithLosses;
