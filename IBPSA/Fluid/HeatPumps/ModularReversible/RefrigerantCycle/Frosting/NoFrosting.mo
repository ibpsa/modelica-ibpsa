within IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting;
model NoFrosting "No frosting, iceFac=1"
  extends BaseClasses.PartialIcingFactor;
equation
  iceFac = 1;
  annotation (Documentation(info="<html>
<p>
  Don't account for frosting.
  May be used to disable frosting.
</p>
</html>", revisions="<html>
<ul><li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li></ul>
</html>"));
end NoFrosting;
