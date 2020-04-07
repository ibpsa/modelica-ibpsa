within IBPSA.BoundaryConditions;
package BESTEST "Collection of validation models BESTEST"
    extends Modelica.Icons.ExamplesPackage;

  package UsersGuide "User's Guide"
    extends Modelica.Icons.Information;

    annotation(preferredView="info",
    Documentation(info="<html>
<p>The package <a href=\"modelica://IBPSA.BoundaryConditions.BESTEST.Validation\">IBPSA.BoundaryConditions.BESTEST.Validation</a> contains the models that were used for the BESTEST validation ASHRAE 2020 for weather data acquisition and postprocessing. Each model represents a different climate with different days as shown in the tables below. All examples have a script that runs the simulation according to the specifications and derive the required Json file as reported below. </p><p>The weather radiation data has to be provided at different orientations and inclinations.</p>
<p><br><i>Table 2:&nbsp;</i>Azimuth and Slope for Surfaces</p>
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
<p><br><h4>Additional parameters and correlations:</h4></p>
<p>Ground reflectance &rho; can be set to 0 or 0.2</p>
<p>Black body temperature calculated using Horizontal radiation or dew point temperature and sky cover</p><p>Perez or Isoentropic sky model used</p>
<h4>Outputs required:</h4>
<p>&nbsp;<b>Annual Outputs:&nbsp;</b>The following outputs shall be provided for an annual simulation:</p>
<ul>
<li>Average dry bulb temperature (&deg;C)</li>
<li>Average relative humidity (&percnt;)</li>
<li>Average dewpoint temperature (&deg;C)</li>
<li>Average humidity ratio (kg moisture/kg dry air)</li>
<li>Average wet bulb temperature (&deg;C)</li>
<li>Sum of total, beam, and diffuse solar radiation incident on each surface (Wh/m2)</li>
</ul>
<p><br><b>Hourly Outputs:</b> The following outputs shall be provided for each hour of the days specified for each test case in Table 3:</p>
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
</ul>
<p><br>&bull; Sum of total, beam, and diffuse solar radiation incident on each surface (Wh/m2)&nbsp;</p>
<p><br><i>Table 3: Specific Days for Output</i></p>
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
<p><br><br><b>Sub-hourly Outputs:</b></p>
<p><br>The following outputs shall be provided at each timestep of the days specified for each test case in Table 3:</p>
<ul>
<li>Dry bulb temperature (C)</li>
<li>Relative humidity (&percnt;)</li>
<li>Sum of total, beam, and diffuse solar radiation incident on each surface (Wh/m2) </li>
</ul>
<p><br>The following outputs shall be provided integrated hourly for the days specified for each test case in Table 3:</p>
<ul>
<li>Total incident horizontal solar radiation (Wh/m2)</li>
<li>Total incident horizontal beam solar radiation (Wh/m2)</li>
<li>Total incident horizontal diffuse solar radiation (Wh/m2) </li>
</ul>
<h4>Validation results</h4>
<p>(Not available yet)</p>
<h4>Implementation</h4>
<p>To generate the data shown in this user guide, run </p>
<p><span style=\"font-family: Courier New;\">cd IBPSA/Resources/src/BoundaryConditions/Validation/BESTEST</span></p>
<p><span style=\"font-family: Courier New;\">python3 WeatherBESTEST.py</span></p>
<h4>References</h4>
<p>(Not available yet)</p>
</html>"));
  end UsersGuide;

  package Validation
    "Boundary conditions validation according to BESTEST specifications"
    model WD100 "Test model for BESTEST weather data: base case"
      extends Modelica.Icons.Example;
      parameter Modelica.SIunits.Angle lat=0.6952170009469 "Latitude angle";
      parameter Real rho=0 "Ground reflectance";

      WeatherData.ReaderTMY3                          weaDat(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=1650,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/725650.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,-88})));

      WeatherData.Bus weaBus annotation (Placement(transformation(extent={{-16,-82},
                {14,-54}}), iconTransformation(extent={{-220,70},{-200,90}})));
      ComRadIsoPerDir Azi000Til00(
        til=IBPSA.Types.Tilt.Ceiling,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = Horizontal, Tilt = 0 °"
        annotation (Placement(transformation(extent={{68,68},{88,88}})));
      ComRadIsoPerDir Azi000Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,36},{88,56}})));
      ComRadIsoPerDir Azi270Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,2},{88,22}})));
      ComRadIsoPerDir Azi180Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.N,
        rho=rho) "Azimuth = North, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-28},{88,-8}})));
      ComRadIsoPerDir Azi090Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth =  West, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-56},{88,-36}})));
      ComRadIsoPerDir Azi315Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SE,
        rho=rho) "Azimuth = 45 ° SE, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,68},{-78,88}})));
      ComRadIsoPerDir Azi045Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SW,
        rho=rho) "Azimuth = 45 SW, Tilt = 90 °"
        annotation (Placement(transformation(extent={{-58,36},{-78,56}})));
      ComRadIsoPerDir Azi270Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 30 °"
        annotation (Placement(transformation(extent={{-58,2},{-78,22}})));
      ComRadIsoPerDir Azi000Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-28},{-78,-8}})));
      ComRadIsoPerDir Azi090Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth = West, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-56},{-78,-36}})));
      Utilities.Psychrometrics.X_pTphi x_pTphi
        annotation (Placement(transformation(extent={{-48,-90},{-68,-70}})));
      Utilities.Psychrometrics.ToDryAir toDryAir
        annotation (Placement(transformation(extent={{-76,-92},{-98,-70}})));
      WeatherData.ReaderTMY3                          weaDat1(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=1650,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/725650.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={50,-90})));

      WeatherData.Bus weaBusDew annotation (Placement(transformation(extent={{36,-82},
                {66,-54}}), iconTransformation(extent={{-220,70},{-200,90}})));
    equation
      connect(weaDat.weaBus, weaBus) annotation (Line(
          points={{6.66134e-16,-78},{6.66134e-16,-68},{-1,-68}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi000Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,46},{0,46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,12},{0,12},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi180Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-18},{0,-18},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-46},{0,-46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi045Til90.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,46},{0,46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,12},{0,12},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi000Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-18},{0,-18},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-46},{0,-46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus.pAtm, x_pTphi.p_in) annotation (Line(
          points={{-1,-68},{-34,-68},{-34,-74},{-46,-74}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-3,-6},{-3,-6}},
          horizontalAlignment=TextAlignment.Right));
      connect(weaBus.TDryBul, x_pTphi.T) annotation (Line(
          points={{-1,-68},{-22,-68},{-22,-80},{-46,-80}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus.relHum, x_pTphi.phi) annotation (Line(
          points={{-1,-68},{-18,-68},{-18,-86},{-46,-86}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(x_pTphi.X[1], toDryAir.XiTotalAir) annotation (Line(points={{-69,
              -80},{-72,-80},{-72,-81},{-74.9,-81}}, color={0,0,127}));
      connect(weaDat1.weaBus, weaBusDew) annotation (Line(
          points={{50,-80},{50,-74},{51,-74},{51,-68},{51,-68}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%second",
          index=1,
          extent={{-3,6},{-3,6}},
          horizontalAlignment=TextAlignment.Right));
      annotation (
      Documentation(info="<html>
<h4>WD100: Base Case</h4>
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
<p><br><br><h4>Additional parameters and correlations:</h4></p>
<p>Ground reflectance &rho; is set to 0</p>
<p>Black body temperature calculated using Horizontal radiation or dew point temperature and sky cover</p><p>Perez or Isoentropic sky model used</p>
</html>",     revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
          StopTime=31539600,
          __Dymola_NumberOfIntervals=35043,
          Tolerance=1e-06,
          __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/IncidenceAngle.mos"
            "Simulate and plot"));
    end WD100;
  extends Modelica.Icons.ExamplesPackage;

    model WD200
      "Test model for BESTEST weather data: Low Elevation, Hot and Humid Case"
      extends Modelica.Icons.Example;
      parameter Modelica.SIunits.Angle lat=0.58700658732325 "Latitude angle";
      parameter Real rho=0 "Ground reflectance";

      WeatherData.ReaderTMY3                          weaDat(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=308,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/722190.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,-88})));

      WeatherData.Bus weaBus annotation (Placement(transformation(extent={{-16,-82},
                {14,-54}}), iconTransformation(extent={{-220,70},{-200,90}})));
      ComRadIsoPerDir Azi000Til00(
        til=IBPSA.Types.Tilt.Ceiling,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = Horizontal, Tilt = 0 °"
        annotation (Placement(transformation(extent={{68,68},{88,88}})));
      ComRadIsoPerDir Azi000Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,36},{88,56}})));
      ComRadIsoPerDir Azi270Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,2},{88,22}})));
      ComRadIsoPerDir Azi180Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.N,
        rho=rho) "Azimuth = North, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-28},{88,-8}})));
      ComRadIsoPerDir Azi090Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth =  West, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-56},{88,-36}})));
      ComRadIsoPerDir Azi315Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SE,
        rho=rho) "Azimuth = 45 ° SE, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,68},{-78,88}})));
      ComRadIsoPerDir Azi045Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SW,
        rho=rho) "Azimuth = 45 SW, Tilt = 90 °"
        annotation (Placement(transformation(extent={{-58,36},{-78,56}})));
      ComRadIsoPerDir Azi270Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 30 °"
        annotation (Placement(transformation(extent={{-58,2},{-78,22}})));
      ComRadIsoPerDir Azi000Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-28},{-78,-8}})));
      ComRadIsoPerDir Azi090Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth = West, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-56},{-78,-36}})));
      Utilities.Psychrometrics.X_pTphi x_pTphi
        annotation (Placement(transformation(extent={{-48,-92},{-68,-72}})));
      Utilities.Psychrometrics.ToDryAir toDryAir
        annotation (Placement(transformation(extent={{-76,-94},{-98,-72}})));
      WeatherData.ReaderTMY3                          weaDat1(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=308,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/722190.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={50,-86})));

      WeatherData.Bus weaBusDew annotation (Placement(transformation(extent={{34,-80},
                {64,-52}}), iconTransformation(extent={{-220,70},{-200,90}})));
    equation
      connect(weaDat.weaBus, weaBus) annotation (Line(
          points={{6.66134e-16,-78},{6.66134e-16,-68},{-1,-68}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi000Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,46},{0,46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,12},{0,12},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi180Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-18},{0,-18},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-46},{0,-46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi045Til90.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,46},{0,46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,12},{0,12},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi000Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-18},{0,-18},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-46},{0,-46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus.pAtm,x_pTphi. p_in) annotation (Line(
          points={{-1,-68},{-34,-68},{-34,-76},{-46,-76}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-3,-6},{-3,-6}},
          horizontalAlignment=TextAlignment.Right));
      connect(weaBus.TDryBul,x_pTphi. T) annotation (Line(
          points={{-1,-68},{-22,-68},{-22,-82},{-46,-82}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus.relHum,x_pTphi. phi) annotation (Line(
          points={{-1,-68},{-18,-68},{-18,-88},{-46,-88}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(x_pTphi.X[1], toDryAir.XiTotalAir) annotation (Line(points={{-69,
              -82},{-72,-82},{-72,-83},{-74.9,-83}}, color={0,0,127}));
      connect(weaBusDew, weaDat1.weaBus) annotation (Line(
          points={{49,-66},{50,-66},{50,-76}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-3,6},{-3,6}},
          horizontalAlignment=TextAlignment.Right));
      annotation (
      Documentation(info="<html>
<h4>WD200: Low Elevation, Hot and Humid Case.</h4>
<p>Weather data file : 722190.epw</p>
<p><i>Table 1: Site Data for Weather file 722190.epw</i></p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Latitude</p></td>
<td><p>33.633&deg; north</p></td>
</tr>
<tr>
<td><p>Longitude</p></td>
<td><p>84.433&deg; west</p></td>
</tr>
<tr>
<td><p>Altitude</p></td>
<td><p>308 m</p></td>
</tr>
<tr>
<td><p>Time Zone</p></td>
<td><p>5</p></td>
</tr>
</table>
<p><br><br><h4>Additional parameters and correlations:</h4></p>
<p>Ground reflectance &rho; is set to 0</p>
<p>Black body temperature calculated using Horizontal radiation or dew point temperature and sky cover</p>
<p>Perez or Isoentropic sky model used</p>
</html>",     revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
          StopTime=31539600,
          __Dymola_NumberOfIntervals=35043,
          Tolerance=1e-06,
          __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/IncidenceAngle.mos"
            "Simulate and plot"));
    end WD200;

    model WD300
      "Test model for BESTEST weather data: Southern hemisphere case"
      extends Modelica.Icons.Example;
      parameter Modelica.SIunits.Angle lat=-0.58281779711847 "Latitude angle";
      parameter Real rho=0 "Ground reflectance";

      WeatherData.ReaderTMY3                          weaDat(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=474,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/855740.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,-88})));

      WeatherData.Bus weaBus annotation (Placement(transformation(extent={{-16,-82},
                {14,-54}}), iconTransformation(extent={{-220,70},{-200,90}})));
      ComRadIsoPerDir Azi000Til00(
        til=IBPSA.Types.Tilt.Ceiling,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = Horizontal, Tilt = 0 °"
        annotation (Placement(transformation(extent={{68,68},{88,88}})));
      ComRadIsoPerDir Azi000Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,36},{88,56}})));
      ComRadIsoPerDir Azi270Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,2},{88,22}})));
      ComRadIsoPerDir Azi180Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.N,
        rho=rho) "Azimuth = North, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-28},{88,-8}})));
      ComRadIsoPerDir Azi090Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth =  West, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-56},{88,-36}})));
      ComRadIsoPerDir Azi315Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SE,
        rho=rho) "Azimuth = 45 ° SE, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,68},{-78,88}})));
      ComRadIsoPerDir Azi045Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SW,
        rho=rho) "Azimuth = 45 SW, Tilt = 90 °"
        annotation (Placement(transformation(extent={{-58,36},{-78,56}})));
      ComRadIsoPerDir Azi270Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 30 °"
        annotation (Placement(transformation(extent={{-58,2},{-78,22}})));
      ComRadIsoPerDir Azi000Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-28},{-78,-8}})));
      ComRadIsoPerDir Azi090Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth = West, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-56},{-78,-36}})));
      Utilities.Psychrometrics.X_pTphi x_pTphi
        annotation (Placement(transformation(extent={{-44,-92},{-64,-72}})));
      Utilities.Psychrometrics.ToDryAir toDryAir
        annotation (Placement(transformation(extent={{-72,-94},{-94,-72}})));
      WeatherData.ReaderTMY3                          weaDat1(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=474,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/855740.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={52,-90})));

      WeatherData.Bus weaBusDew annotation (Placement(transformation(extent={{36,-82},
                {66,-54}}), iconTransformation(extent={{-220,70},{-200,90}})));
    equation
      connect(weaDat.weaBus, weaBus) annotation (Line(
          points={{6.66134e-16,-78},{6.66134e-16,-68},{-1,-68}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi000Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,46},{0,46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,12},{0,12},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi180Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-18},{0,-18},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-46},{0,-46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi045Til90.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,46},{0,46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,12},{0,12},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi000Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-18},{0,-18},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-46},{0,-46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus.pAtm,x_pTphi. p_in) annotation (Line(
          points={{-1,-68},{-30,-68},{-30,-76},{-42,-76}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-3,-6},{-3,-6}},
          horizontalAlignment=TextAlignment.Right));
      connect(weaBus.TDryBul,x_pTphi. T) annotation (Line(
          points={{-1,-68},{-18,-68},{-18,-82},{-42,-82}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus.relHum,x_pTphi. phi) annotation (Line(
          points={{-1,-68},{-14,-68},{-14,-88},{-42,-88}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(x_pTphi.X[1], toDryAir.XiTotalAir) annotation (Line(points={{-65,
              -82},{-68,-82},{-68,-83},{-70.9,-83}}, color={0,0,127}));
      connect(weaBusDew, weaDat1.weaBus) annotation (Line(
          points={{51,-68},{52,-68},{52,-80}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-3,6},{-3,6}},
          horizontalAlignment=TextAlignment.Right));
      annotation (
      Documentation(info="<html>
<h4>WD300: Southern Hemisphere Case</h4>
<p>Weather data file : 855740.epw</p>
<p><i>Table 1: Site Data for Weather file 855740.epw</i></p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Latitude</p></td>
<td><p>33.393&deg; south</p></td>
</tr>
<tr>
<td><p>Longitude</p></td>
<td><p>70.786&deg; west</p></td>
</tr>
<tr>
<td><p>Altitude</p></td>
<td><p>474 m</p></td>
</tr>
<tr>
<td><p>Time Zone</p></td>
<td><p>4</p></td>
</tr>
</table>
<p><br><br><h4>Additional parameters and correlations:</h4></p>
<p>Ground reflectance &rho; is set to 0</p>
<p>Black body temperature calculated using Horizontal radiation or dew point temperature and sky cover</p><p>Perez or Isoentropic sky model used</p>
</html>",     revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
          StopTime=31539600,
          __Dymola_NumberOfIntervals=35043,
          Tolerance=1e-06,
          __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/IncidenceAngle.mos"
            "Simulate and plot"));
    end WD300;

    model WD400
      "Test model for BESTEST weather data: high latitude case"
      extends Modelica.Icons.Example;
      parameter Modelica.SIunits.Angle lat=1.2441754105767 "Latitude angle";
      parameter Real rho=0 "Ground reflectance";

      WeatherData.ReaderTMY3                          weaDat(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=10,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/700260.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,-88})));

      WeatherData.Bus weaBus annotation (Placement(transformation(extent={{-16,-82},
                {14,-54}}), iconTransformation(extent={{-220,70},{-200,90}})));
      ComRadIsoPerDir Azi000Til00(
        til=IBPSA.Types.Tilt.Ceiling,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = Horizontal, Tilt = 0 °"
        annotation (Placement(transformation(extent={{68,68},{88,88}})));
      ComRadIsoPerDir Azi000Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,36},{88,56}})));
      ComRadIsoPerDir Azi270Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,2},{88,22}})));
      ComRadIsoPerDir Azi180Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.N,
        rho=rho) "Azimuth = North, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-28},{88,-8}})));
      ComRadIsoPerDir Azi090Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth =  West, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-56},{88,-36}})));
      ComRadIsoPerDir Azi315Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SE,
        rho=rho) "Azimuth = 45 ° SE, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,68},{-78,88}})));
      ComRadIsoPerDir Azi045Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SW,
        rho=rho) "Azimuth = 45 SW, Tilt = 90 °"
        annotation (Placement(transformation(extent={{-58,36},{-78,56}})));
      ComRadIsoPerDir Azi270Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 30 °"
        annotation (Placement(transformation(extent={{-58,2},{-78,22}})));
      ComRadIsoPerDir Azi000Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-28},{-78,-8}})));
      ComRadIsoPerDir Azi090Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth = West, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-56},{-78,-36}})));
      Utilities.Psychrometrics.X_pTphi x_pTphi
        annotation (Placement(transformation(extent={{-46,-94},{-66,-74}})));
      Utilities.Psychrometrics.ToDryAir toDryAir
        annotation (Placement(transformation(extent={{-74,-96},{-96,-74}})));
      WeatherData.Bus weaBusDew annotation (Placement(transformation(extent={{32,-80},
                {62,-52}}), iconTransformation(extent={{-220,70},{-200,90}})));
      WeatherData.ReaderTMY3                          weaDat1(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=10,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/700260.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={48,-86})));

    equation
      connect(weaDat.weaBus, weaBus) annotation (Line(
          points={{6.66134e-16,-78},{6.66134e-16,-68},{-1,-68}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi000Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,46},{0,46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,12},{0,12},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi180Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-18},{0,-18},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-46},{0,-46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi045Til90.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,46},{0,46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,12},{0,12},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi000Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-18},{0,-18},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-46},{0,-46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus.pAtm,x_pTphi. p_in) annotation (Line(
          points={{-1,-68},{-32,-68},{-32,-78},{-44,-78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-3,-6},{-3,-6}},
          horizontalAlignment=TextAlignment.Right));
      connect(weaBus.TDryBul,x_pTphi. T) annotation (Line(
          points={{-1,-68},{-20,-68},{-20,-84},{-44,-84}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus.relHum,x_pTphi. phi) annotation (Line(
          points={{-1,-68},{-16,-68},{-16,-90},{-44,-90}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(x_pTphi.X[1], toDryAir.XiTotalAir) annotation (Line(points={{-67,
              -84},{-70,-84},{-70,-85},{-72.9,-85}}, color={0,0,127}));
      connect(weaBusDew, weaDat1.weaBus) annotation (Line(
          points={{47,-66},{47,-71},{48,-71},{48,-76}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-3,6},{-3,6}},
          horizontalAlignment=TextAlignment.Right));
      annotation (
      Documentation(info="<html>
<h4>WD400: High Latitude Case</h4>
<p>Weather data file : 700260.epw</p>
<p><i>Table 1: Site Data for Weather file 700260.epw</i></p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Latitude</p></td>
<td><p>71.286&deg; north</p></td>
</tr>
<tr>
<td><p>Longitude</p></td>
<td><p>156.767&deg; west</p></td>
</tr>
<tr>
<td><p>Altitude</p></td>
<td><p>10 m</p></td>
</tr>
<tr>
<td><p>Time Zone</p></td>
<td><p>9</p></td>
</tr>
</table>
<p><br><br><h4>Additional parameters and correlations:</h4></p>
<p>Ground reflectance &rho; is set to 0</p>
<p>Black body temperature calculated using Horizontal radiation or dew point temperature and sky cover</p>
<p>Perez or Isoentropic sky model used</p>
</html>",     revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
          StopTime=31539600,
          __Dymola_NumberOfIntervals=35043,
          Tolerance=1e-06,
          __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/IncidenceAngle.mos"
            "Simulate and plot"));
    end WD400;

    model WD500
      "Test model for BESTEST weather data: time zone case"
      extends Modelica.Icons.Example;
      parameter Modelica.SIunits.Angle lat=0.49858820742 "Latitude angle";
      parameter Real rho=0 "Ground reflectance";

      WeatherData.ReaderTMY3                          weaDat(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=236.8,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/421810.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={0,-88})));

      WeatherData.Bus weaBus annotation (Placement(transformation(extent={{-16,-82},
                {14,-54}}), iconTransformation(extent={{-220,70},{-200,90}})));
      ComRadIsoPerDir Azi000Til00(
        til=IBPSA.Types.Tilt.Ceiling,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = Horizontal, Tilt = 0 °"
        annotation (Placement(transformation(extent={{68,68},{88,88}})));
      ComRadIsoPerDir Azi000Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,36},{88,56}})));
      ComRadIsoPerDir Azi270Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,2},{88,22}})));
      ComRadIsoPerDir Azi180Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.N,
        rho=rho) "Azimuth = North, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-28},{88,-8}})));
      ComRadIsoPerDir Azi090Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth =  West, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-56},{88,-36}})));
      ComRadIsoPerDir Azi315Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SE,
        rho=rho) "Azimuth = 45 ° SE, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,68},{-78,88}})));
      ComRadIsoPerDir Azi045Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SW,
        rho=rho) "Azimuth = 45 SW, Tilt = 90 °"
        annotation (Placement(transformation(extent={{-58,36},{-78,56}})));
      ComRadIsoPerDir Azi270Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 30 °"
        annotation (Placement(transformation(extent={{-58,2},{-78,22}})));
      ComRadIsoPerDir Azi000Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-28},{-78,-8}})));
      ComRadIsoPerDir Azi090Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth = West, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-56},{-78,-36}})));
      Utilities.Psychrometrics.X_pTphi x_pTphi
        annotation (Placement(transformation(extent={{-46,-94},{-66,-74}})));
      Utilities.Psychrometrics.ToDryAir toDryAir
        annotation (Placement(transformation(extent={{-74,-96},{-96,-74}})));
      WeatherData.ReaderTMY3                          weaDat1(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=236.8,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/421810.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={52,-88})));

      WeatherData.Bus weaBusDew annotation (Placement(transformation(extent={{36,-82},
                {66,-54}}), iconTransformation(extent={{-220,70},{-200,90}})));
    equation
      connect(weaDat.weaBus, weaBus) annotation (Line(
          points={{6.66134e-16,-78},{6.66134e-16,-68},{-1,-68}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi000Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,46},{0,46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,12},{0,12},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi180Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-18},{0,-18},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-46},{0,-46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi045Til90.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,46},{0,46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,12},{0,12},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi000Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-18},{0,-18},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-46},{0,-46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus.pAtm,x_pTphi. p_in) annotation (Line(
          points={{-1,-68},{-32,-68},{-32,-78},{-44,-78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-3,-6},{-3,-6}},
          horizontalAlignment=TextAlignment.Right));
      connect(weaBus.TDryBul,x_pTphi. T) annotation (Line(
          points={{-1,-68},{-20,-68},{-20,-84},{-44,-84}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus.relHum,x_pTphi. phi) annotation (Line(
          points={{-1,-68},{-16,-68},{-16,-90},{-44,-90}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(x_pTphi.X[1], toDryAir.XiTotalAir) annotation (Line(points={{-67,
              -84},{-70,-84},{-70,-85},{-72.9,-85}}, color={0,0,127}));
      connect(weaBusDew, weaDat1.weaBus) annotation (Line(
          points={{51,-68},{51,-73},{52,-73},{52,-78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-3,6},{-3,6}},
          horizontalAlignment=TextAlignment.Right));
      annotation (
      Documentation(info="<html>
<h4>WD500: Time Zone Case</h4>
<p>Weather data file : 421810.epw</p>
<p><i>Table 1: Site Data for Weather file 421810epw</i></p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p>Latitude</p></td>
<td><p>28.567&deg; north</p></td>
</tr>
<tr>
<td><p>Longitude</p></td>
<td><p>77.103&deg; west</p></td>
</tr>
<tr>
<td><p>Altitude</p></td>
<td><p>236.9 m</p></td>
</tr>
<tr>
<td><p>Time Zone</p></td>
<td><p>-5.5</p></td>
</tr>
</table>
<p><br><br><b>Additional parameters and correlations:</b></p>
<p>Ground reflectance &rho; is set to 0</p>
<p>Black body temperature calculated using Horizontal radiation or dew point temperature and sky cover</p>
<p>Perez or Isoentropic sky model used</p>
</html>",     revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
          StopTime=31539600,
          __Dymola_NumberOfIntervals=35043,
          Tolerance=1e-06,
          __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/IncidenceAngle.mos"
            "Simulate and plot"));
    end WD500;

    model WD600
      "Test model for BESTEST weather data: ground reflectance"
      extends Modelica.Icons.Example;
      parameter Modelica.SIunits.Angle lat=0.6952170009469 "Latitude angle";
      parameter Real rho=0.2 "Ground reflectance";

      WeatherData.ReaderTMY3                          weaDat(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=1650,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/725650.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={2,-88})));

      WeatherData.Bus weaBus annotation (Placement(transformation(extent={{-16,-82},
                {14,-54}}), iconTransformation(extent={{-220,70},{-200,90}})));
      ComRadIsoPerDir Azi000Til00(
        til=IBPSA.Types.Tilt.Ceiling,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = Horizontal, Tilt = 0 °"
        annotation (Placement(transformation(extent={{68,68},{88,88}})));
      ComRadIsoPerDir Azi000Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,36},{88,56}})));
      ComRadIsoPerDir Azi270Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,2},{88,22}})));
      ComRadIsoPerDir Azi180Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.N,
        rho=rho) "Azimuth = North, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-28},{88,-8}})));
      ComRadIsoPerDir Azi090Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth =  West, Tilt = 90 °"
        annotation (Placement(transformation(extent={{68,-56},{88,-36}})));
      ComRadIsoPerDir Azi315Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SE,
        rho=rho) "Azimuth = 45 ° SE, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,68},{-78,88}})));
      ComRadIsoPerDir Azi045Til90(
        til=IBPSA.Types.Tilt.Wall,
        lat=lat,
        azi=IBPSA.Types.Azimuth.SW,
        rho=rho) "Azimuth = 45 SW, Tilt = 90 °"
        annotation (Placement(transformation(extent={{-58,36},{-78,56}})));
      ComRadIsoPerDir Azi270Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.E,
        rho=rho) "Azimuth = East, Tilt = 30 °"
        annotation (Placement(transformation(extent={{-58,2},{-78,22}})));
      ComRadIsoPerDir Azi000Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.S,
        rho=rho) "Azimuth = South, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-28},{-78,-8}})));
      ComRadIsoPerDir Azi090Til30(
        til=0.5235987755983,
        lat=lat,
        azi=IBPSA.Types.Azimuth.W,
        rho=rho) "Azimuth = West, Tilt = 0 °"
        annotation (Placement(transformation(extent={{-58,-56},{-78,-36}})));
      Utilities.Psychrometrics.X_pTphi x_pTphi
        annotation (Placement(transformation(extent={{-46,-94},{-66,-74}})));
      Utilities.Psychrometrics.ToDryAir toDryAir
        annotation (Placement(transformation(extent={{-74,-96},{-96,-74}})));
      WeatherData.ReaderTMY3                          weaDat1(
        pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
        ceiHei=1650,
        totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File,
        relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File,
        HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File,
        filNam=Modelica.Utilities.Files.loadResource(
            "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/725650.mos"),
        calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}},
            rotation=90,
            origin={48,-86})));

      WeatherData.Bus weaBusDew annotation (Placement(transformation(extent={{32,-80},
                {62,-52}}), iconTransformation(extent={{-220,70},{-200,90}})));
    equation
      connect(weaDat.weaBus, weaBus) annotation (Line(
          points={{2,-78},{2,-68},{-1,-68}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi000Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,46},{0,46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,12},{0,12},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi180Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-18},{0,-18},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til90.weaBus, Azi000Til00.weaBus) annotation (Line(
          points={{68,-46},{0,-46},{0,78},{68,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-1,-68},{0,-68},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}},
          horizontalAlignment=TextAlignment.Right));
      connect(Azi045Til90.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,46},{0,46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi270Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,12},{0,12},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi000Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-18},{0,-18},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(Azi090Til30.weaBus, Azi315Til90.weaBus) annotation (Line(
          points={{-58,-46},{0,-46},{0,78},{-58,78}},
          color={255,204,51},
          thickness=0.5));
      connect(weaBus.pAtm,x_pTphi. p_in) annotation (Line(
          points={{-1,-68},{-32,-68},{-32,-78},{-44,-78}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{-3,-6},{-3,-6}},
          horizontalAlignment=TextAlignment.Right));
      connect(weaBus.TDryBul,x_pTphi. T) annotation (Line(
          points={{-1,-68},{-20,-68},{-20,-84},{-44,-84}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(weaBus.relHum,x_pTphi. phi) annotation (Line(
          points={{-1,-68},{-16,-68},{-16,-90},{-44,-90}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%first",
          index=-1,
          extent={{6,3},{6,3}},
          horizontalAlignment=TextAlignment.Left));
      connect(x_pTphi.X[1], toDryAir.XiTotalAir) annotation (Line(points={{-67,
              -84},{-70,-84},{-70,-85},{-72.9,-85}}, color={0,0,127}));
      connect(weaDat1.weaBus, weaBusDew) annotation (Line(
          points={{48,-76},{48,-66},{47,-66}},
          color={255,204,51},
          thickness=0.5), Text(
          string="%second",
          index=1,
          extent={{-3,6},{-3,6}},
          horizontalAlignment=TextAlignment.Right));
      annotation (
      Documentation(info="<html>
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
<p><br><h4>Additional parameters and correlations:</h4></p>
<p>Ground reflectance &rho; is set to 0.2</p>
<p>Black body temperature calculated using Horizontal radiation or dew point temperature and sky cover</p>
<p>Perez or Isoentropic sky model used</p>
</html>",     revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
          StopTime=31539600,
          __Dymola_NumberOfIntervals=35043,
          Tolerance=1e-06,
          __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/BoundaryConditions/SolarGeometry/Examples/IncidenceAngle.mos"
            "Simulate and plot"));
    end WD600;

  end Validation;

  model ComRadIsoPerDir
    "Partial model to run BESTEST validation case studies for weather data processing"
    extends
      IBPSA.BoundaryConditions.SolarIrradiation.BaseClasses.PartialSolarIrradiation;
    Modelica.Blocks.Interfaces.RealOutput HPer(
       final quantity="RadiantEnergyFluenceRate",
       final unit="W/m2") "Radiation per unit area"
      annotation (Placement(transformation(extent={{100,-36},{120,-16}})));

    parameter Modelica.SIunits.Angle til(displayUnit="deg") "Surface tilt angle";
    parameter Modelica.SIunits.Angle lat(displayUnit="deg") "Latitude angle";
    parameter Modelica.SIunits.Angle azi(displayUnit="deg") "Azimuth angle";
    parameter Real rho=0.2 "Ground reflectance";

    SolarIrradiation.DirectTiltedSurface HDir(
      til=til,
      lat=lat,
      azi=azi) "Direct Irradiation on tilted surface"
      annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));
    SolarIrradiation.DiffuseIsotropic HDiffIso(
      til=til,
      rho=rho,
      outSkyCon=true,
      outGroCon=true) "Isoentropic diffuse radiation"
      annotation (Placement(transformation(extent={{-32,62},{-12,82}})));
    SolarIrradiation.DiffusePerez HDiffPer(
      til=til,
      rho=rho,
      lat=lat,
      azi=azi,
      outSkyCon=true,
      outGroCon=true) "Diffused radiation using Perez "
      annotation (Placement(transformation(extent={{-32,-92},{-12,-72}})));
  protected
    Modelica.Blocks.Math.Add AddHdirHdiffIso
      "Sum of Direct radiation and Isoentropic radiation"
      annotation (Placement(transformation(extent={{48,8},{68,28}})));
    Modelica.Blocks.Math.Add AddHdirHdiffPer
      "Sum of Direct radiation and Perez radiation"
      annotation (Placement(transformation(extent={{50,-34},{70,-14}})));
  equation
    connect(weaBus, HDiffIso.weaBus) annotation (Line(
        points={{-100,0},{-74,0},{-74,72},{-32,72}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(HDir.weaBus, HDiffIso.weaBus) annotation (Line(
        points={{-32,0},{-74,0},{-74,72},{-32,72}},
        color={255,204,51},
        thickness=0.5));
    connect(HDiffPer.weaBus, HDiffIso.weaBus) annotation (Line(
        points={{-32,-82},{-74,-82},{-74,72},{-32,72}},
        color={255,204,51},
        thickness=0.5));
    connect(HDir.H, AddHdirHdiffPer.u1) annotation (Line(points={{-11,0},{2,0},{2,
            -18},{48,-18}}, color={0,0,127}));
    connect(HDiffPer.H, AddHdirHdiffPer.u2) annotation (Line(points={{-11,-82},{-8,
            -82},{-8,-30},{48,-30}}, color={0,0,127}));
    connect(HDiffIso.H, AddHdirHdiffIso.u1) annotation (Line(points={{-11,72},{2,72},
            {2,24},{46,24}}, color={0,0,127}));
    connect(HDir.H, AddHdirHdiffIso.u2)
      annotation (Line(points={{-11,0},{2,0},{2,12},{46,12}}, color={0,0,127}));
    connect(AddHdirHdiffIso.y, H) annotation (Line(points={{69,18},{86,18},{86,0},
            {110,0}}, color={0,0,127}));
    connect(AddHdirHdiffPer.y, HPer) annotation (Line(points={{71,-24},{86,-24},{86,
            -26},{110,-26}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ComRadIsoPerDir;
annotation (Documentation(info="<html>
<p>
This package contains models for validation of weather data models.
</p>
</html>"));
end BESTEST;
