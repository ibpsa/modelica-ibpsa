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
This type may be used to indicate to Modelica what it means if <code>time = 0</code>. 
I.e. this may mean that it is new year 2015, 
or that it is new year 1970 (corresponding to unix time stamp = 0). 
This reference is required when a data file does not start on new years day, 
or when the user needs to know what day of the week it is. 
</p>
</html>"));
