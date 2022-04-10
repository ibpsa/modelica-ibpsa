within IBPSA.Utilities.IO.Files.Examples;
model WeeklySchedule "Weekly schedule example"
  extends Modelica.Icons.Example;
  parameter String data = "double tab1(3,5) #test:
mon:0:0:10          -  3   1  -
tue,thu:20:30:59  123  -  45  -
wed                12  1   4  -" "Contents of schedule.txt";
  IBPSA.Utilities.IO.Files.WeeklySchedule weeklyScheduleFile(columns={2,3,4,5},
      fileName=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/Data/schedule.txt"),
    t_offset=1e6)
    "Weekly schedule example using file data source"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  IBPSA.Utilities.IO.Files.WeeklySchedule weeklyScheduleParameter(columns={2,3,4,5},
      tableOnFile=false,
    data=data,
    t_offset=1e6)
    "Weekly schedule example using parameter data source"
    annotation (Placement(transformation(extent={{-10,-32},{10,-12}})));
equation
  for i in 1:size(weeklyScheduleFile.y,1) loop
    assert(abs(weeklyScheduleFile.y[i]-weeklyScheduleParameter.y[i])< Modelica.Constants.small, "Consistency error between WeeklySchedule implementations");
  end for;
  annotation (
    Documentation(revisions="<html>
<ul>
<li>
April 10 2022, by Filip Jorissen:<br/>
Added parameter source implementation.
</li>
<li>
March 21 2022, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Example and consistency test for a weekly schedule.
</p>
</html>"),
    experiment(
      StartTime=-10000,
      StopTime=1000000,
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Utilities/IO/Files/Examples/WeeklySchedule.mos"
        "Simulate and plot"));
end WeeklySchedule;
