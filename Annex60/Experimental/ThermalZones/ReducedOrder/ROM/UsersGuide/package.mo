within Annex60.Experimental.ThermalZones.ReducedOrder.ROM;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;


annotation (Documentation(info="<html>
  <p>The <code>Annex60.ThermalZones.ReducedOrder.ROM</code> package contains 
  models for reduced building physics of thermal zones, reduced by means of 
  number of wall elements and number of RC-elements per wall (and by means of 
  spatial discretization). Such a reduction leads to a reduced order by means 
  of state variables. Reduced order models are commonly used when simulating 
  multiple buildings (e.g. on district scale) or for model predictive control, 
  where simulation speed outweighs high dynamic accuracy. However, you can 
  choose between models with one to four wall elements and you can define the 
  number of RC-elements per wall for each wall (by defining 
  <i>n<sub>k </i></sub>, which is the length of the vectors for resistances 
  <i>R<sub>k</i></sub> and capacitances <i>C<sub>k</i></sub>).</p>
  <p>All models within this package are based on thermal networks and use chains 
  of thermal resistances and capacitances to reflect heat transfer and heat 
  storage. Thermal network models generally focus on one-dimensional heat 
  transfer calculations. A geometrically correct representation of all walls of 
  a thermal zone is thus not mandatory. To reduce simulation effort, it is 
  furthermore reasonable to aggregate walls to representative elements with 
  similar thermal behaviour. Which number of wall elements is sufficient depends
  on the thermal properties of the walls and their excitation (e.g. through 
  solar radiation), in particular on the excitation frequencies. The same 
  applies for the number of RC-elements per wall.</p>
  <p>For multiple buildings, higher accuracy (by higher discretization) can come 
  at the price of significant computational overhead. Furthermore, the achieved 
  accuracy is not necessarily higher in all cases. For cases in which only 
  little input data is available, the increased discretization sometimes only 
  leads to a pseudo-accuracy based on large uncertainties in data acquisition.</p>
  <p>The architecture of all models within this package is defined in the German 
  Guideline VDI 6007 Part 1 (VDI, 2012). This guideline describes a dynamic 
  thermal building models for calculations of indoor air temperatures and 
  heating/cooling power.</p>
<h4>Architecture</h4>
<p>Each wall element uses either 
<a href=\"Annex60.Experimental.ThermalZones.ReducedOrder.ROM.BaseClasses.ExtMassVarRC\">ExtMassVarRC</a> 
or <a href=\"Annex60.Experimental.ThermalZones.ReducedOrder.ROM.BaseClasses.IntMassVarRC\">IntMassVarRC</a> 
to describe heat conduction and storage within the wall, depending if the wall 
contributes to heat transfer to the outdoor environment (exterior walls) or can 
be considered as simple heat storage elements (interior walls). The number of 
RC-elements per wall is hereby up to the user. All exterior walls and windows 
provide a heat port to the outside. All wall elements (exterior walls, windows 
and interior walls) are connected via 
<a href=\"Modelica.Thermal.HeatTransfer.Components.Convection\">convective heat exchange</a> 
to the convective network and the indoor air.</p>
<p>Heat transfer through windows and solar radiation transmission are handled 
seperately to each other. One major difference in the implementations in this 
package compared to the guideline is an additional element for heat transfer 
through windows, which are lumped with exterior walls in the guideline VDI 6007 
Part 1 (VDI, 2012). The heat transfer element for the windows facilitates no 
thermal capacity as windows are often regarded as mass-free. For that, it is 
not necessary to discretize the window element and heat conduction is simply 
handled by a thermal resistance. Merging windows and exterior walls lead to a 
virtual capacitance for the windows and result in a shifted reaction of the room 
temperature to environmental impacts (Lauster, Bruentjen <i>et al.</i>, 2014). 
However, the user is free to choose whether keeping windows seperately 
(<code>AWin</code>) or merging them (<code>AExt=AExterior+AWindows, AWin=0</code>). 
Transmission of solar radiation through windows is split up into two parts. 
One part is connected to the indoor radiative heat exchange mesh network using 
a <a href=\"Annex60.Experimental.ThermalZones.ReducedOrder.ROM.BaseClasses.ThermSplitter\">ThermSplitter</a> 
while the other part is directly linked to the convective network. The split 
factor <code>ratioWinConRad </code> is a window property and depends on the 
glazing and used materials. For solar radiation through windows, the area 
<code>ATransparent </code> is used. In most cases, this should be equal to 
<code>AWin</code>, but there might be cases (e.g. windows are lumped with 
exterior walls and solar radiation is present) where e.g. <code>AWin </code> is 
equal to zero and <code>ATransparent </code> is equal to the actual window area.</p>
<p>Regarding indoor radiative heat exchange, a couple of design decisions 
simplify modelling as well as the system&apos;s numerics:</p>
<ul>
<li>Instead of using Stefan&apos;s Law for radiation exchange 
(<code>Q=&epsilon;&sigma;(T<sub>1<sup>4</sub></sup>-T<sub>2<sup>4</sub></sup>)</code>), 
the models use a linearized approach 
(<code>Q=&alpha;<sub>rad</sub>(T<sub>1</sub>-T<sub>2</sub>)</code>), 
introducing <code>alpharad</code>, often set according to:
<code>&alpha;<sub>rad</sub>=4&epsilon;&sigma;T<sub>m<sup>3 </sup></code>with <i>T<sub>m</i></sub> 
being a mean constant temperature of the interacting surfaces.</li>
<li>Indoor radiation exchange is modelled using a mesh network, each wall is 
linked via one resistance with each other wall. Alternatively, one could use a 
star network, where each wall is connected via a resistance to a virtual 
radiation node. However, for cases with more than three elements and a linear 
approach, a mesh network cannot be transformed to a star network without 
introducing deviations.</li>
<li>Although internal as well as external gains count as simple heat flows, 
solar radiation uses a real input, while internal gains utilize two heat ports, 
one for convective and one for radiative gains. Considering solar radiation 
typically requires several models upstream to calculate angle-dependent 
irradiation or window models. We decided to keep that seperately to the thermal 
zone model. Thus, solar radiation is handled as a basic 
<code>RadiantEnergyFluenceRate</code>. For internal gains, the user might need 
to distinguish between convective and radiative heat sources.</li>
<li>For an exact consideration, each element participating at radiative heat 
exchange need to have a temperature and an area. For solar radiation and 
radiative internal gains, it is common to define the heat flow independently of 
temperature and thus of area as well, assuming that that the temperature of the 
source is high compared to the wall surface temperatures. By using a 
<a href=\"Annex60.Experimental.ThermalZones.ReducedOrder.ROM.BaseClasses.ThermSplitter\">ThermSplitter</a> 
that distributes the heat flow of the source over the walls according to their 
area, we support this simplified approach.</li>
</ul>
<h4>Typical use and important parameter</h4>
<p>The models in this package are typically used in combination with models from 
the superior <a href=\"Annex60.Experimental.ThermalZones.ReducedOrder\">ReducedOrder</a> 
package. A typical application is one building out of a large building stock for 
which the heating and cooling power over a year in hourly time steps should be 
calculated and is afterwards aggregated to the building stock&apos;s overall 
heating power (Lauster, Teichmann <i>et al.</i>, 2014; Lauster <i>et al.</i>, 2015).</p>
<p>Important parameter:</p>
<p><code>n...</code> defines the length of chain of RC-elements per wall.</p>
<p><code>R...[n]</code> is the vector of resistances for the wall element. It 
moves from indoor to outdoor.</p>
<p><code>C...[n]</code> is the vector of capacities for the wall element. It 
moves from indoor to outdoor.</p>
<p><code>R...Rem</code> is the remaining resistance between <code>C[end]</code> 
and outdoor surface of wall element. This resistance can be used to ensure that 
the sum of all resistances and coefficients of heat transfer equals the U-Value. 
It represents the part of the wall that cannot be activated and thus does not 
take part at heat storage.</p>
<p><code>IndoorPort...</code> adds an additional heat port to the indoor surface 
of the wall element if set to <code>true</code>. It can be used to add heat 
loads directly to a specific surface or to connect components that distribute 
radiation and have a specific surface temperature, e.g. a floor heating.</p>
<h4>References</h4>
<p>VDI. German Association of Engineers Guideline VDI 6007-1 March 2012. 
Calculation of transient thermal response of rooms and buildings - modelling of 
rooms.</p>
<p>M. Lauster, A. Bruentjen, H. Leppmann, M. Fuchs, R. Streblow, D. Mueller. 
<a href=\"modelica://Annex60/Resources/Images/Experimental/ThermalZones/ReducedOrder/ROM/UsersGuide/BauSIM2014_208-2_p1192.pdf\">Improving a Low Order Building Model for Urban Scale Applications</a>. 
<i>Proceedings of BauSim 2014: 5th German-Austrian IBPSA Conference</i>, 
p. 511-518, Aachen, Germany. Sep. 22-24, 2014.</p>
<p>M. Lauster, J. Teichmann, M. Fuchs, R. Streblow, D. Mueller. Low Order 
Thermal Network Models for Dynamic Simulations of Buildings on City District 
Scale. <i>Building and Environment</i>, 73, 223-231, 2014. 
<a href=\"http://dx.doi.org/10.1016/j.buildenv.2013.12.016\">doi:10.1016/j.buildenv.2013.12.016</a></p>
<p>M. Lauster, M. Fuchs, M. Huber, P. Remmen, R. Streblow, D. Mueller. 
<a href=\"modelica://Annex60/Resources/Images/Experimental/ThermalZones/ReducedOrder/ROM/UsersGuide/p2241.pdf\">Adaptive Thermal Building Models and Methods for Scalable Simulations of Multiple Buildings using Modelica</a>. 
<i>Proceedings of BS2015: 14th Conference of International Building Performance 
Simulation Association</i>, p. 339-346, Hyderabad, India. Dec. 7-9, 2015. </p>
</html>"));
end UsersGuide;
