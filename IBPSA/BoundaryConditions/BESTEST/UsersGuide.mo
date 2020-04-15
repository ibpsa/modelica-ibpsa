within IBPSA.BoundaryConditions.BESTEST;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation(preferredView="info",
  Documentation(info="<html>
<p>The package <a href=\"modelica://IBPSA.BoundaryConditions.BESTEST.Validation\">IBPSA.BoundaryConditions.BESTEST.Validation</a> contains the models that were used for the BESTEST validation ASHRAE 2020 for weather data acquisition and postprocessing. Each model represents a different climate with different days as shown in the tables below. All examples have a script that runs the simulation according to the specifications and derive the required Json file as reported below. The weather radiation data has to be provided at different orientations and inclinations.</p>
<p><i>Table 2:&nbsp;</i>Azimuth and Slope for Surfaces</p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Azimuth</p></td>
<td><p>Slope</p></td>
</tr>
<tr>
<td><p>Horizontal</p></td>
<td><p>0&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>South</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>East</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>North</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>West</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>45&deg; East of South</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>45&deg; West of South</p></td>
<td><p>90&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>East</p></td>
<td><p>30&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>South</p></td>
<td><p>30&deg; from horizontal</p></td>
</tr>
<tr>
<td><p>West</p></td>
<td><p>30&deg; from horizontal</p></td>
</tr>
</table>
<p><i>Additional parameters and correlations</i></p>
<ul>
<li>Ground reflectance &rho; can be set to 0 or 0.</li>
<li>Black body temperature calculated using Horizontal radiation or dew point temperature and sky cover</li>
<li>Perez or Isoentropic sky model used</li>
</ul>
<h4>Outputs required</h4>
<p><i>Annual Outputs</i></p>
<p><b>&nbsp;</b>The following outputs shall be provided for an annual simulation:</p>
<ul>
<li>Average dry bulb temperature (&deg;C)</li>
<li>Average relative humidity (&percnt;)</li>
<li>Average dewpoint temperature (&deg;C)</li>
<li>Average humidity ratio (kg moisture/kg dry air)</li>
<li>Average wet bulb temperature (&deg;C)</li>
<li>Sum of total, beam, and diffuse solar radiation incident on each surface (Wh/m2)</li>
</ul>
<p><i>Hourly Outputs</i></p>
<p>The following outputs shall be provided for each hour of the days specified for each test case in Table 3:</p>
<ul>
<li>Dry bulb temperature (&deg;C)</li>
<li>Relative humidity (&percnt;)</li>
<li>Dewpoint temperature (&deg;C)</li>
<li>Humidity ratio (kg moisture/kg dry air)</li>
<li>Wet bulb temperature (&deg;C)</li>
<li>Windspeed (m/s)</li>
<li>Wind direction (degrees from north)</li>
<li>Station pressure (mbar)</li>
<li>Total cloud cover (tenths of sky)</li>
<li>Opaque cloud cover (tenths of sky)</li>
<li>Sky temperature (&deg;C)</li>
<li>Sum of total, beam, and diffuse solar radiation incident on each surface (Wh/m2)&nbsp;</li>
</ul>
<p><i>Table 3: Specific Days for Output</i></p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Case </p></td>
<td><p>Days</p></td>
</tr>
<tr>
<td><p>WD100 </p></td>
<td><p>May 4th, July 14th, September 6th</p></td>
</tr>
<tr>
<td><p>WD200 </p></td>
<td><p>May 24th, August 26th</p></td>
</tr>
<tr>
<td><p>WD300 </p></td>
<td><p>February 7th, August 13th</p></td>
</tr>
<tr>
<td><p>WD400 </p></td>
<td><p>January 24th, July 1st</p></td>
</tr>
<tr>
<td><p>WD500 </p></td>
<td><p>March 1st, September 14th</p></td>
</tr>
<tr>
<td><p>WD600 </p></td>
<td><p>May 4th, July 14th, September 6th</p></td>
</tr>
</table>
<p><i>Sub-hourly Outputs</i></p>
<p>The following outputs shall be provided at each timestep of the days specified for each test case in Table 3:</p>
<ul>
<li>Dry bulb temperature (C)</li>
<li>Relative humidity (&percnt;)</li>
<li>Sum of total, beam, and diffuse solar radiation incident on each surface (Wh/m2) </li>
</ul>
<p>The following outputs shall be provided integrated hourly for the days specified for each test case in Table 3:</p>
<ul>
<li>Total incident horizontal solar radiation (Wh/m2)</li>
<li>Total incident horizontal beam solar radiation (Wh/m2)</li>
<li>Total incident horizontal diffuse solar radiation (Wh/m2) </li>
</ul>
<h4>Validation results</h4>
<p>(Not available yet)</p>
<h4>Implementation</h4>
<p>To generate the data shown in this user guide, run </p>
<pre>
cd IBPSA/Resources/src/BoundaryConditions/Validation/BESTEST
python3 WeatherBESTEST.py
</pre>
<p>At the beginning of the Python script there are several options that the user can choose, by default the script will:
</p>
<ul>
<li>Clone the last master branch of the IBPSA repository into a temporary directory</li>
<li>Execute all the simulations and create the folders with the .mat and .json files inside the BESTEST/Simulations folder</li>
</ul>
<h4>References</h4>
<p>(Not available yet)</p>
</html>", revisions="<html>
</html>"));
end UsersGuide;
