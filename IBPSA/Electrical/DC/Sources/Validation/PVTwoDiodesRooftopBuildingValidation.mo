within IBPSA.Electrical.DC.Sources.Validation;
model PVTwoDiodesRooftopBuildingValidation
  "Validation with empirical data from a rooftop PV system in at UdK, Berlin"
  extends Modelica.Icons.Example;
  IBPSA.Electrical.DC.Sources.PVTwoDiodes pVSystemTwoDiodes(
    til=0.05235987755983,
    azi=0,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountOpenRack partialPVThermal,
    n_mod=6,
    redeclare IBPSA.Electrical.Data.PV.TwoDiodesSolibroSL2CIGS110 data,
    groRef=0.2,
    alt=0.08)
    annotation (Placement(transformation(extent={{62,0},{82,20}})));
  Modelica.Blocks.Sources.CombiTimeTable VPTdata_weather1(
    tableOnFile=true,
    tableName="ROF-rad_module_temp_2023",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/weatherdata/UdK_VPT_ROF_radiation_module_temperature_2023_V2.txt"),
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=(31 + 28 + 31 + 17)*86400)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{48,-32},{56,-24}})));

  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{42,-14},{54,-2}})));
  Modelica.Blocks.Interfaces.RealOutput PSim
    "Simulated DC output power"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput PMea
    "Measured DC power"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface HGloTil(
    til=pVSystemTwoDiodes.til,
    azi=pVSystemTwoDiodes.azi)
    annotation (Placement(transformation(extent={{38,40},{58,60}})));
  BoundaryConditions.WeatherData.Bus weaBus
    "Bus with weather data"
    annotation (Placement(transformation(extent={{16,40},{36,60}})));
  Modelica.Blocks.Sources.Constant latLon[2](
    k={lat,lon})
    "Latitude and Longitude for tilt irradiation block"
    annotation (Placement(transformation(extent={{-98,42},{-82,58}})));
  BoundaryConditions.SolarGeometry.ZenithAngle zen
    annotation (Placement(transformation(extent={{20,72},{40,92}})));
  BoundaryConditions.WeatherData.Bus weaBus1
    "Weather data"
    annotation (Placement(transformation(extent={{-44,20},{-24,40}})));
  BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    annotation (Placement(transformation(extent={{-58,0},{-38,20}})));
  BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle solHouAng
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  BoundaryConditions.WeatherData.BaseClasses.SolarTime solTim
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(timZon=
    timZon,
    lon=lon)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  BoundaryConditions.WeatherData.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Constant nDay(k=(31 + 28 + 31 + 17)*24*3600)
    "Number of validation day (March 16th 2023) in seconds"
    annotation (Placement(transformation(extent={{-98,-44},{-82,-28}})));
  IBPSA.Utilities.Time.ModelTime modTim
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Math.Add calcClockTime(k2=-1)
    "Computes clock time"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=0,origin={-58,-42})));
  parameter Modelica.Units.SI.Time timZon=-18000
    "Time zone";
  parameter Modelica.Units.SI.Angle lon=-1.3476664539029
    "Longitude";
  parameter Modelica.Units.SI.Angle lat=0.68304158408499
    "Latitude";
  constant Real G_sc(final quantity="Irradiance",
  final unit = "W/m2") = 1376 "Solar constant";
  Modelica.Units.SI.Irradiance HGloHor;
  Modelica.Units.SI.Irradiance HGloHorDif;
  Real k_t(final unit="1", start=0.5)
    "Clearness index";
  BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incAng(
    azi=pVSystemTwoDiodes.azi,
    til=pVSystemTwoDiodes.til)
    annotation (Placement(transformation(extent={{44,-84},{64,-64}})));
  Modelica.Blocks.Sources.RealExpression souHGloHorDif(y=HGloHorDif)
    annotation (Placement(transformation(extent={{6,-102},{26,-82}})));
  Modelica.Blocks.Sources.Constant souAlt(k=pVSystemTwoDiodes.alt)
    "Altitude"
    annotation (Placement(transformation(extent={{-18,58},{-2,74}})));
  Modelica.Blocks.Sources.CombiTimeTable VPTdata_weather2(
    tableOnFile=true,
    tableName="ROF_wind-angle_speed_2023",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/weatherdata/UdK_VPT_ROF_wind-angle_speed_2023_V2.txt"),
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=(31 + 28 + 31 + 17)*86400)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{48,-44},{56,-36}})));

  Modelica.Blocks.Sources.CombiTimeTable VPTdata_power(
    tableOnFile=true,
    tableName="power_2023",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/weatherdata/UdK_VPT_ROF_P1_1_2_power_2023_V2.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=(31 + 28 + 31 + 17)*86400)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{78,-36},{90,-24}})));

  Modelica.Blocks.Sources.CombiTimeTable VPTdata_weather3(
    tableOnFile=true,
    tableName="ROF_outside_temp_2023",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/weatherdata/UdK_VPT_ROF_outside_temperature_2023_V2.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=(31 + 28 + 31 + 17)*86400)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{48,-56},{56,-48}})));

