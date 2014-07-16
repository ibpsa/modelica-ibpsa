within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function readTrajectoryVecLen
  input String filPathAndName;
  input Boolean rendering;
  output Integer vecLen "length of vector";
algorithm
  vecLen := if not rendering then readTrajectorySize(filPathAndName + ".mat") else 1;
end readTrajectoryVecLen;
