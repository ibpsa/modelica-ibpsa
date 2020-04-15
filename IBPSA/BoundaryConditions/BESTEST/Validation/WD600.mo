within IBPSA.BoundaryConditions.BESTEST.Validation;
model WD600 "Test model for BESTEST weather data: ground reflectance"
  extends WD100(lat= 0.6952170009469,  rho = 0.2, alt = 1650);
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br>First implementation.
</li>
<li>
April 14, 2020, by Ettore Zanetti:<br>Rework after comments from pull request
<a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1339\">#1339</a>.
</li>
</ul>
</html>", info="<html>
<h4>WD600: Ground Reflactance</h4>
<p>Weather data file : 725650.epw</p>
<p><i>Table 1: Site Data for Weather file 725650.epw</i></p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Latitude</p></td>
<td><p>39.833&deg; north</p></td>
</tr>
<tr>
<td><p>Longitude</p></td>
<td><p>104.65&deg; west</p></td>
</tr>
<tr>
<td><p>Altitude</p></td>
<td><p>1650 m</p></td>
</tr>
<tr>
<td><p>Time Zone</p></td>
<td><p>7</p></td>
</tr>
</table>
</html>"));
end WD600;
