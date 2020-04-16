within IBPSA.BoundaryConditions.BESTEST.Validation;
model WD100 "Test model for BESTEST weather data: base case"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Angle lat=0.6952170009469 "Latitude angle";
  parameter Real rho=0 "Ground reflectance";
  parameter Modelica.SIunits.Length alt = 1650 "Altitude";

  WeatherData.ReaderTMY3 weaDatHHorIR(
    pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
    ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
    ceiHei=alt,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/725650.mos"),
    calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation)
    "reads all weather data and Tsky using horizontal radiation" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-88})));

  WeatherData.Bus weaBusHHorIR
    "weather bus to read all weather data and Tsky using horizontal radiation"
                               annotation (Placement(transformation(extent={{-16,
            -82},{14,-54}}), iconTransformation(extent={{-220,70},{-200,90}})));
  IsotropicAndPerezDiffuseRadiation azi000til00(
    til=IBPSA.Types.Tilt.Ceiling,
    lat=lat,
    azi=IBPSA.Types.Azimuth.S,
    rho=rho) "Azimuth = Horizontal, Tilt = 0 °"
    annotation (Placement(transformation(extent={{68,68},{88,88}})));
  IsotropicAndPerezDiffuseRadiation azi000til90(
    til=IBPSA.Types.Tilt.Wall,
    lat=lat,
    azi=IBPSA.Types.Azimuth.S,
    rho=rho) "Azimuth = South, Tilt = 90 °"
    annotation (Placement(transformation(extent={{68,36},{88,56}})));
  IsotropicAndPerezDiffuseRadiation azi270til90(
    til=IBPSA.Types.Tilt.Wall,
    lat=lat,
    azi=IBPSA.Types.Azimuth.E,
    rho=rho) "Azimuth = East, Tilt = 90 °"
    annotation (Placement(transformation(extent={{68,2},{88,22}})));
  IsotropicAndPerezDiffuseRadiation azi180til90(
    til=IBPSA.Types.Tilt.Wall,
    lat=lat,
    azi=IBPSA.Types.Azimuth.N,
    rho=rho) "Azimuth = North, Tilt = 90 °"
    annotation (Placement(transformation(extent={{66,-28},{86,-8}})));
  IsotropicAndPerezDiffuseRadiation azi090til90(
    til=IBPSA.Types.Tilt.Wall,
    lat=lat,
    azi=IBPSA.Types.Azimuth.W,
    rho=rho) "Azimuth =  West, Tilt = 90 °"
    annotation (Placement(transformation(extent={{66,-56},{86,-36}})));
  IsotropicAndPerezDiffuseRadiation azi315til90(
    til=IBPSA.Types.Tilt.Wall,
    lat=lat,
    azi=IBPSA.Types.Azimuth.SE,
    rho=rho) "Azimuth = 45 ° SE, Tilt = 0 °"
    annotation (Placement(transformation(extent={{-58,68},{-78,88}})));
  IsotropicAndPerezDiffuseRadiation azi045til90(
    til=IBPSA.Types.Tilt.Wall,
    lat=lat,
    azi=IBPSA.Types.Azimuth.SW,
    rho=rho) "Azimuth = 45 SW, Tilt = 90 °"
    annotation (Placement(transformation(extent={{-58,36},{-78,56}})));
  IsotropicAndPerezDiffuseRadiation azi270til30(
    til=0.5235987755983,
    lat=lat,
    azi=IBPSA.Types.Azimuth.E,
    rho=rho) "Azimuth = East, Tilt = 30 °"
    annotation (Placement(transformation(extent={{-58,2},{-78,22}})));
  IsotropicAndPerezDiffuseRadiation azi000til30(
    til=0.5235987755983,
    lat=lat,
    azi=IBPSA.Types.Azimuth.S,
    rho=rho) "Azimuth = South, Tilt = 0 °"
    annotation (Placement(transformation(extent={{-58,-28},{-78,-8}})));
  IsotropicAndPerezDiffuseRadiation azi090til30(
    til=0.5235987755983,
    lat=lat,
    azi=IBPSA.Types.Azimuth.W,
    rho=rho) "Azimuth = West, Tilt = 0 °"
    annotation (Placement(transformation(extent={{-58,-56},{-78,-36}})));
  Utilities.Psychrometrics.X_pTphi x_pTphi
    annotation (Placement(transformation(extent={{-48,-90},{-68,-70}})));
  Utilities.Psychrometrics.ToDryAir toDryAir
    annotation (Placement(transformation(extent={{-76,-92},{-98,-70}})));
  WeatherData.ReaderTMY3 weaDatTDryBulTDewPoinOpa(
    pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.File,
    ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter,
    ceiHei=alt,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/Data/BoundaryConditions/WeatherData/Validation/725650.mos"),
    calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover)
    "Reads all weather data and Tsky using dry bulb temperature, dew point temperature and sky cover"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={86,-82})));

  WeatherData.Bus weaBusTDryBulTDewPoinOpa
    "weather bus to read Tsky using dew point temperature and sky cover"
    annotation (Placement(transformation(extent={{36,-78},{62,-96}}),
        iconTransformation(extent={{-220,70},{-200,90}})));
