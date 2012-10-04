within IDEAS.Occupants;
package Components

  extends Modelica.Icons.Package;

  block Fanger "Fanger model"

    outer IDEAS.SimInfoManager sim
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

    outer IDEAS.SimInfoManager sim;

    parameter Real occupancy[:]=3600*{7, 19}
      "Occupancy table, each entry switching occupancy on or off";
    parameter Boolean firstEntryOccupied = true
      "Set to true if first entry in occupancy denotes a changed from unoccupied to occupied";
    parameter Modelica.SIunits.Time startTime = 0 "Start time of periodicity";
    parameter Modelica.SIunits.Time endTime =   86400 "End time of periodicity";

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

    output Integer nexStaInd "Next index when occupancy starts";
    output Integer nexStoInd "Next index when occupancy stops";

    output Integer iPerSta
      "Counter for the period in which the next occupancy starts";
    output Integer iPerSto
      "Counter for the period in which the next occupancy stops";
    output Modelica.SIunits.Time schTim
      "Time in schedule (not exceeding max. schedule time)";
    output Modelica.SIunits.Time tMax "Maximum time in schedule";
    output Modelica.SIunits.Time tOcc "Time when next occupancy starts";
    output Modelica.SIunits.Time tNonOcc "Time when next non-occupancy starts";

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
    when time >= pre(occupancy[nexStaInd])+ iPerSta*period then
      nexStaInd :=nexStaInd + 2;
      occupied := not occupied;
      // Wrap index around
      if nexStaInd > nRow then
         nexStaInd := if firstEntryOccupied then 1 else 2;
         iPerSta := iPerSta + 1;
      end if;
      tOcc := occupancy[nexStaInd] + iPerSta*(period);
    end when;

    // Changed the index that computes the time until the next non-occupancy
    when time >= pre(occupancy[nexStoInd])+ iPerSto*period then
      nexStoInd :=nexStoInd + 2;
      occupied := not occupied;
      // Wrap index around
      if nexStoInd > nRow then
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
          Icon(graphics));
  end userInfoMan;

  model UserProfiles
    "External file reader for all user behaviour.  Required for simulations with IDEAS.Occupants models based on external files."

  parameter String fileNameQCon = "../Inputs/User_QCon.txt"
      "File with convective heat gains, in W";
  parameter String fileNameQRad = "../Inputs/User_QRad.txt"
      "File with radiative heat gains, in W";
  parameter String fileNamePre = "../Inputs/User_Presence.txt"
      "File with presence (binary 0-1)";
  parameter String fileNameDHW = "../Inputs/User_mDHW.txt"
      "File with DHW consumption at 60 degC, in kg/s";
  parameter String fileNameP = "../Inputs/User_P.txt"
      "File with active power, in W";
  parameter String fileNameQ = "../Inputs/User_zeros.txt"
      "File with reactive power, in W";

  Modelica.Blocks.Tables.CombiTable1Ds tabQCon(
      final smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
      tableOnFile = true,
      tableName = "data",
      fileName = fileNameQCon,
      columns=2:34)            annotation (Placement(transformation(extent={{-54,52},
              {-34,72}})));

  Modelica.Blocks.Tables.CombiTable1Ds tabQRad(
      final smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
      tableOnFile = true,
      tableName = "data",
      fileName = fileNameQRad,
      columns=2:34)            annotation (Placement(transformation(extent={{-54,22},
              {-34,42}})));
  Modelica.Blocks.Tables.CombiTable1Ds tabPre(
      final smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
      tableOnFile = true,
      tableName = "data",
      fileName = fileNamePre,
      columns=2:34)           annotation (Placement(transformation(extent={{18,52},
              {38,72}})));
  Modelica.Blocks.Tables.CombiTable1Ds tabP(
      final smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
      tableOnFile = true,
      tableName = "data",
      fileName = fileNameP,
      columns=2:34)         annotation (Placement(transformation(extent={{-54,-60},
              {-34,-40}})));
  Modelica.Blocks.Tables.CombiTable1Ds tabQ(
      final smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments,
      tableOnFile = true,
      tableName = "data",
      fileName = fileNameQ,
      columns=2:34)         annotation (Placement(transformation(extent={{-54,-30},
              {-34,-10}})));
  Modelica.Blocks.Tables.CombiTable1Ds tabDHW(
      final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
      tableOnFile=true,
      tableName="data",
      fileName=fileNameDHW,
      columns=2:34) "Domestic hot water in kg/s at 60 degC"
                              annotation (Placement(transformation(extent={{18,22},
              {38,42}})));
  equation
  time=tabQCon.u;
  time=tabQRad.u;
  time=tabPre.u;
  time=tabDHW.u;
  time=tabP.u;
  time=tabQ.u;

  annotation (defaultComponentName="userProfiles", defaultComponentPrefixes="inner",  missingInnerMessage="Your model is using an outer \"userProfiles\" component. An inner \"userProfiles\" component is not defined. For simulation drag IDEAS.Occupants.Components.UserProfiles into your model.",
          Icon(graphics={
          Ellipse(
            extent={{-48,58},{-18,44}},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Ellipse(
            extent={{18,58},{48,44}},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Ellipse(
            extent={{-48,8},{48,-34}},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Ellipse(
            extent={{-42,18},{42,-22}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Line(
            points={{-4,-74},{-8,-94}},
            smooth=Smooth.None,
            color={0,0,0},
            thickness=1),
          Line(
            points={{-2,-74},{-4,-94}},
            smooth=Smooth.None,
            color={0,0,0},
            thickness=1),
          Line(
            points={{0,-74},{0,-94}},
            smooth=Smooth.None,
            color={0,0,0},
            thickness=1),
          Line(
            points={{2,-74},{4,-94}},
            smooth=Smooth.None,
            color={0,0,0},
            thickness=1),
          Line(
            points={{4,-74},{8,-94}},
            smooth=Smooth.None,
            color={0,0,0},
            thickness=1)}));
  end UserProfiles;
end Components;
