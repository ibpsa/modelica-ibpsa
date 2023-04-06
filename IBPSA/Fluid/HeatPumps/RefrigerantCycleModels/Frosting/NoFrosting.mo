within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.Frosting;
model NoFrosting "No frosting, iceFac=1"
  extends BaseClasses.PartialIcingFactor;
equation
  iceFac = 1;
  annotation (Documentation(info="<html>
<p>Don't account for frosting.</p>
</html>"));
end NoFrosting;
