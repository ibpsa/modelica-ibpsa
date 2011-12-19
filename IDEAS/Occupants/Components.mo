within IDEAS.Occupants;
package Components

  extends Modelica.Icons.Package;

  block Fanger "Fanger model"

    outer IDEAS.Climate.SimInfoManager
                               sim
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

    parameter Boolean Linear = true;

    Modelica.Blocks.Interfaces.RealOutput PMV "predicted mean vote" annotation (Placement(transformation(extent={{90,18},
              {110,38}})));

    Modelica.Blocks.Interfaces.RealOutput PPD
      "predicted percentage dissatisfied"                                          annotation (Placement(transformation(extent={{90,-30},
              {110,-10}})));

    Modelica.Blocks.Interfaces.RealInput Tair "zone air temperature"
      annotation (Placement(transformation(extent={{20,-20},{-20,20}},
            rotation=180,
            origin={-100,30})));
    Modelica.Blocks.Interfaces.RealInput Trad "zone radiative temperature"
      annotation (Placement(transformation(extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-100,-20})));

  protected
    IDEAS.Occupants.BaseClasses.PredictedPercentageDissatisfied ppd
      "PPD calculated"
      annotation (Placement(transformation(extent={{60,-36},{80,-16}})));
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
        points={{80,-20},{100,-20}},
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
          points={{28,40},{40,40},{40,-20},{60,-20}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(pmv.PMV, PMV)   annotation (Line(
          points={{28,40},{64,40},{64,28},{100,28}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(Tair, cloTemperature.Tair)
                               annotation (Line(
          points={{-100,30},{-40,30},{-40,-2},{-20,-2},{-20,26}},
          color={0,0,127},
          smooth=Smooth.None));
    connect(Tair, pmv.Tair)   annotation (Line(
          points={{-100,30},{-40,30},{-40,-2},{14,-2},{14,26}},
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

    annotation (Icon(graphics={
          Ellipse(
            extent={{-70,70},{70,-70}},
            lineColor={127,0,0},
            fillPattern=FillPattern.Solid,
            fillColor={127,0,0}),
          Ellipse(
            extent={{-60,60},{60,-60}},
            lineColor={127,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{2,0},{2,58},{14,56},{24,52},{32,48},{42,40},{48,32},{54,22},
                {58,10},{58,-4},{56,-16},{50,-28},{44,-38},{42,-40},{2,0}},
            smooth=Smooth.None,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-4,50},{2,-2}},
            lineColor={127,0,0},
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{2,0},{18,-16},{14,-20},{-4,-2},{2,0}},
            lineColor={127,0,0},
            smooth=Smooth.None,
            fillColor={127,0,0},
            fillPattern=FillPattern.Solid)}));
  end Schedule;



  model userInfoMan

  replaceable BWFlib.Residential.Users.userOnFile userDetail annotation (choicesAllMatching = true);

  parameter Integer n_B = 33 "number of buildings to be considered";
  final parameter Integer[n_B] columns = {i+1 for i in 1:n_B};

  Modelica.Blocks.Tables.CombiTable1Ds Pow(
      final smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
      tableOnFile = true,
      tableName = "data",
      fileName = userDetail.filNamPow,
      columns = columns);
  Modelica.Blocks.Tables.CombiTable1Ds PowCon(
      final smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
      tableOnFile = true,
      tableName = "data",
      fileName = userDetail.filNamPowCon,
      columns = columns);
  Modelica.Blocks.Tables.CombiTable1Ds PowRad(
      final smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
      tableOnFile = true,
      tableName = "data",
      fileName = userDetail.filNamPowRad,
      columns = columns);
  Modelica.Blocks.Tables.CombiTable1Ds TopAsk(
      final smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
      tableName = "data",
      tableOnFile = true,
      fileName = userDetail.filNamTopAsk,
      columns = columns);

  equation
  time = Pow.u;
  time = PowCon.u;
  time = PowRad.u;
  time = TopAsk.u;

    annotation (defaultComponentName="user", defaultComponentPrefixes="inner",  missingInnerMessage="Your model is using an outer \"user\" component. An inner \"user\" component is not defined. For simulation drag BWF.BuiUser.userInfoMan into your model.",
          Icon(graphics={                                                                     Bitmap(
            extent={{-100,100},{100,-100}},
            imageSource="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",
            fileName="modelica://BWF/../BWFlib/user.jpg"),
            Bitmap(extent={{124,-106},{34,-32}}, fileName="modelica://BWF/../bluetooth.png")}));
  end userInfoMan;
end Components;
