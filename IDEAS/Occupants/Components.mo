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
    IDEAS.Occupants.Components.BaseClasses.PredictedPercentageDissatisfied
                                                                ppd
      "PPD calculated"
      annotation (Placement(transformation(extent={{60,-36},{80,-16}})));
    IDEAS.Occupants.Components.BaseClasses.CloValue
                                         cloValue "clothing calculation"
      annotation (Placement(transformation(extent={{-54,60},{-34,80}})));
    IDEAS.Occupants.Components.BaseClasses.CloTemperature
                                               cloTemperature(Linear=Linear)
      "clothing surface temperature"
        annotation (Placement(transformation(extent={{-26,26},{-6,46}})));
    IDEAS.Occupants.Components.BaseClasses.PredictedMeanVote
                                                  pmv(Linear=Linear)
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
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}),
                graphics));
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

  package BaseClasses

    extends Modelica.Icons.BasesPackage;

    block PredictedPercentageDissatisfied
      "predicted percentage of dissatisfied"

    extends Modelica.Blocks.Interfaces.BlockIcon;

      Modelica.Blocks.Interfaces.RealInput PMV "predicted mean vote"
        annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
      Modelica.Blocks.Interfaces.RealOutput PPD
        "predicted percentage of dissatisfied"
        annotation (Placement(transformation(extent={{90,50},{110,70}})));

    algorithm
      PPD := 100-95*exp(-0.003353*PMV^4-0.2179*PMV^2);

      annotation (Icon(graphics),  Diagram(graphics));
    end PredictedPercentageDissatisfied;

    block PredictedMeanVote "predicted mean vote"

    extends Modelica.Blocks.Interfaces.BlockIcon;

      Modelica.Blocks.Interfaces.RealOutput PMV "predicted mean vote"
        annotation (Placement(transformation(extent={{90,30},{110,50}})));
      Modelica.Blocks.Interfaces.RealInput Trad "radiative zone temperature"
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},
            rotation=90,
            origin={20,-100})));
      Modelica.Blocks.Interfaces.RealInput Tair "convective zone temperature"
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},
            rotation=90,
            origin={-40,-100})));
      Modelica.Blocks.Interfaces.RealInput Tclo "clothing surface temperature" annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={-100,40})));
      Modelica.Blocks.Interfaces.RealInput CloFrac "clothing fraction" annotation (Placement(
            transformation(
            extent={{-20,-20},{20,20}},
            rotation=-90,
            origin={20,100})));

      parameter Modelica.SIunits.Area Adu = 1.77 "DuBois Area";
      parameter Modelica.SIunits.Efficiency Eta = 0.1
        "external mechanical efficiency of the body";
      parameter Modelica.SIunits.HeatFlowRate Met = 120 "Metabolic rate";
      parameter Real RelHum = 0.50 "Relative humidity";
      parameter Boolean Linear = true;

      constant Real Cb = 5.67 "black body constant";
      constant Real b = 0.82 "linearization fit";
      final parameter Real Meta = Met/Adu "Specific metabolic rate";

    protected
      Real Conv "convective surface coefficient";
      Modelica.SIunits.Temperature DTr4
        "Linearized or not linearized radiative delta T^4";
      Modelica.SIunits.Pressure Pvp "partial water vapour pressure";

    algorithm
    if Linear then
      DTr4 := b*Cb/Modelica.Constants.sigma*(Tclo-Tair);
    else
      DTr4 := (Tclo-Tair)*(Tclo+Tair)*(Tclo^2+Tair^2);
    end if;

    Pvp := RelHum*611*exp(17.08*(Tair-273.15)/(234.18 +(Tair-273.15)))/1000;
    Conv := 5; /*2.05*(Tclo-Tair)^0.25;*/

    PMV := (0.303*exp(-0.036*Meta) + 0.028)*(Meta - 3.96*10^(-8)*CloFrac*DTr4- CloFrac*Conv*(Tclo-Tair) - 3.05*(5.73 -
        0.007*Meta - Pvp) - 0.42*(Meta - 58.15) - 0.0173*Meta*(5.87 - Pvp) - 0.0014*Meta*(307.15 - Tair));

      annotation (Diagram(graphics), Icon(graphics));
    end PredictedMeanVote;

    block CloValue "clothing"

    extends Modelica.Blocks.Interfaces.BlockIcon;

      Modelica.Blocks.Interfaces.RealOutput RClo "clothing thermal resistance"
        annotation (Placement(transformation(extent={{90,30},{110,50}})));
      Modelica.Blocks.Interfaces.RealOutput CloFrac "clothign fraction"
        annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
      outer IDEAS.SimInfoManager sim
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

      parameter Real CloWin = 0.9 "Clo value for winter conditions";
      parameter Real CloSum = 0.5 "Clo value for summer conditions";

    algorithm
     if noEvent(sim.TeAv > 22 + 273.15) then
       RClo :=0.155*CloSum;
     else
       RClo :=0.155*CloWin;
     end if;

     if noEvent(RClo > 0.078) then
       CloFrac :=1.05 + 0.645*RClo;
     else
       CloFrac:=1.00 + 1.29*RClo;
     end if;

      annotation (Icon(graphics));
    end CloValue;

    block CloTemperature "clothing surface temperature"

    extends Modelica.Blocks.Interfaces.BlockIcon;

      Modelica.Blocks.Interfaces.RealOutput Tclo "clothing surface temperature"
        annotation (Placement(transformation(extent={{90,30},{110,50}})));
      Modelica.Blocks.Interfaces.RealInput Trad "radiative zone temperature"
        annotation (Placement(transformation(extent={{20,-20},{-20,20}},
                rotation=-90,
                origin={20,-100})));
      Modelica.Blocks.Interfaces.RealInput Tair "convective zone temperature"
        annotation (Placement(transformation(extent={{20,-20},{-20,20}},
                rotation=-90,
                origin={-40,-100})));
      Modelica.Blocks.Interfaces.RealInput RClo "clothing thermal resistance" annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=-90,
            origin={-40,100})));
      Modelica.Blocks.Interfaces.RealInput CloFrac "clothign fraction" annotation (Placement(
            transformation(
            extent={{-20,-20},{20,20}},
            rotation=-90,
            origin={20,100})));

      parameter Modelica.SIunits.Area Adu = 1.77 "DuBois Area";
      parameter Modelica.SIunits.Efficiency Eta = 0.1
        "external mechanical efficiency of the body";
      parameter Modelica.SIunits.HeatFlowRate Met = 120 "Metabolic rate";
      parameter Boolean Linear = true;
      parameter Modelica.SIunits.Velocity VelVen=0.2;

      constant Real Cb = 5.67 "black body constant";
      constant Real b = 0.82 "linearization fit";
      final parameter Real Meta = Met/Adu "Specific metabolic rate";

    protected
      Real Conv "convective surface coefficient";
      Real DTr4 "Linearized or not linearized radiative delta T^4";

    algorithm
    if Linear then
      DTr4 :=b*Cb/Modelica.Constants.sigma*(Tclo - Tair);
    else
      DTr4 :=(Tclo - Tair)*(Tclo + Tair)*(Tclo^2 + Tair^2);
    end if;

    if noEvent(65*(Tclo-Tair) > 21435.89*VelVen) then
      Conv :=2.38*(Tclo - Tair)^0.25;
    else
      Conv :=12.1*VelVen^0.5;
    end if;

    Tclo:=(35.7 - 0.028*Meta - RClo*(3.96*10^(-8)*CloFrac*DTr4 + CloFrac*Conv*(
        Tclo - Tair))) + 273.15;

      annotation (Diagram(graphics), Icon(graphics));
    end CloTemperature;
  end BaseClasses;
end Components;
