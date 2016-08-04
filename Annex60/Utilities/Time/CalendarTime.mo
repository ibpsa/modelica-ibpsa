within Annex60.Utilities.Time;
model CalendarTime
  "Computes the unix time stamp and calendar time from the simulation time"
  extends Modelica.Blocks.Icons.Block;
  parameter Annex60.Utilities.Time.BaseClasses.TimeReference timRef;
  parameter Integer yearRef(min=firstYear, max=lastYear) = 2016
    "Year when time = 0"
    annotation(Dialog(enable=timRef==Annex60.Utilities.Time.BaseClasses.TimeReference.Custom));
  parameter Integer monthRef(min=1, max=12) = 1
    "Month when time = 0"
    annotation(Dialog(enable=timRef==Annex60.Utilities.Time.BaseClasses.TimeReference.Custom));
  parameter Integer dayRef(min=1, max=31) = 1
    "Day when time = 0"
    annotation(Dialog(enable=timRef==Annex60.Utilities.Time.BaseClasses.TimeReference.Custom));
  parameter Integer hourRef(min=0, max=23) = 0
    "Hour when time = 0"
    annotation(Dialog(enable=timRef==Annex60.Utilities.Time.BaseClasses.TimeReference.Custom));
  parameter Integer minuteRef(min=0, max=59) = 0
    "Minute when time = 0"
    annotation(Dialog(enable=timRef==Annex60.Utilities.Time.BaseClasses.TimeReference.Custom));
  parameter Integer secondRef(min=0, max=59) = 0
    "Second when time = 0"
    annotation(Dialog(enable=timRef==Annex60.Utilities.Time.BaseClasses.TimeReference.Custom));

  Modelica.Blocks.Interfaces.RealInput tim "Simulation time"
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));
  Modelica.Blocks.Interfaces.RealOutput unixTimeStamp
    "Unix time stamp at GMT+0"
        annotation (Placement(transformation(extent={{96,-70},{116,-50}})));
  discrete Modelica.Blocks.Interfaces.IntegerOutput year "Year"
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  discrete Modelica.Blocks.Interfaces.IntegerOutput month "Month of the year"
    annotation (Placement(transformation(extent={{96,10},{116,30}})));
  Modelica.Blocks.Interfaces.IntegerOutput day "Day of the month"
    annotation (Placement(transformation(extent={{96,30},{116,50}})));
  Modelica.Blocks.Interfaces.IntegerOutput hour "Hour of the day"
    annotation (Placement(transformation(extent={{96,50},{116,70}})));
  Modelica.Blocks.Interfaces.RealOutput minute "Minute of the hour"
    annotation (Placement(transformation(extent={{96,70},{116,90}})));
  Modelica.Blocks.Interfaces.IntegerOutput weekDayInt
    "Integer output representing week day (monday = 1, sunday = 7)"
    annotation (Placement(transformation(extent={{96,-30},{116,-10}})));

protected
  parameter Modelica.SIunits.Time timOff(fixed=false) "Time offset";
  constant Integer firstYear = 2010
    "First year that is supported, i.e. the first year in timeStampsNewYear[:]";
  constant Integer lastYear = firstYear + size(timeStampsNewYear,1) - 1;
  constant Real timeStampsNewYear[12] = {1262304000, 1293840000, 1325376000, 1356998400, 1388534400, 1420070400, 1451606400, 1483228800, 1514764800, 1546300800, 1577836800, 1609459200}
    "Epoch time stamps for new years day 2010 to 2021";
  constant Boolean isLeapYear[11] = {false, false, true, false, false, false, true, false, false, false, true}
    "List of leap years starting from firstYear (2010), up to 2020";
  constant Integer dayInMonth[12] = {31, 28, 31, 30, 31,30, 31,31, 30, 31, 30, 31}
    "Number of days in each month";
  Integer daysSinceEpoch
    "Number of days that passed since 1st of january 1970";
  discrete Integer yearIndex
    "Index of the current year in timeStampsNewYear";
  discrete Real epochLastMonth
    "Unix time stamp of the beginning of the current month";