equation
  connect(weaDatHHorIR.weaBus, weaBusHHorIR) annotation (Line(
      points={{6.66134e-16,-78},{6.66134e-16,-68},{-1,-68}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBusHHorIR, azi000til00.weaBus) annotation (Line(
      points={{-1,-68},{0,-68},{0,78},{68,78}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(azi000til90.weaBus,azi000til00. weaBus) annotation (Line(
      points={{68,46},{0,46},{0,78},{68,78}},
      color={255,204,51},
      thickness=0.5));
  connect(azi270til90.weaBus,azi000til00. weaBus) annotation (Line(
      points={{68,12},{0,12},{0,78},{68,78}},
      color={255,204,51},
      thickness=0.5));
  connect(azi180til90.weaBus,azi000til00. weaBus) annotation (Line(
      points={{66,-18},{0,-18},{0,78},{68,78}},
      color={255,204,51},
      thickness=0.5));
  connect(azi090til90.weaBus,azi000til00. weaBus) annotation (Line(
      points={{66,-46},{0,-46},{0,78},{68,78}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBusHHorIR, azi315til90.weaBus) annotation (Line(
      points={{-1,-68},{0,-68},{0,78},{-58,78}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(azi045til90.weaBus,azi315til90. weaBus) annotation (Line(
      points={{-58,46},{0,46},{0,78},{-58,78}},
      color={255,204,51},
      thickness=0.5));
  connect(azi270til30.weaBus,azi315til90. weaBus) annotation (Line(
      points={{-58,12},{0,12},{0,78},{-58,78}},
      color={255,204,51},
      thickness=0.5));
  connect(azi000til30.weaBus,azi315til90. weaBus) annotation (Line(
      points={{-58,-18},{0,-18},{0,78},{-58,78}},
      color={255,204,51},
      thickness=0.5));
  connect(azi090til30.weaBus,azi315til90. weaBus) annotation (Line(
      points={{-58,-46},{0,-46},{0,78},{-58,78}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBusHHorIR.pAtm, x_pTphi.p_in) annotation (Line(
      points={{-1,-68},{-34,-68},{-34,-74},{-46,-74}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBusHHorIR.TDryBul, x_pTphi.T) annotation (Line(
      points={{-1,-68},{-22,-68},{-22,-80},{-46,-80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBusHHorIR.relHum, x_pTphi.phi) annotation (Line(
      points={{-1,-68},{-18,-68},{-18,-86},{-46,-86}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(x_pTphi.X[1], toDryAir.XiTotalAir) annotation (Line(points={{-69,
          -80},{-72,-80},{-72,-81},{-74.9,-81}}, color={0,0,127}));
  connect(weaDatTDryBulTDewPoinOpa.weaBus, weaBusTDryBulTDewPoinOpa)
    annotation (Line(
      points={{86,-72},{86,-70},{49,-70},{49,-87}},
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
<p>This model is a template for all the other test cases. It allows to extrapolate all the weather data from the Reader TMY3 for a specific location, incliation and azimuth. The model <a href=\"modelica://IBPSA.BoundaryConditions.BESTEST.IsotropicAndPerezDiffuseRadiation\">IBPSA.BoundaryConditions.BESTEST.IsotropicAndPerezDiffuseRadiation</a> outputs radiation data using the available Isotropic and Perez methodlogies. The sky temperature is calculated using both the Horizontal radiation model, from data reader weaBusHorRad and the dew point temperature plus sky cover model from the datareader weaBusSkyCovDewTem</p>
</html>", revisions="<html>
<ul>
<li>
March 11, 2020, by Ettore Zanetti:<br/>
First implementation.
</li>
<li>
April 14, 2020, by Ettore Zanetti:<br/>
Rework after comments from pull request
<a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1339\">#1339</a>.
</li>
</ul>
</html>"),
experiment(
      StopTime=31539600,
      Tolerance=1e-06));
end WD100;
