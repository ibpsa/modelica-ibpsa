within IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D;
record GenericAirToWater
  "Partial record to allow automatic selection of air-to-water heat pump devices"
  extends GenericHeatPump;
  annotation (Documentation(revisions="<html>
<ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Added to enable better selection <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This record allows specific selection using
  <code>choicesAllMatching</code> in models like
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ReversibleAirToWaterTableData2D\">
  IBPSA.Fluid.HeatPumps.ModularReversible.ReversibleAirToWaterTableData2D</a>.
</p>
</html>"));
end GenericAirToWater;