initial algorithm
  // check if yearRef is in the valid range
  assert(not timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom
         or yearRef>=firstYear and yearRef<=lastYear,
    "\nThe value you chose for yearRef (=" + String(yearRef) + ") is outside of the validity range of " + String(firstYear) + " to " + String(lastYear) + "!\n");
  // check if the day number exists for the chosen month and year
  assert(not timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom
         or dayInMonth[monthRef] + (if monthRef==2 and isLeapYear[yearRef-firstYear + 1] then 1 else 0) >=dayRef,
    "The day number you chose is larger than the number of days contained by the month you chose!");

  // compute the offset to be added to time based on the parameters specified by the user
  if timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.UnixTimeStamp then
    timOff :=0;
  elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.NY2010 or timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef == 2010 then
    timOff :=timeStampsNewYear[1];
  elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.NY2011 or timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef == 2011 then
    timOff :=timeStampsNewYear[2];
  elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.NY2012 or timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef == 2012 then
    timOff :=timeStampsNewYear[3];
  elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.NY2013 or timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef == 2013 then
    timOff :=timeStampsNewYear[4];
  elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.NY2014 or timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef == 2014 then
    timOff :=timeStampsNewYear[5];
  elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.NY2015 or timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef == 2015 then
    timOff :=timeStampsNewYear[6];
  elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.NY2016 or timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef == 2016 then
    timOff :=timeStampsNewYear[7];
  elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.NY2017 or timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef == 2017 then
    timOff :=timeStampsNewYear[8];
  elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.NY2018 or timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef == 2018 then
    timOff :=timeStampsNewYear[9];
  elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.NY2018 or timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef == 2019 then
    timOff :=timeStampsNewYear[10];
  elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.NY2018 or timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef == 2020 then
    timOff :=timeStampsNewYear[11];
  else
    timOff :=0;
    // this code should not be reachable
    assert(false, "No valid TimeReference could be identified! This is a bug, please submit a bug report for the CalendarTime model.");
  end if;

  // add additional offset when using a custom date and time
  if timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom then
    timOff :=timOff + ((dayRef - 1) + sum({dayInMonth[i] for i in 1:(monthRef - 1)})
     + (if monthRef > 2 and isLeapYear[yearRef - firstYear + 1] then 1 else 0))*3600*24 +
    3600*hourRef + 60*minuteRef + secondRef;
  end if;


   // input data range checks at initial time
  assert(tim + timOff >= timeStampsNewYear[1],
    if timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.UnixTimeStamp then
      "\nCould initialise date in the CalendarTime block. \nYou selected 1970 as the time=0 reference. \nTherefore the simulation startTime must be at least " + String(timeStampsNewYear[1]) + "!\n"
    elseif timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom then
      if yearRef <firstYear then
        "\nCould not initialise date in the CalendarTime block. \nYou selected a custom time=0 reference. \nThe minimum value for yearRef is then " + String(firstYear) + " but your value is " + String(yearRef) + "!\n"
      else
        "\nCould not initialise date in the CalendarTime block. \nYou selected a custom time=0 reference. \nPossibly your startTime is too small.\n"
    else  "Could not initialise date in the CalendarTime block. \nPossibly your startTime is negative?");
  assert(tim + timOff < timeStampsNewYear[size(timeStampsNewYear,1)],
    if timRef == Annex60.Utilities.Time.BaseClasses.TimeReference.Custom and yearRef >= lastYear then
      "\nCould not initialise date in the CalendarTime block. \nYou selected a custom time=0 reference. \nThe maximum value for yearRef is then " + String(lastYear) + " but your value is " + String(yearRef) + "!\n"
    else "\nCould not initialise date in the CalendarTime block. \nPossibly your startTime is too large.\n");

  // iterate to find the year at initialisation
  year :=0;
  for i in 1:size(timeStampsNewYear,1) loop
    if unixTimeStamp < timeStampsNewYear[i] then
      yearIndex :=i - 1;
      year :=firstYear + i - 2;
      break;
    end if;
  end for;

  // iterate to find the month at initialisation
  epochLastMonth := timeStampsNewYear[yearIndex];
  for i in 1:12 loop
    if (unixTimeStamp-epochLastMonth)/3600/24 <  (if i==2 and isLeapYear[yearIndex] then 1 + dayInMonth[i] else dayInMonth[i]) then
      month :=i;
      break;
    else
      epochLastMonth :=epochLastMonth + (if i == 2 and isLeapYear[yearIndex]
         then 1 + dayInMonth[i] else dayInMonth[i])*3600*24;
    end if;
  end for;

equation
  // compute unix time step based on found offset
  unixTimeStamp = tim + timOff;

  // update the year when passing the epoch time stamp of the next year
  when (unixTimeStamp > timeStampsNewYear[pre(yearIndex)+1]) then
    yearIndex=pre(yearIndex)+1;
    assert(yearIndex<=size(timeStampsNewYear,1), "Overflow of epoch buffer: timeStampsNewYear needs to be extended beyond the year " + String(firstYear+size(timeStampsNewYear,1)));
    year = pre(year) + 1;
  end when;
  // update the month when passing the last day of the current month
  when unixTimeStamp - pre(epochLastMonth) > (if pre(month)==2 and isLeapYear[yearIndex] then 1 + dayInMonth[pre(month)] else dayInMonth[pre(month)])*3600*24 then
    month = if pre(month) == 12 then 1 else pre(month) + 1;
    epochLastMonth = pre(epochLastMonth) + (if pre(month)==2 and isLeapYear[yearIndex] then 1 + dayInMonth[pre(month)] else dayInMonth[pre(month)])*3600*24;
  end when;

  // compute other variables that can be computed without generating when() statements
  daysSinceEpoch = integer(floor(unixTimeStamp/3600/24));
  weekDayInt=rem(4+daysSinceEpoch-1,7)+1;
  day = integer(1+floor((unixTimeStamp-epochLastMonth)/3600/24));
  hour = integer(floor(rem(unixTimeStamp,3600*24)/3600));
  // using Real variables and operations for minutes since otherwise too many events are generated
  minute = (unixTimeStamp-daysSinceEpoch*60*24-hour*60);

  annotation (Documentation(revisions="<html>
<ul>
<li>
August 3, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<p>
This blocks computes the unix time stamp, date and time 
and the day of the week based on the Modelica
variables <code>time</code>.
Parameters need to be provided such that these computations are done correctly.
The block currently contains support for the calendar of 2010 up to 2020.
Day light saving time is currently not supported.
</p>
<h4>Main equations</h4>
<p>
First the unix time stamp corresponding to the current time is computed.
From this variables the corresponding, year, date and time are computed using functions
such as <code>floor()</code>, <code>ceil()</code> etc.
</p>
<h4>Assumption and limitations</h4>
<p>
The implementation currently only supports simulations from year 2010 up to 2020.
Day light saving and time zones are currently not supported.
</p>
<h4>Typical use and important parameters</h4>
<p>
The user must define which time and date correspond to <code>time = 0</code>
using the model parameters.
The user can choose from new year, midnight from a number of years, or define a custom date and time.
</p>
<h4>Implementation</h4>
<p>
The model was implemented such that no events are being generated for computing what minute of the day it is.
</p>
"));
end CalendarTime;
