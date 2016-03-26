within Annex60.Experimental.ThermalZones.ReducedOrder.EqAirTemp;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;


annotation (Documentation(info="<html>
  <p>Annex60.ThermalZones.ReducedOrder.EqAirTemp package contains models for 
  calculating an equivalent air temperature. There are two common ways to 
  consider solar radiation hitting exterior surfaces. One way is to consider 
  the resulting heat load at the wall&apos;s capacitance. The other way is to 
  add correction terms to the outdoor air temperature. The <code>EqAirTemp</code> 
  models follow the second approach, that is for example described in the German 
  Guideline VDI 6007 Part 1 (VDI, 2012). The influence of indoor temperatures 
  via heat transfer through exterior walls is neglected. The exterior wall&apos;s 
  outdoor surface is assumed to have the outdoor air temperature for calculation 
  of radiative heat exchange with the ambient.</p>
<p>The fundamental equation is: </p>
<p align=\"center\"><i>&thetasym;<sub>EqAirExt</sub> = &thetasym;
<sub>AirAmb</sub>+&Delta;&thetasym;<sub>EqLW</sub>+&Delta;&thetasym;
<sub>EqSW</sub> </i></p>
<p>The correction term for long-wave radiation is based on black body sky 
temperature and dry bulb temperature:</p>
<p align=\"center\"><i>&Delta;&thetasym;<sub>EqLW</sub> = 
(&thetasym;<sub>BlaSky</sub>-&thetasym;<sub>DryBul</sub>) 
&epsilon;<sub>Ext </sub>&alpha;<sub>Rad</sub>/
(&alpha;<sub>Rad</sub>+&alpha;<sub>Ext</sub>)</i></p>
<p>If a sunblind is present, the current status (closed - 1/open - 0) is 
considered by multiplying the long-wave correction terms for windows with the 
status variable minus one. The sunblind status is defined per orientation.</p>
<p>The correction term for short-wave radiation does not count for windows and 
is calculated with the help of the solar radiation for the specific orientations:</p>
<p align=\"center\"><i>&Delta;&thetasym;<sub>EqSW</sub> = H<sub>Sol 
</sub>a<sub>Ext</sub>/(&alpha;<sub>Rad</sub>+&alpha;<sub>Ext</sub>)</i></p>
<p><br>With the equations above, one equivalent air temperature per orientation 
and wall or window is calculated. These equivalent air temperatures are then 
aggregated weighting each entry with a weightfactor. In this part, constant 
temperatures of ground coupled elements or adjacent rooms can be considered. 
The sum of weightfactor per calculated equivalent air temperature should be one.
If you consider two equivalent air temperatures, one for walls and one for 
windows, the sum of weightfactors should be one per category. In the given case,
the weightfactors are calculated with the U-value and area of the concerned wall
elements:</p>
<p align=\"center\"><i>WeighFac<sub>i</sub> = 
U<sub>i </sub>A<sub>i</sub>/&Sigma;U<sub>i </sub>A<sub>i</i></sub></p>
<p>More information about this topic can be found in Lauster <i>et al</i> . 
(2014).</p>
<h4>References</h4>
<p>VDI. German Association of Engineers Guideline VDI 6007-1 March 2012. 
Calculation of transient thermal response of rooms and buildings - modelling of 
rooms.</p>
<p>M. Lauster, P. Remmen, M. Fuchs, J. Teichmann, R. Streblow, D. Mueller. 
Modelling long-wave radiation heat exchange for thermal network building 
simulations at urban scale using Modelica. <i>Proceedings of the 10th 
International Modelica Conference</i>, p. 125-133, Lund, Sweden. Mar. 10-12, 
2014. <a href=\"http://dx.doi.org/10.3384/ECP14096125\">doi:10.3384/ECP14096125</a></p>
</html>"));
end UsersGuide;
