within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function readTrajectorytVec
  input String filPathAndName;
  input Boolean rendering;
  output Integer[:] tVec;
algorithm
  tVec := if not rendering then readTrajectoryTRSHX(filPathAndName) else {1};
end readTrajectorytVec;
