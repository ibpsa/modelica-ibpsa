within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.Scripts;
function readTrajectoryTRSHX
  input String filPathAndName;
  output Integer[:] tVec;
  output Real[:] TMea "mean in-out temperature";
protected
  Real[3,:] readData;
algorithm

  readData := readTrajectory(
      filPathAndName + ".mat",
      {"Time","borHolSer.sta_a.T","borHolSer.sta_b.T"},
      readTrajectorySize(filPathAndName + ".mat"));
  tVec := integer(readData[1, 1:end]);
  TMea := (readData[2, 1:end] + readData[3, 1:end])/2;
end readTrajectoryTRSHX;
