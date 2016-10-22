within IDEAS.Buildings;
package UsersGuide "User's Guide"
extends Modelica.Icons.Information;




annotation (__Dymola_DocumentationClass=true, Documentation(info="<html>
<p>
The main goal of the IDEAS Buildings library is to set up models that allow simulating
building envelope models. These models may be coupled to
models from the Fluid or Electric packages.
In this user guide we outline the main principles of the library. 
</p>
<h4>Model physics</h4>
<p>
The main physical principles that are modelled in IDEAS are 
<ul>
<li>
interior and exterior convection, 
</li>
<li>
interior and exterior longwave radiation, 
</li>
<li>
interior and exterior shortwave radiation,
</li>
<li>
thermal conduction through surfaces,
</li>
<li>
window shading,
</li>
<li>
infiltration of air.
</li>
</ul>
</p>
<p>
</p>
Furthermore models for specifying additional boundary conditions are
<ul>
<li>
occupancy model for computing internal gains,
</li>
<li>
comfort model for computing thermal comfort.
</li>
</ul>
</p>
<p>
A qualitative description of these models can be found below. 
If you need to know the implementation then look
at the Modelica equation sections.
</p>
<p>
Interior convection</br>
Interior convection is modelled between surfaces
and the zone air volume. Correlations are
used to compute the heat flow rate from the temperature difference.
By default these correlations are non-linear but they may be linearised as well.</br>
Air cavities within walls are simulated using a correlation
that takes into account both radiative and convective heat transfer.
It is assumed that the cavity is not ventilated.
</p>
<p>
Exterior convection</br>
Exterior convection is modelled using a wind speed dependent correlation.
</p>
<p>
Interior longwave radiation</br>
Interior longwave radiation between surfaces may be modelled using two appraoches; 
either using an equivalent radiative star point or using view factors.
Longwave radiation equations are linearised by default to avoid
large non-linear algebraic loops. 
Computations using a fourth order equation may be enabled by setting 
<code>linIntRad=false</code> in the zone model.
Surface emissivities are taken into account in these computations.
The view factor implementation assumes the zone to have a rectangular geometry.
</p>
<p>
Exterior longwave radiation</br>
Exterior longwave radiation is simulated by computing heat exchange with a weighted temperature of
the outside air and the sky temperature.
The weighting factor depends on the surface orientation.
These equations are linear by default, but may be computed using a fourth order
equation using <code>linExtRad=false</code>.
</p>
<p>
Interior shortwave radiation</br>
Interior shortwave radiation occurs
whenever sun light enters the zone through a window.
We assume that the light always hits the floor. 
A fraction of the light, equal to the emissivity of the material,
will be absorbed. The remaining fraction is reflected within the 
zone and is absorbed by the remaining surfaces.
</p>
<p>
Exterior shortwave radiation</br>
Exterior shortwave radiation injects heat on
the outer surface of surfaces. 
The magnitude of this heat injection depends on the surface emissivity and orientation and
the weather conditions (direct and diffuse solar radiation). 
Surface shading by objects is currently not supported.
</p>
<p>
Thermal conduction</br>
Thermal conduction through solids is modelled using
a series discretisation of the wall.
</p>
<p>
Window shading</br>
A few models allow to compute the shading of windows.
These models limit the amount of direct or diffuse 
solar irradation hitting the window.
Long wave radiation computations are not affected.
</p>
<p>
Air infiltration</br>
Air infiltration is computed for each zone
independently, assuming a constant n50 value.
</p>
<h4>Typical use</h4>
<p>
siminfomanager
ideas structure
</p>
<h4>Examples</h4>
<p>
<a href=modelica://IDEAS.Buildings.Examples>IDEAS.Buildings.Examples</a>
contains examples that demonstrate several functionalities of the library.
<a href=modelia://IDEAS.Buildings.Components.Examples>IDEAS.Buildings.Components.Examples</a>
contains examples that focus more on the component level
and that are primarily used for unit test purposes.
These components often contain a 'Command' that runs the model and
shows some results.
</p>
<h4>Validation</h4>
<p>
IDEAS is validated using BESTEST. 
The validation models may be found in package
<a href=modelica://IDEAS.Buildings.Validation>IDEAS.Buildings.Validation</a>.
</p>
<h4>Unit tests</h4>
<p>
Many of the example models are unit tested. 
Developers use this to check model consistency
when model equations are changed.
</p>
</html>"));
end UsersGuide;
