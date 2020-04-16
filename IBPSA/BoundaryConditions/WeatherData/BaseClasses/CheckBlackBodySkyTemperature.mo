within IBPSA.BoundaryConditions.WeatherData.BaseClasses;
block CheckBlackBodySkyTemperature
  "Check the validity of the black-body sky temperature data"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.Temperature TMin(displayUnit="degC") = 203.15
    "Minimum allowed temperature";
  parameter Modelica.SIunits.Temperature TMax(displayUnit="degC") = 343.15
    "Maximum allowed temperature";

  Modelica.Blocks.Interfaces.RealInput TIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Black-body sky temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

equation
  assert(noEvent(TIn > TMin and TIn < TMax),
    "In " + getInstanceName() + ": Weather data black-body sky temperature out of bounds.\n" + "   TIn = " +
     String(TIn));

  annotation (
    defaultComponentName="cheSkyBlaBodTem",
    Documentation(info="<html>
<p>
This component checks the value of the black-body sky temperature.
If the temperature is outside <code>TMin</code> and <code>TMax</code>,
the simulation will stop with an error.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Added <code>noEvent</code> and removed output connector.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1340\">#1340</a>.
</li>
<li>
January 31, 2020 by Filip Jorissen:<br/>
Improved error message.
</li>
<li>
January 5, 2015 by Michael Wetter:<br/>
First implementation, based on
<a href=\"modelica://IBPSA.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature\">
IBPSA.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature</a>.
This was implemented to get the corrected documentation string in the weather bus connector.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{56,12},{-68,-16}},
          lineColor={0,0,0},
          textString="TSkyBlaBod")}));
end CheckBlackBodySkyTemperature;
