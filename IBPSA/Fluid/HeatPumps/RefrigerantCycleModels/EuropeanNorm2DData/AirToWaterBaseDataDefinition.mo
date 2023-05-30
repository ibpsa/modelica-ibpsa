within IBPSA.Fluid.HeatPumps.RefrigerantCycleModels.EuropeanNorm2DData;
record AirToWaterBaseDataDefinition
  "Partial record to allow automatic selection of air-to-water heat pump devices"
  extends HeatPumpBaseDataDefinition;
  annotation (Documentation(revisions="<html>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Added to enable better selection <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</html>", info="<html>
<p>
  This record allows specific selection using 
  <code>choicesAllMatching</code> in models like 
  <a href=\"IBPSA.Fluid.HeatPumps.ReversibleAirToWaterEuropeanNorm2D\">
  IBPSA.Fluid.HeatPumps.ReversibleAirToWaterEuropeanNorm2D</a>.
</p>
</html>"));
end AirToWaterBaseDataDefinition;
