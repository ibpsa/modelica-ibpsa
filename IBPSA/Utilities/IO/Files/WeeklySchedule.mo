within IBPSA.Utilities.IO.Files;
model WeeklySchedule "Weekly schedule"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Integer[:] columns
    "Columns to be loaded from file";
  parameter Boolean tableOnFile=true
    "= true, if table is defined on file or in function usertab"
    annotation(Dialog(group="Data source"));
  parameter String fileName = ""
    "Filename"
    annotation(Dialog(group="Data source",enable=tableOnFile));
  parameter String data = "double tab1(3,3)
wed 1 0
tue 0 1
sat 0 -"
    "String data"
    annotation(Dialog(group="Data source",enable=not tableOnFile));
  parameter Modelica.Units.SI.Time t_offset=0
    "Timestamp that corresponds to midnight from Sunday to Monday";

  Modelica.Blocks.Interfaces.RealOutput[n_columns] y=
    {getCalendarValue(cal, iCol-1, time) for iCol in columns} "Outputs"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  IBPSA.Utilities.IO.Files.BaseClasses.WeeklyScheduleObject cal=
      IBPSA.Utilities.IO.Files.BaseClasses.WeeklyScheduleObject(tableOnFile, sourceName, t_offset, data)
    "Schedule object";
protected
  parameter Integer n_columns = size(columns,1) "Number of columns";
  parameter String sourceName = if tableOnFile then fileName else getInstanceName() +".data";

  pure function getCalendarValue
    "Returns the interpolated (zero order hold) value"
    extends Modelica.Icons.Function;
    input IBPSA.Utilities.IO.Files.BaseClasses.WeeklyScheduleObject ID "Pointer to file writer object";
    input Integer iCol "Column index";
    input Real timeIn "Time for look-up";
    output Real y "Schedule value";
    external "C" y=getScheduleValue(ID, iCol, timeIn)
    annotation(Include="#include <WeeklySchedule.c>",
    IncludeDirectory="modelica://IBPSA/Resources/C-Sources");
  end getCalendarValue;

  annotation (
  defaultComponentName = "sch",
  experiment(
      StartTime=-10000,
      StopTime=1000000,
      Interval=100),
      Documentation(
        revisions="<html>
<ul>
<li>
April 10 2022, by Filip Jorissen:<br/>
Added parameter source implementation.
</li>
<li>
March 9 2022, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model interprets a schedule file and performs a weekly, cyclic extrapolation on the source data.
See <a href=\"modelica://IBPSA/Resources/Data/schedule.txt\">IBPSA/Resources/Data/schedule.txt</a> 
for an example of the supported file format.
</p>
</html>"));
end WeeklySchedule;
