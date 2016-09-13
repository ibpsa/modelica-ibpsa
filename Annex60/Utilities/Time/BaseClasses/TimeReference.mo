within Annex60.Utilities.Time.BaseClasses;
// fixme: this should be in Annex60.Utilities.Time.Types.TimeReference
//        and maybe call it ZeroTime
type TimeReference = enumeration(
    UnixTimeStamp "Thu, 01 Jan 1970 00:00:00 GMT",
    Custom "User specified",
    NY2010 "New year 2010, 00:00:00 GMT",
    NY2011 "New year 2011, 00:00:00 GMT",
    NY2012 "New year 2012, 00:00:00 GMT",
    NY2013 "New year 2013, 00:00:00 GMT",
    NY2014 "New year 2014, 00:00:00 GMT",
    NY2015 "New year 2015, 00:00:00 GMT",
    NY2016 "New year 2016, 00:00:00 GMT",
    NY2017 "New year 2017, 00:00:00 GMT",
    NY2018 "New year 2018, 00:00:00 GMT",
    NY2019 "New year 2019, 00:00:00 GMT",
    NY2020 "New year 2020, 00:00:00 GMT")
  "Use this to set the date corresponding to time = 0"
  annotation (Documentation(info="<html>
<p>
Type for choosing how to set the reference time in
<a href=\"modelica://Annex60.Utilities.Time.CalendarTime\">
Annex60.Utilities.Time.CalendarTime</a>.
</p>
<p>
For example, <code>Annex60.Utilities.Time.BaseClasses.TimeReference.NY2016</code>
means that if the Modelica built-in variable <code>time=0</code>, it is
January 1, 2016, 0:00:00 GMT.
// fixme: We have a problem here: Suppose you model California. Then, time=0 is
//        midnight in California, and at t=12*3600 the sun is on the top. Hence,
//        it should be 0:00 in the local time zone, not in GMT.
</p>
</html>", revisions="<html>
<ul>
<li>
September 10, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
August 3, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
