within IDEAS.Climate.Time;
block SimTimes

  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Angle lon(displayUnit="deg") = 4.317 "longitude";
  parameter Modelica.SIunits.Time delay(displayUnit="s") = 0
    "delay for solar data";
  parameter Modelica.SIunits.Time timZonSta=3600 "standard time zone";
  parameter Boolean DST=false "take into account daylight saving time";
  parameter Integer yr=2010 "depcited year for DST only";
  parameter Boolean ifSolCor=true;

  Modelica.Blocks.Interfaces.RealOutput timSol "solar time"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput timCal "calendar time"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Blocks.Interfaces.RealOutput timCalSol
    "calendar time for solar data"
    annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  Modelica.Blocks.Interfaces.RealOutput timLoc
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Blocks.Interfaces.BooleanOutput summer
    annotation (Placement(transformation(extent={{90,70},{110,90}})));

protected
  IDEAS.Climate.Time.BaseClasses.LocalTime localTime(lon=lon)
    annotation (Placement(transformation(extent={{-10,-6},{10,14}})));
  IDEAS.Climate.Time.BaseClasses.SolarTime solarTime
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  IDEAS.Climate.Time.BaseClasses.CalendarTime calendarTime(ifSolCor=ifSolCor)
    annotation (Placement(transformation(extent={{30,-54},{50,-34}})));
  IDEAS.Climate.Time.BaseClasses.SimulationTime simulationTime
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  IDEAS.Climate.Time.BaseClasses.SimulationDelay simulationDelay(delay=delay)
    annotation (Placement(transformation(extent={{-90,-58},{-70,-38}})));
  IDEAS.Climate.Time.BaseClasses.TimeZone timeZone(
    timZonSta=timZonSta,
    DST=DST,
    yr=yr) annotation (Placement(transformation(extent={{-50,-6},{-30,14}})));

equation
  connect(localTime.timLoc, solarTime.timLoc) annotation (Line(
      points={{10,4},{30,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solarTime.timSol, timSol) annotation (Line(
      points={{50,0},{100,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(calendarTime.timCal, timCal) annotation (Line(
      points={{50,-40},{100,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(calendarTime.timCalSol, timCalSol) annotation (Line(
      points={{50,-48},{60,-48},{60,-80},{100,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simulationDelay.timSim, calendarTime.delay) annotation (Line(
      points={{-70,-48},{30,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simulationTime.timSim, calendarTime.timSim) annotation (Line(
      points={{-70,-20},{-22,-20},{-22,-40},{30,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simulationTime.timSim, localTime.timSim) annotation (Line(
      points={{-70,-20},{-22,-20},{-22,0},{-10,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simulationTime.timSim, solarTime.timSim) annotation (Line(
      points={{-70,-20},{20,-20},{20,-4},{30,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timeZone.timZon, localTime.timZon) annotation (Line(
      points={{-30,4},{-22,4},{-22,8},{-10,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(calendarTime.timCal, timeZone.timCal) annotation (Line(
      points={{50,-40},{60,-40},{60,-26},{-56,-26},{-56,4},{-50,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(localTime.timLoc, timLoc) annotation (Line(
      points={{10,4},{20,4},{20,40},{100,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timeZone.summer, summer) annotation (Line(
      points={{-40,14},{-40,80},{100,80}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="timMan",
    Documentation(info="<html>
<p>
This component defines all required types of time in the simulation.
</p>
</html>
", revisions="<html>
<ul>
<li>
April 6, 2011, by Ruben Baetens:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-78,48},{74,-42}},
          lineColor={0,0,0},
          textString="time")}));
end SimTimes;
