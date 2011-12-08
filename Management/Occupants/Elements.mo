within IDEAS.Management.Occupants;
package Elements

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

  block PredictedPercentageDissatisfied "predicted percentage of dissatisfied"

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
    outer Commons.SimInfoManager sim
      annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

    parameter Real CloWin = 0.9 "Clo value for winter conditions";
    parameter Real CloSum = 0.5 "Clo valie for summer conditions";

  equation
   if noEvent(sim.TeAv > 22 + 273.15) then
     RClo = 0.155*CloSum;
   else
     RClo = 0.155*CloWin;
   end if;

   if noEvent(RClo > 0.078) then
     CloFrac = 1.05 + 0.645*RClo;
   else
     CloFrac= 1.00 + 1.29*RClo;
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

  equation
  if Linear then
    DTr4 = b*Cb/Modelica.Constants.sigma*(Tclo-Tair);
  else
    DTr4 = (Tclo-Tair)*(Tclo+Tair)*(Tclo^2+Tair^2);
  end if;

  if noEvent(65*(Tclo-Tair) > 21435.89*VelVen) then
    Conv = 2.38*(Tclo-Tair)^0.25;
  else
    Conv = 12.1*VelVen^0.5;
  end if;

  Tclo=(35.7-0.028*Meta - RClo*(3.96*10^(-8)*CloFrac*DTr4+CloFrac*Conv*(Tclo-Tair)))+273.15;

    annotation (Diagram(graphics), Icon(graphics));
  end CloTemperature;
  annotation (             Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-100,-100},{80,50}},
          lineColor={175,175,175},
          fillColor={248,248,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,50},{-80,70},{100,70},{80,50},{-100,50}},
          lineColor={175,175,175},
          fillColor={248,248,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{100,70},{100,-80},{80,-100},{80,50},{100,70}},
          lineColor={175,175,175},
          fillColor={248,248,255},
          fillPattern=FillPattern.Solid)}));

end Elements;
