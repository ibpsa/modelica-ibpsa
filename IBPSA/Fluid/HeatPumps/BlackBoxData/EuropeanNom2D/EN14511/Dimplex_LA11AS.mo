within IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.EN14511;
record Dimplex_LA11AS "Dimplex LA 11 AS"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.HeatPumpBaseDataDefinition(
    device_id="Dimplex_LA11AS",
    tablePel=[0,-7,2,7,10; 35,2444,2839,3139,3103; 45,2783,2974,3097,3013],
    tableQCon_flow=[0,-7,2,7,10; 35,6600,8800,11300,12100; 45,6400,7898,9600,
        10145],
    mCon_flow_nominal=11300/4180/5,
    mEva_flow_nominal=1,
    tableUppBou=[-25,58; 35,58]);

  annotation (Documentation(info="<html>
<p><span style=\"font-family: Courier New; color: #006400;\">Data for a Dimplex LA11AS air-to-water heat pump.</span></p>
</html>"));
end Dimplex_LA11AS;
