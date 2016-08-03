within Annex60.BoundaryConditions.WeatherData.BaseClasses;
type WeekDay = enumeration(
    Monday "Monday",
    Tuesday "Tuesday",
    Wednesday "Wednesday",
    Thursday "Thursday",
    Friday "Friday",
    Saturday "Saturday",
    Sunday "Sunday",
    Undefined "Undefined") "Days of week"
  annotation (Documentation(info="<html>
<p>
This type may be used to indicate to Modelica what it means if <code>time = 0</code>. 
I.e. this may mean that it is new year 2015, 
or that it is new year 1970 (corresponding to unix time stamp = 0). 
This reference is required when a data file does not start on new years day, 
or when the user needs to know what day of the week it is. 
</p>
</html>"));
