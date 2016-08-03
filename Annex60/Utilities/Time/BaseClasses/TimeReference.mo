within Annex60.Utilities.Time.BaseClasses;
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
    NY2018 "New year 2018, 00:00:00 GMT")
  "Use this to set date corresponding to time = 0"
  annotation (Documentation(info="<html>
<p>
Type for choosing how to set the reference time in the CalendarTime block.
</p>
</html>", revisions="<html>
<ul>
<li>
August 3, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
