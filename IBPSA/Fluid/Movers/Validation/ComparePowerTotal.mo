within IBPSA.Fluid.Movers.Validation;
model ComparePowerTotal
  "Compare power estimation with total power curve"
  extends IBPSA.Fluid.Movers.Validation.ComparePowerHydraulic(
    redeclare IBPSA.Fluid.Movers.Data.Pumps.Wilo.Stratos40slash1to12 per);
annotation(experiment(Tolerance=1e-6, StopTime=200),
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Movers/Validation/ComparePowerTotal.mos"
        "Simulate and plot"));
end ComparePowerTotal;
