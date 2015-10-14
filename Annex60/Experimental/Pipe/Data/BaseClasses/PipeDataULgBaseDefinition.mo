within Annex60.Experimental.Pipe.Data.BaseClasses;
record PipeDataULgBaseDefinition
  "BaseClass for experimental data from the pipe test bench at University of Liege"
  extends Modelica.Icons.Record;
  parameter Real[:, 6] data
    "Time in s | Mass flow rate in kg/s | Outlet pipe temperature in °C | Outlet water temperature in °C | Inlet pipe temperature in °C | Inlet water temperature in °C |";
  annotation(Documentation(info="<html>
<p><b><span style=\"color: #008000;\">Overview</span></b> </p>
<p>Defines basic record of experimental data from ULg test bench</p>
<p>The test bench uses a pipe of approx. 39 m length.</p>
<p><br>Column 1: Time in s </p>
<p>Column 2: Mass flow rate in kg/s</p>
<p>Column 3: Outlet pipe temperature in C</p>
<p>Column 4: Outlet water temperature in C</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Column 5: Inlet pipe temperature in C</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Column 6: Inlet water temperature in C</span></p>
</html>",  revisions="<html>
<ul>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>"));
end PipeDataULgBaseDefinition;
