within IBPSA.Fluid.Examples.Tutorial;
package SimpleHouse "Package with example for how to build a simple building envelope with a radiator heating system and ventilation system"
extends Modelica.Icons.ExamplesPackage;

  annotation (Documentation(info="<html>
<p>
This package contains examples with step-by-step instructions for how to build a system model
for a simple house with a heating system, ventilation, and weather boundary conditions.
It serves as a demonstration case of how the <code>IBPSA</code> library can be used.
</p>
<p>
A detailed description of how the system model can be built up can be found in
<a href=\"modelica://IBPSA.Resources.Documentation.Fluid.Examples.Tutorial.SimpleHouse\">
IBPSA.Resources.Documentation.Fluid.Examples.Tutorial.SimpleHouse</a>.
</p>
<p>
The model has been created in the following stages:
</p>
<ol>
<li>
<a href=\"modelica://IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouseTemplate\">
IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouseTemplate</a>
contains a weather data reader which connects the thermal resistance of the building wall
to the dry bulb temperature and serves as a template to implement the entire <code>SimpleHouse</code> model.
</li>
<li>
<a href=\"modelica://IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse1\">
IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse1</a>
implements the building wall by adding a thermal capacity.
</li>
<li>
<a href=\"modelica://IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse2\">
IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse2</a>
adds a window to the building wall.
It is assumed that the total injected heat through the window equals the window surface area
multiplied by the direct horizontal solar irradiance.
</li>
<li>
<a href=\"modelica://IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse3\">
IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse3</a>
adds an air model which represents the room in the building.
</li>
<li>
<a href=\"modelica://IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse4\">
IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse4</a>
adds heating circuit consisting of a boiler, a radiator, 
and an on/off circulation pump with a constant mass flow rate.
No controller is implemented yet, i.e. the pump and heater are always on.
</li>
<li>
<a href=\"modelica://IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse5\">
IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse5</a>
adds a hysteresis controller for the heating circuit that uses the room temperature as an input.
</li>
<li>
<a href=\"modelica://IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse6\">
IBPSA.Fluid.Examples.Tutorial.SimpleHouse.SimpleHouse6</a>
adds a ventilation system consisting of a fan, a damper, a heat recovery unit,
and a hysteresis controller, that allows to perform free cooling using outside air.
</li>
</ol>
</html>"));
end SimpleHouse;
