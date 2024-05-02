within IBPSA.ThermalZones.ISO13790.Validation.BESTEST;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation(preferredView="info",
  Documentation(info="<html>
<p>
The package <a href=\"modelica://IBPSA.ThermalZones.ISO13790.Validation.BESTEST\">
IBPSA.ThermalZones.ISO13790.Validation.BESTEST</a> contains the models
that were used for the BESTEST validation (ANSI/ASHRAE 2020).
</p>
<p>
All examples have a script that runs an annual simulation and
plots the results with the minimum, mean and maximum value
listed in the ANSI/ASHRAE Standard 140-2020.
</p>
<p>
The script compares the following quantities:
</p>
<ul>
<li>
For free floating cases, the annual hourly integrated minimum (and maximum)
zone air temperature, and the annual mean zone air temperature.
</li>
<li>
For cases with heating and cooling, the annual heating and cooling energy,
and the annual hourly integrated minimum (and maximum) peak heating and cooling power.
</li>
</ul>
<h4>Implementation</h4>
<p>
Heating and cooling is controlled using the PI controller
<a href=\"modelica://IBPSA.Controls.Continuous.LimPID\">
IBPSA.Controls.Continuous.LimPID</a>.
</p>
<p>
Hourly averaged values and annual mean values are computed using an instance of
<a href=\"modelica://IBPSA.Utilities.Math.MovingAverage\">
IBPSA.Utilities.Math.MovingAverage</a>.
</p>
<h4>Validation results</h4>
<p>
The data used for validation are from \"RESULTS5-2A.xlsx\" in folder \"/Sec5-2AFiles/Informative Materials\"
of <a href=\"http://www.ashrae.org/140-2020/\">Supplemental Files for ANSI/ASHRAE Standard 140-2020,
Method of Test for Evaluating Building Performance Simulation Software</a>.
</p>

<h5>Heating and cooling cases</h5>
<p>
The simulations of cases with heating and cooling are validated by comparing the
annual heating and cooling energy, the peak heating and cooling demand with the validation
data. In addition, one day load profiles are also validated.
The detailed comparison, which also shows the peak load hours, are shown
in the table after the plots below.
</p>

<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/annual_cooling.png\"
     alt=\"annual_cooling.png\" />
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/annual_heating.png\"
     alt=\"annual_heating.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/peak_cooling.png\"
     alt=\"peak_cooling.png\" />
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/peak_heating.png\"
     alt=\"peak_heating.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/hourly_load_600_Feb1.png\"
     alt=\"hourly_load_600_Jan4.png\" />
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/hourly_load_900_Feb1.png\"
     alt=\"hourly_load_900_Jan4.png\" />
</p>
<!-- table start: load data -->
<table border = \"1\" summary=\"Annual load\">
<tr><td colspan=\"10\"><b>Annual heating load (MWh)</b></td></tr>
<tr>
<th>Case</th>
<th>Lower limit</th>
<th>Upper limit</th>
<th>BSIMAC</th>
<th>CSE</th>
<th>DeST</th>
<th>EnergyPlus</th>
<th>ESP-r</th>
<th>TRNSYS</th>
<th>ISO13790</th>
</tr><tr>
<td>Case600</td>
<td>3.75</td>
<td>4.98</td>
<td>4.05</td>
<td>3.993</td>
<td>4.047</td>
<td>4.324</td>
<td>4.362</td>
<td>4.504</td>
<td>4.658</td>
</tr>
<tr>
<td>Case610</td>
<td>3.61</td>
<td>5.27</td>
<td>4.163</td>
<td>4.066</td>
<td>4.144</td>
<td>4.375</td>
<td>4.527</td>
<td>4.592</td>
<td>4.784</td>
</tr>
<tr>
<td>Case620</td>
<td>3.67</td>
<td>5.38</td>
<td>4.37</td>
<td>4.094</td>
<td>4.297</td>
<td>4.485</td>
<td>4.514</td>
<td>4.719</td>
<td>4.824</td>
</tr>
<tr>
<td>Case630</td>
<td>3.69</td>
<td>6.12</td>
<td>4.923</td>
<td>4.356</td>
<td>4.677</td>
<td>4.784</td>
<td>5.051</td>
<td>5.139</td>
<td>5.097</td>
</tr>
<tr>
<td>Case640</td>
<td>1.58</td>
<td>3.76</td>
<td>2.682</td>
<td>2.403</td>
<td>2.619</td>
<td>2.662</td>
<td>2.654</td>
<td>2.653</td>
<td>2.898</td>
</tr>
<tr>
<td>Case650</td>
<td>0.00</td>
<td>0.00</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
<td>0.0</td>
</tr>
<tr>
<td>Case900</td>
<td>1.04</td>
<td>2.28</td>
<td>1.726</td>
<td>1.379</td>
<td>1.591</td>
<td>1.664</td>
<td>1.585</td>
<td>1.814</td>
<td>1.833</td>
</tr>
<tr><td colspan=\"10\"><b>Annual cooling load (MWh)</b></td></tr>
<tr>
<th>Case</th>
<th>Lower limit</th>
<th>Upper limit</th>
<th>BSIMAC</th>
<th>CSE</th>
<th>DeST</th>
<th>EnergyPlus</th>
<th>ESP-r</th>
<th>TRNSYS</th>
<th>ISO13790</th>
</tr><tr>
<td>Case600</td>
<td>5.00</td>
<td>6.83</td>
<td>5.822</td>
<td>5.913</td>
<td>5.432</td>
<td>6.027</td>
<td>6.162</td>
<td>5.78</td>
<td>5.803</td>
</tr>
<tr>
<td>Case610</td>
<td>2.74</td>
<td>6.03</td>
<td>4.299</td>
<td>4.382</td>
<td>4.173</td>
<td>4.333</td>
<td>4.233</td>
<td>4.117</td>
<td>4.602</td>
</tr>
<tr>
<td>Case620</td>
<td>2.76</td>
<td>5.19</td>
<td>4.404</td>
<td>4.079</td>
<td>3.909</td>
<td>4.06</td>
<td>4.246</td>
<td>3.841</td>
<td>4.009</td>
</tr>
<tr>
<td>Case630</td>
<td>1.08</td>
<td>4.42</td>
<td>3.074</td>
<td>3.02</td>
<td>2.787</td>
<td>2.836</td>
<td>2.595</td>
<td>2.573</td>
<td>2.954</td>
</tr>
<tr>
<td>Case640</td>
<td>4.44</td>
<td>6.86</td>
<td>5.804</td>
<td>5.644</td>
<td>5.237</td>
<td>5.763</td>
<td>5.893</td>
<td>5.477</td>
<td>5.617</td>
</tr>
<tr>
<td>Case650</td>
<td>3.46</td>
<td>5.88</td>
<td>4.629</td>
<td>4.654</td>
<td>4.186</td>
<td>4.817</td>
<td>4.945</td>
<td>4.632</td>
<td>4.961</td>
</tr>
<tr>
<td>Case900</td>
<td>2.35</td>
<td>2.60</td>
<td bgcolor=\"#FF4500\">2.714</td>
<td>2.464</td>
<td>2.383</td>
<td>2.489</td>
<td>2.488</td>
<td bgcolor=\"#FF4500\">2.267</td>
<td bgcolor=\"#FF4500\">2.284</td>
</tr>
</table>
<br/>
<table border = \"1\" summary=\"Peak load\">
<tr><td colspan=\"15\"><b>Peak heating load (kW)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">BSIMAC</th>
<th colspan=\"2\">CSE</th>
<th colspan=\"2\">DeST</th>
<th colspan=\"2\">EnergyPlus</th>
<th colspan=\"2\">ESP-r</th>
<th colspan=\"2\">TRNSYS</th>
<th colspan=\"2\">ISO13790</th>
</tr>
<tr>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
</tr><tr>
<td>Case600</td>
<td>3.255</td>
<td>26-Nov:8</td>
<td>3.020</td>
<td>01-Jan:1</td>
<td>3.035</td>
<td>01-Jan:0</td>
<td>3.204</td>
<td>31-Dec:24</td>
<td>3.228</td>
<td>01-Jan:1</td>
<td>3.359</td>
<td>01-Jan:1</td>
<td>3.232</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case610</td>
<td>3.166</td>
<td>26-Nov:8</td>
<td>3.021</td>
<td>01-Jan:1</td>
<td>3.039</td>
<td>01-Jan:0</td>
<td>3.192</td>
<td>31-Dec:24</td>
<td>3.233</td>
<td>01-Jan:1</td>
<td>3.360</td>
<td>01-Jan:1</td>
<td>3.236</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case620</td>
<td>3.145</td>
<td>31-Dec:24</td>
<td>3.038</td>
<td>01-Jan:1</td>
<td>3.068</td>
<td>01-Jan:0</td>
<td>3.229</td>
<td>31-Dec:24</td>
<td>3.253</td>
<td>01-Jan:1</td>
<td>3.385</td>
<td>01-Jan:1</td>
<td>3.249</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case630</td>
<td>3.252</td>
<td>31-Dec:24</td>
<td>3.039</td>
<td>01-Jan:1</td>
<td>3.072</td>
<td>01-Jan:0</td>
<td>3.207</td>
<td>31-Dec:24</td>
<td>3.259</td>
<td>01-Jan:1</td>
<td>3.388</td>
<td>01-Jan:1</td>
<td>3.251</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case640</td>
<td>4.633</td>
<td>08-Feb:9</td>
<td>4.222</td>
<td>26-Nov:8</td>
<td>4.658</td>
<td>26-Nov:7</td>
<td>4.559</td>
<td>26-Nov:8</td>
<td>4.101</td>
<td>26-Nov:8</td>
<td>4.039</td>
<td>26-Nov:8</td>
<td>3.880</td>
<td>26-Nov:8</td>
</tr>
<tr>
<td>Case650</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>01-Jan:1</td>
<td>0.000</td>
<td>N/A</td>
<td>0.000</td>
<td>01-Jan:1</td>
<td>0.000</td>
<td>01-Jan:1</td>
<td>0.000</td>
<td>31-Dec:0</td>
<td>0.000</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case900</td>
<td>2.551</td>
<td>08-Feb:24</td>
<td>2.443</td>
<td>09-Feb:6</td>
<td>2.453</td>
<td>09-Feb:5</td>
<td>2.687</td>
<td>09-Feb:6</td>
<td>2.633</td>
<td>09-Feb:7</td>
<td>2.778</td>
<td>09-Feb:7</td>
<td>2.640</td>
<td>9-Feb:6</td>
</tr>
<tr><td colspan=\"15\"><b>Peak cooling load (kW)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">BSIMAC</th>
<th colspan=\"2\">CSE</th>
<th colspan=\"2\">DeST</th>
<th colspan=\"2\">EnergyPlus</th>
<th colspan=\"2\">ESP-r</th>
<th colspan=\"2\">TRNSYS</th>
<th colspan=\"2\">ISO13790</th>
</tr>
<tr>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
<td>kW</td><td>hour</td>
</tr><tr>
<td>Case600</td>
<td>5.650</td>
<td>22-Jan:15</td>
<td>6.481</td>
<td>22-Jan:14</td>
<td>5.422</td>
<td>22-Jan:14</td>
<td>6.352</td>
<td>22-Jan:14</td>
<td>6.193</td>
<td>22-Jan:14</td>
<td>6.046</td>
<td>22-Jan:14</td>
<td>5.570</td>
<td>22-Jan:14</td>
</tr>
<tr>
<td>Case610</td>
<td>5.466</td>
<td>22-Jan:15</td>
<td>6.432</td>
<td>01-Dec:14</td>
<td>5.331</td>
<td>22-Jan:14</td>
<td>6.135</td>
<td>01-Dec:14</td>
<td>5.934</td>
<td>22-Jan:14</td>
<td>5.868</td>
<td>01-Dec:14</td>
<td>4.611</td>
<td>18-Oct:14</td>
</tr>
<tr>
<td>Case620</td>
<td>4.704</td>
<td>26-Jun:18</td>
<td>4.493</td>
<td>26-Jun:17</td>
<td>3.955</td>
<td>26-Jun:17</td>
<td>4.797</td>
<td>26-Jun:17</td>
<td>4.622</td>
<td>26-Jun:17</td>
<td>4.588</td>
<td>26-Jun:17</td>
<td>4.384</td>
<td>26-Jun:18</td>
</tr>
<tr>
<td>Case630</td>
<td>4.121</td>
<td>26-Jun:18</td>
<td>3.998</td>
<td>26-Jun:18</td>
<td>3.526</td>
<td>26-Jun:17</td>
<td>4.212</td>
<td>26-Jun:17</td>
<td>3.971</td>
<td>26-Jun:17</td>
<td>3.949</td>
<td>26-Jun:17</td>
<td>3.734</td>
<td>26-Jun:18</td>
</tr>
<tr>
<td>Case640</td>
<td>5.650</td>
<td>22-Jan:15</td>
<td>6.429</td>
<td>22-Jan:14</td>
<td>5.365</td>
<td>22-Jan:14</td>
<td>6.297</td>
<td>22-Jan:14</td>
<td>6.127</td>
<td>22-Jan:14</td>
<td>5.967</td>
<td>22-Jan:14</td>
<td>5.516</td>
<td>22-Jan:14</td>
</tr>
<tr>
<td>Case650</td>
<td>5.648</td>
<td>22-Jan:15</td>
<td>6.290</td>
<td>01-Dec:14</td>
<td>5.045</td>
<td>18-Oct:14</td>
<td>6.138</td>
<td>18-Oct:14</td>
<td>5.961</td>
<td>18-Oct:14</td>
<td>5.797</td>
<td>18-Oct:14</td>
<td>6.836</td>
<td>26-Jun:19</td>
</tr>
<tr>
<td>Case900</td>
<td>3.039</td>
<td>01-Oct:15</td>
<td>3.376</td>
<td>01-Oct:14</td>
<td>2.556</td>
<td>11-Sep:14</td>
<td>3.040</td>
<td>01-Oct:14</td>
<td>2.896</td>
<td>12-Oct:15</td>
<td>2.940</td>
<td>01-Oct:14</td>
<td>2.365</td>
<td>1-Oct:15</td>
</tr>
</table>
<br/>
<!-- table end: load data -->

<h5>Free floating cases</h5>
<p>
The following plots compare the maximum, minimum and average zone temperature simulated with
the Modelica Buildings Library with the values simulated by other tools. The simulation
is also validated by comparing one-day simulation results in different days, and by
comparing the distribution of the annual temperature. The detailed comparisons, which also
show the peak temperature hour, are shown in the table after the plots.
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/max_temperature.png\"
     alt=\"max_temperature.png\" />
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/min_temperature.png\"
     alt=\"min_temperature.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/FF_temperature_600FF_Feb1.png\"
     alt=\"FF_temperature_600FF_Feb1.png\" />
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/FF_temperature_900FF_Feb1.png\"
     alt=\"FF_temperature_900FF_Feb1.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/FF_temperature_650FF_Jul14.png\"
     alt=\"FF_temperature_650FF_Jul14.png\" />
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/FF_temperature_950FF_Jul14.png\"
     alt=\"FF_temperature_950FF_Jul14.png\" />
</p>
<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/ave_temperature.png\"
     alt=\"ave_temperature.png\" />
<img src=\"modelica://IBPSA/Resources/Images/ThermalZones/ISO13790/Validation/BESTEST/bin_temperature_900FF.png\"
     alt=\"bin_temperature_900FF.png\" />
</p>

<!-- table start: free float data -->
<table border = \"1\" summary=\"Peak temperature\">
<tr><td colspan=\"15\"><b>Maximum temperature (&deg;C)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">BSIMAC</th>
<th colspan=\"2\">CSE</th>
<th colspan=\"2\">DeST</th>
<th colspan=\"2\">EnergyPlus</th>
<th colspan=\"2\">ESP-r</th>
<th colspan=\"2\">TRNSYS</th>
<th colspan=\"2\">ISO13790</th>
</tr>
<tr>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
</tr><tr>
<td>Case600FF</td>
<td>63.4</td>
<td>18-Oct:17</td>
<td>68.4</td>
<td>01-Oct:16</td>
<td>65.0</td>
<td>11-Oct:15</td>
<td>63.8</td>
<td>18-Oct:16</td>
<td>64.6</td>
<td>01-Oct:16</td>
<td>62.4</td>
<td>01-Oct:15</td>
<td>67.0</td>
<td>18-Oct:16</td>
</tr>
<tr>
<td>Case650FF</td>
<td>62.1</td>
<td>18-Oct:17</td>
<td>66.8</td>
<td>01-Oct:16</td>
<td>62.6</td>
<td>11-Oct:15</td>
<td>62.5</td>
<td>18-Oct:16</td>
<td>63.3</td>
<td>01-Oct:16</td>
<td>61.1</td>
<td>01-Oct:15</td>
<td>66.2</td>
<td>18-Oct:16</td>
</tr>
<tr>
<td>Case900FF</td>
<td>46.0</td>
<td>01-Oct:17</td>
<td>45.1</td>
<td>04-Sep:15</td>
<td>44.5</td>
<td>11-Sep:15</td>
<td>44.3</td>
<td>12-Sep:15</td>
<td>44.3</td>
<td>12-Sep:16</td>
<td>43.3</td>
<td>12-Sep:15</td>
<td>43.4</td>
<td>11-Sep:16</td>
</tr>
<tr><td colspan=\"15\"><b>Minimum temperature (&deg;C)</b></td></tr>
<tr>
<th rowspan=\"2\">Case</th>
<th colspan=\"2\">BSIMAC</th>
<th colspan=\"2\">CSE</th>
<th colspan=\"2\">DeST</th>
<th colspan=\"2\">EnergyPlus</th>
<th colspan=\"2\">ESP-r</th>
<th colspan=\"2\">TRNSYS</th>
<th colspan=\"2\">ISO13790</th>
</tr>
<tr>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
<td>&deg;C</td><td>hour</td>
</tr><tr>
<td>Case600FF</td>
<td>-9.9</td>
<td>26-Nov:8</td>
<td>-12.9</td>
<td>09-Feb:7</td>
<td>-13.5</td>
<td>09-Feb:6</td>
<td>-12.6</td>
<td>09-Feb:7</td>
<td>-13.5</td>
<td>09-Feb:7</td>
<td>-13.8</td>
<td>09-Feb:7</td>
<td>-12.9</td>
<td>9-Feb:7</td>
</tr>
<tr>
<td>Case650FF</td>
<td>-16.7</td>
<td>31-Dec:24</td>
<td>-17.8</td>
<td>01-Jan:1</td>
<td>-17.4</td>
<td>30-Dec:23</td>
<td>-17.1</td>
<td>31-Dec:24</td>
<td>-17.5</td>
<td>01-Jan:1</td>
<td>-17.5</td>
<td>31-Dec:24</td>
<td>-17.5</td>
<td>31-Dec:24</td>
</tr>
<tr>
<td>Case900FF</td>
<td>0.6</td>
<td>08-Feb:11</td>
<td>2.2</td>
<td>09-Feb:7</td>
<td>1.3</td>
<td>09-Feb:7</td>
<td>1.2</td>
<td>09-Feb:7</td>
<td>1.6</td>
<td>09-Feb:7</td>
<td>0.6</td>
<td>09-Feb:7</td>
<td>0.3</td>
<td>9-Feb:7</td>
</tr>
</table>
<br/>
<!-- table end: free float data -->
<h4>Implementation</h4>
<p>
To generate the data shown in this user guide, run
</p>
<pre>
  cd IBPSA/Resources/src/ThermalZones/ISO13790/Validation/BESTEST
  python3 simulateAndPlot.py
</pre>
<h4>References</h4>
<p>
ANSI/ASHRAE. 2007. ANSI/ASHRAE Standard 140-2007,
Standard Method of Test for the Evaluation of Building Energy Analysis Computer Programs.
</p>
</html>"));
end UsersGuide;
