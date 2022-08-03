within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.EN14511;
record Dimplex_LA11AS "Dimplex LA 11 AS"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.HeatPumpBaseDataDefinition(
    tablePel=[0,-7,2,7,10; 35,2444,2839,3139,3103; 45,2783,2974,3097,3013],
    tableQCon_flow=[0,-7,2,7,10; 35,6600,8800,11300,12100; 45,6400,7898,9600,
        10145],
    mCon_flow_nominal=11300/4180/5,
    mEva_flow_nominal=1,
    tableUppBou=[-25,58; 35,58]);

  annotation(", "DymolaStoredErrors,
    Icon,
    Documentation(revisions="<html><ul>
  <li>
    <i>Oct 14, 2016&#160;</i> by Philipp Mehrfeld:<br/>
    Transferred to IBPSA.
  </li>
</ul>
</html>", info="<html>
<p>
  According to data from Dimplex data sheets; EN14511
</p>
</html>"));
end Dimplex_LA11AS;
