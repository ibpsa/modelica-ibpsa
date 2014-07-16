within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts;
function readTrajectoryTResSho
  input String filPathAndName;
  input Boolean rendering=false;
  output Real[:] TMea "mean in-out temperature";
algorithm
  if rendering then
    TMea := {1};
  else
    (,TMea) := readTrajectoryTRSHX(filPathAndName);
  end if;

end readTrajectoryTResSho;
