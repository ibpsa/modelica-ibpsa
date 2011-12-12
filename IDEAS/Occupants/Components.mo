within IDEAS.Occupants;
package Components

  extends Modelica.Icons.Package;

  block Fanger "fanger model"

    outer IDEAS.Climate.SimInfoManager
                               sim
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

    parameter Boolean Linear = true;

    Modelica.Blocks.Interfaces.RealOutput PMV "predicted mean vote" annotation (Placement(transformation(extent={{90,30},
              {110,50}})));

    Modelica.Blocks.Interfaces.RealOutput PPD
      "predicted percentage dissatisfied"                                          annotation (Placement(transformation(extent={{90,-10},
              {110,10}})));

    Modelica.Blocks.Interfaces.RealInput Tair "zone air temperature"
      annotation (Placement(transformation(extent={{20,-20},{-20,20}},
            rotation=180,
            origin={-100,20})));
    Modelica.Blocks.Interfaces.RealInput Trad "zone radiative temperature"
      annotation (Placement(transformation(extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-100,-20})));

  protected
    IDEAS.Occupants.BaseClasses.PredictedPercentageDissatisfied ppd
      "PPD calculated"
      annotation (Placement(transformation(extent={{60,-16},{80,4}})));
    IDEAS.Occupants.BaseClasses.CloValue cloValue "clothing calculation"
      annotation (Placement(transformation(extent={{-54,60},{-34,80}})));
    IDEAS.Occupants.BaseClasses.CloTemperature cloTemperature(Linear=Linear)
      "clothing surface temperature"
        annotation (Placement(transformation(extent={{-26,26},{-6,46}})));
    IDEAS.Occupants.BaseClasses.PredictedMeanVote pmv(Linear=Linear)
      "pmv calculation"
        annotation (Placement(transformation(extent={{8,26},{28,46}})));
  equation
    connect(ppd.PPD, PPD) annotation (Line(
        points={{80,0},{100,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(cloTemperature.Tclo, pmv.Tclo)
                                   annotation (Line(
          points={{-6,40},{8,40}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(cloValue.CloFrac, cloTemperature.CloFrac)
                                         annotation (Line(
          points={{-34,68},{-14,68},{-14,46}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(cloValue.CloFrac, pmv.CloFrac)
                                        annotation (Line(
          points={{-34,68},{20,68},{20,46}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(pmv.PMV, ppd.PMV)   annotation (Line(
          points={{28,40},{40,40},{40,0},{60,0}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(pmv.PMV, PMV)   annotation (Line(
          points={{28,40},{100,40}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(Tair, cloTemperature.Tair)
                               annotation (Line(
          points={{-100,20},{-40,20},{-40,-2},{-20,-2},{-20,26}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(Tair, pmv.Tair)   annotation (Line(
          points={{-100,20},{-40,20},{-40,-2},{14,-2},{14,26}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(Trad, cloTemperature.Trad)
                               annotation (Line(
          points={{-100,-20},{-40,-20},{-40,-40},{-14,-40},{-14,26}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(Trad, pmv.Trad)   annotation (Line(
          points={{-100,-20},{-40,-20},{-40,-40},{20,-40},{20,26}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(cloValue.RClo, cloTemperature.RClo)
                                   annotation (Line(
          points={{-34,74},{-20,74},{-20,46}},
          color={0,0,127},
          smooth=Smooth.None));
    annotation(Icon(graphics={
          Line(points={{-84,4},{-4,4}},  color={191,0,0}),
          Line(points={{-30,64},{-2,64}},  color={0,0,0}),
          Line(points={{-30,24},{-2,24}},  color={0,0,0}),
          Line(points={{-30,-16},{-2,-16}},  color={0,0,0}),
          Polygon(
            points={{-2,44},{-2,84},{0,90},{4,92},{10,94},{16,92},{20,90},{22,84},
                {22,44},{-2,44}},
            lineColor={0,0,0},
            lineThickness=0.5),
          Ellipse(
            extent={{-10,-94},{30,-56}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-2,44},{22,-64}},
            fillColor={191,0,0},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Line(
            points={{22,44},{22,-60}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{-2,44},{-2,-60}},
            color={0,0,0},
            thickness=0.5)}),
        Diagram(graphics));
  end Fanger;

  model Schedule "Single schedule with look-ahead"

    outer IDEAS.Climate.SimInfoManager
                               sim;

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

end Components;
