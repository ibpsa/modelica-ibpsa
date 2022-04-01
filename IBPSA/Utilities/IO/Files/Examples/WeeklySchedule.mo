within IBPSA.Utilities.IO.Files.Examples;
model WeeklySchedule "Weekly schedule example"
  extends Modelica.Icons.Example;
  IBPSA.Utilities.IO.Files.WeeklySchedule weeklySchedule(
    columns={2,3,4,5},
    fileName=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/Data/schedule.txt"))
    "Weekly schedule example"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (
    Documentation(revisions="<html>
<ul>
<li>
March 21 2022, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StartTime=-10000,
      StopTime=1000000,
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Utilities/IO/Files/Examples/WeeklySchedule.mos"
        "Simulate and plot"));
end WeeklySchedule;