equation
  //Approximation of diffuse horizontal irradiation still necessary because
  //Rooftop building data does not contain this measurement so far. Work in progress
  //nDay = floor(modTim.y/86400)*86400
  // "Zero-based day number in seconds (January 1=0, January 2=86400)";
  HGloHor=VPTdata_weather1.y[1];

  k_t = if HGloHor <=0.01 then
          0
        else
          min(1,max(0,(HGloHor)/(G_sc*(1.00011+0.034221*
          cos(2*Modelica.Constants.pi*nDay.k/24/60/60/365)+
          0.00128*sin(2*Modelica.Constants.pi*nDay.k/24/60/60/365)
          +0.000719*cos(2*2*Modelica.Constants.pi*nDay.k/24/60/60/365)+0.000077*
          sin(2*2*Modelica.Constants.pi*nDay.k/24/60/60/365))*cos(zen.y)))) "following (Iqbal,1983)";

  // Erb´s diffuse fraction relation
  HGloHorDif = if HGloHor <=0.01 then
                 0
               elseif k_t <= 0.22 then
                 (HGloHor)*(1.0-0.09*k_t)
               elseif k_t > 0.8 then
                 (HGloHor)*0.165
               else
                 (HGloHor)*(0.9511-0.1604*k_t+4.388*k_t^2-16.638*k_t^3+12.336*k_t^4);

    connect(from_degC.y, pVSystemTwoDiodes.TDryBul) annotation (Line(points={{54.6,-8},
            {58,-8},{58,4},{54,4},{54,10.5},{60,10.5}},
                                               color={0,0,127}));
    connect(pVSystemTwoDiodes.P, PSim)
      annotation (Line(points={{83,7},{96,7},{96,10},{110,10}},
                                                    color={0,0,127}));
    connect(HGloTil.weaBus, weaBus) annotation (Line(
        points={{38,50},{26,50}},
        color={255,204,51},
        thickness=0.5));
    connect(HGloTil.H, pVSystemTwoDiodes.HGloTil) annotation (Line(points={{59,50},
            {64,50},{64,24},{56,24},{56,14},{60,14}},
                                            color={0,0,127}));
    connect(latLon[1].y, weaBus.lat)
      annotation (Line(points={{-81.2,50},{26,50}},color={0,0,127}));
    connect(latLon[2].y, weaBus.lon)
      annotation (Line(points={{-81.2,50},{26,50}},color={0,0,127}));
    connect(zen.weaBus, weaBus1) annotation (Line(
        points={{20,82},{-34,82},{-34,30}},
        color={255,204,51},
        thickness=0.5));
    connect(zen.y, weaBus.solZen)
      annotation (Line(points={{41,82},{46,82},{46,64},{26,64},{26,50}},
                                                      color={0,0,127}));
    connect(latLon[1].y, weaBus1.lat)
      annotation (Line(points={{-81.2,50},{-34,50},{-34,30}}, color={0,0,127}));
    connect(decAng.decAng, weaBus1.solDec) annotation (Line(points={{-37,10},{-32,
            10},{-32,14},{-34,14},{-34,30}}, color={0,0,127}));
    connect(solHouAng.solHouAng, weaBus1.solHouAng) annotation (Line(points={{21,-10},
            {26,-10},{26,30},{-34,30}},               color={0,0,127}));
    connect(solTim.solTim, solHouAng.solTim)
      annotation (Line(points={{1,-70},{26,-70},{26,-24},{-8,-24},{-8,-10},{-2,
            -10}},                                   color={0,0,127}));
    connect(decAng.decAng, weaBus.solDec) annotation (Line(points={{-37,10},{-32,10},
            {-32,16},{18,16},{18,28},{26,28},{26,50}},
                                     color={0,0,127}));
    connect(solHouAng.solHouAng, weaBus.solHouAng) annotation (Line(points={{21,-10},
            {26,-10},{26,50}},
          color={0,0,127}));
    connect(locTim.locTim, solTim.locTim) annotation (Line(points={{-19,-30},{-20,
            -30},{-20,-44},{-36,-44},{-36,-75.4},{-22,-75.4}},
                                           color={0,0,127}));
    connect(eqnTim.eqnTim, solTim.equTim)
      annotation (Line(points={{-59,-10},{-16,-10},{-16,-56},{-28,-56},{-28,-64},
            {-22,-64}},                                      color={0,0,127}));
    connect(nDay.y, eqnTim.nDay) annotation (Line(points={{-81.2,-36},{-96,-36},{
            -96,-10},{-82,-10}},
                            color={0,0,127}));
    connect(nDay.y, decAng.nDay) annotation (Line(points={{-81.2,-36},{-96,-36},{
            -96,18},{-68,18},{-68,10},{-60,10}},
                                             color={0,0,127}));
    connect(calcClockTime.y, locTim.cloTim) annotation (Line(points={{-47,-42},{
            -46,-42},{-46,-30},{-42,-30}},
                                       color={0,0,127}));
    connect(modTim.y, calcClockTime.u1) annotation (Line(points={{-79,-70},{-72,
            -70},{-72,-54},{-76,-54},{-76,-48},{-70,-48}},
                                                      color={0,0,127}));
    connect(nDay.y, calcClockTime.u2) annotation (Line(points={{-81.2,-36},{-70,
            -36}},                color={0,0,127}));
    connect(solTim.solTim, weaBus.solTim)
      annotation (Line(points={{1,-70},{26,-70},{26,50}},  color={0,0,127}));
    connect(calcClockTime.y, weaBus.cloTim)
      annotation (Line(points={{-47,-42},{26,-42},{26,50}}, color={0,0,127}));
    connect(zen.y, pVSystemTwoDiodes.zenAngle)
      annotation (Line(points={{41,82},{64,82},{64,76},{62,76},{62,26},{60,26},{
            60,20}},                                    color={0,0,127}));
    connect(decAng.decAng, incAng.decAng) annotation (Line(points={{-37,10},{
          -32,10},{-32,16},{18,16},{18,28},{32,28},{32,-68.6},{41.8,-68.6}},
                                                                       color={0,0,
            127}));
    connect(incAng.incAng, pVSystemTwoDiodes.incAngle) annotation (Line(points={{65,-74},
          {70,-74},{70,-4},{86,-4},{86,24},{58,24},{58,26},{54,26},{54,18},{60,
          18}},           color={0,0,127}));
    connect(souHGloHorDif.y, pVSystemTwoDiodes.HDifHor) annotation (Line(points=
           {{27,-92},{32,-92},{32,-60},{34,-60},{34,18},{52,18},{52,28},{60,28},{60,
            16}}, color={0,0,127}));
    connect(latLon[1].y, incAng.lat) annotation (Line(points={{-81.2,50},{12,50},
          {12,12},{36,12},{36,-64},{34,-64},{34,-74},{42,-74}},  color={0,0,127}));
    connect(solHouAng.solHouAng, incAng.solHouAng) annotation (Line(points={{21,-10},
          {34,-10},{34,-78.8},{42,-78.8}},   color={0,0,127}));
    connect(souHGloHorDif.y, weaBus.HDifHor) annotation (Line(points={{27,-92},{32,
            -92},{32,-60},{34,-60},{34,34},{26,34},{26,50}}, color={0,0,127}),
        Text(
        string="%second",
        index=1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(souAlt.y, weaBus.alt) annotation (Line(points={{-1.2,66},{26,66},{26,
          50}},               color={0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));

  connect(VPTdata_weather2.y[1], pVSystemTwoDiodes.vWinSpe) annotation (Line(
        points={{56.4,-40},{62,-40},{62,6},{60,6},{60,9}}, color={0,0,127}));
  connect(VPTdata_power.y[1], PMea)
    annotation (Line(points={{90.6,-30},{110,-30}}, color={0,0,127}));
  connect(VPTdata_weather1.y[1], pVSystemTwoDiodes.HGloHor) annotation (Line(
        points={{56.4,-28},{62,-28},{62,4},{52,4},{52,12},{60,12}}, color={0,0,127}));
  connect(VPTdata_weather1.y[1], weaBus.HGloHor) annotation (Line(points={{56.4,
          -28},{64,-28},{64,2},{26,2},{26,50}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(VPTdata_weather3.y[1], from_degC.u) annotation (Line(points={{56.4,
          -52},{58,-52},{58,-18},{38,-18},{38,-8},{40.8,-8}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            100,100}})),
    experiment(
      StartTime=9244800,
      StopTime=9331200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
   __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVTwoDiodesRooftopBuildingValidation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
    <p>The PVSystem 2 diode model is validaded with empirical data from the Rooftop solar builidng of UdK Berlin: <a href=\"http://www.solar-rooftop.de/\">http://www.solar-rooftop.de/</a> </p>
<p>The date 18.04.2023 was chosen as an example for the PVSystem model. </p>
</html>",revisions="<html>
<ul>
<li>
March 30, 2023, by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVTwoDiodesRooftopBuildingValidation;
