within IDEAS.Management.Occupant;
model Schedule "Single schedule with look-ahead"

  outer IDEAS.SimInfoManager sim;

  parameter Real occupancy[:]=3600*{7, 19}
    "Occupancy table, each entry switching occupancy on or off";
  parameter Boolean firstEntryOccupied = true
    "Set to true if first entry in occupancy denotes a changed from unoccupied to occupied";
  parameter Modelica.SIunits.Time startTime = 0 "Start time of periodicity";
  parameter Modelica.SIunits.Time endTime = 86400 "End time of periodicity";

  Modelica.Blocks.Interfaces.RealOutput tNexNonOcc
    "Time until next non-occupancy"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput tNexOcc "Time until next occupancy"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.BooleanOutput occupied
    "Outputs true if occupied at current time"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

protected
  final parameter Modelica.SIunits.Time period = endTime-startTime;
  final parameter Integer nRow = size(occupancy,1);

  Integer nexStaInd "Next index when occupancy starts";
  Integer nexStoInd "Next index when occupancy stops";

  Integer iPerSta "Counter for the period in which the next occupancy starts";
  Integer iPerSto "Counter for the period in which the next occupancy stops";
  Modelica.SIunits.Time schTim
    "Time in schedule (not exceeding max. schedule time)";
  Modelica.SIunits.Time tMax "Maximum time in schedule";
  Modelica.SIunits.Time tOcc "Time when next occupancy starts";
  Modelica.SIunits.Time tNonOcc "Time when next non-occupancy starts";

initial algorithm
 tOcc    :=if firstEntryOccupied then occupancy[1] else sim.timLoc;
 tNonOcc :=if firstEntryOccupied then sim.timLoc else occupancy[1];

 iPerSta   := 0;
 iPerSto   := 0;
 nexStaInd := if firstEntryOccupied then 1 else 2;
 nexStoInd := if firstEntryOccupied then 2 else 1;
 occupied := not firstEntryOccupied;
 tOcc    := occupancy[nexStaInd];
 tNonOcc := occupancy[nexStoInd];

algorithm
  tMax :=endTime;
  schTim :=startTime + mod(sim.timLoc-startTime, period);

  // Changed the index that computes the time until the next occupancy
  when noEvent(time >= pre(occupancy[nexStaInd])+ iPerSta*period) then
    nexStaInd :=nexStaInd + 2;
    occupied := not occupied;
    // Wrap index around
    if noEvent(nexStaInd > nRow) then
       nexStaInd := if firstEntryOccupied then 1 else 2;
       iPerSta := iPerSta + 1;
    end if;
    tOcc := occupancy[nexStaInd] + iPerSta*(period);
  end when;

  // Changed the index that computes the time until the next non-occupancy
  when noEvent(time >= pre(occupancy[nexStoInd])+ iPerSto*period) then
    nexStoInd :=nexStoInd + 2;
    occupied := not occupied;
    // Wrap index around
    if noEvenet(nexStoInd > nRow) then
       nexStoInd := if firstEntryOccupied then 2 else 1;
       iPerSto := iPerSto + 1;
    end if;
    tNonOcc := occupancy[nexStoInd] + iPerSto*(period);
  end when;

 tNexOcc    := tOcc-sim.timLoc;
 tNexNonOcc := tNonOcc-sim.timLoc;

end Schedule;
