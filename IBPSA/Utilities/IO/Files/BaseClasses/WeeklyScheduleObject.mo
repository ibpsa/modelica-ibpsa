within IBPSA.Utilities.IO.Files.BaseClasses;
class WeeklyScheduleObject "Class that loads a weekly schedule"
extends ExternalObject;
  function constructor
    "Verify whether a file writer with  the same path exists and cache variable keys"
    extends Modelica.Icons.Function;
    input String fileName "Name of the file, including extension";
    input Real t_offset "";
    output WeeklyScheduleObject weeklySchedule "Pointer to the weekly schedule";
    external"C" weeklySchedule = weeklyScheduleInit(fileName, t_offset)
    annotation (
      Include="#include <WeeklySchedule.c>",
      IncludeDirectory="modelica://IBPSA/Resources/C-Sources");

    annotation(Documentation(info="<html>
<p>
</p>
</html>", revisions="<html>
c
</html>"));
  end constructor;

  function destructor "Release storage and close the external object, write data if needed"
    input WeeklyScheduleObject weeklySchedule "Pointer to file writer object";
    external "C" weeklyScheduleFree(weeklySchedule)
    annotation(Include=" #include <WeeklySchedule.c>",
    IncludeDirectory="modelica://IBPSA/Resources/C-Sources");
  annotation(Documentation(info="<html>
</html>"));
  end destructor;

annotation(Documentation(info="<html>
</html>",
revisions="<html>
<ul>
<li>
March 9 2022, by Filp Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end WeeklyScheduleObject;
