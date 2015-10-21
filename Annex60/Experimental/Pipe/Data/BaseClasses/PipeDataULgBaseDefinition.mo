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
<p><b><span style=\"color: #008000;\">Pipe characteristics</span></b> </p>
<ul>
<li>Metal density about 7800 kg/m³</li>
<li>Specific heat capacity about 480 J/kg/K</li>
<li>Thickness 3.91 mm</li>
<li>Inside diameter: 0.05248 m</li>
<li>Roughness is currently neglected</li>
<li>Initial temperature of the pipe is considered equal to the initial temperature of the water (cooliing before test)</li>
<li>Heat transfer coefficient between the pipe and the ambient is assumed at 5 W/m²/K (from internal model) due to insulation</li><!-- TODO find again the insulation thickness and the thermal conductivity-->
<li>Heat transfer coefficient between water and pipe is a function of the fluid temperature (determined by EES software)</li>
</ul>
<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/ULgTestBench.png\" border=\"1\"/></p>
<p>Notice: length are approximative</p>
<p><b><span style=\"color: #008000;\">Test procedure</span></b> </p>
<p>Before to perform a test, the water city network is pushed inside the studied pipe during about 10 minutes to be sure that it is at the same temperature. During this time period, valves V3 and V1 are opened, the boiler is off and the valve V2 is closed.
Then, the valve V1 is closed and the valve V2 and V3 are opened. The boiler is started to reach the setpoint hot water temperature. When the temperature setpoint is achieved, the valve V1 is opened and the valve V2 is closed at the same time to supply the studied pipe in hot water.
After the outlet pipe temperature is stabilized, the boiler is shut off.</p>
</html>",  revisions="<html>
<ul>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add documentation about the test bench and how is conducted the experiment
</li>
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
