within IBPSA.Electrical.DC.Sources.Validation;
model PVSingleDiodeRooftopBuildingValidation
  "Validation with empirical data from a rooftop PV system in at UdK, Berlin"
  extends Modelica.Icons.Example;
    parameter Modelica.Units.SI.Time timZon=+7200
    "Time zone";
  parameter Modelica.Units.SI.Angle lon=0.20934
    "Longitude";
  parameter Modelica.Units.SI.Angle lat=0.82481257
    "Latitude";
  constant Real G_sc(
    final quantity="Irradiance",
    final unit = "W/m2") = 1376
    "Solar constant";
  Modelica.Units.SI.Irradiance HGloHor;
  Modelica.Units.SI.Irradiance HGloHorDif;
  Real k_t(final unit="1", start=0.5) "Clearness index";
  IBPSA.Electrical.DC.Sources.PVSingleDiode pVSystemSingleDiode(
    PVTechType=IBPSA.Electrical.BaseClasses.PV.BaseClasses.PVOptical.PVType.ThinFilmSI,
    til=0.05235987755983,
    azi=0,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountCloseToGround
      partialPVThermal,
    n_mod=6,
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSolibroSL2CIGS110 data,
    groRef=0.2,
    alt=0.08)
    annotation (Placement(transformation(extent={{64,0},{84,20}})));

  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{42,-14},{54,-2}})));
  Modelica.Blocks.Interfaces.RealOutput PSim
    "Simulated DC output power"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput PMea
    "Measured DC power"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface HGloTil(
    til=pVSystemSingleDiode.til,
    azi=pVSystemSingleDiode.azi)
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
  BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(
    timZon=timZon,
    lon=lon)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  BoundaryConditions.WeatherData.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Constant nDay(k=(31 + 28 + 31 + 17)*24*3600)
    "Number of validation day (April 18th 2023) in seconds"
    annotation (Placement(transformation(extent={{-98,-44},{-82,-28}})));
  IBPSA.Utilities.Time.ModelTime modTim
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Math.Add calcClockTime(
    k2=-1)
    "Computes clock time"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=0,origin={-58,-42})));

  BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incAng(
    azi=pVSystemSingleDiode.azi,
    til=pVSystemSingleDiode.til)
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Sources.RealExpression souHGloHorDif(
    y=HGloHorDif)
    annotation (Placement(transformation(extent={{6,-102},{26,-82}})));
  Modelica.Blocks.Sources.Constant souAlt(k=pVSystemSingleDiode.alt)
    "Altitude"
    annotation (Placement(transformation(extent={{-14,56},{2,72}})));
  Modelica.Blocks.Sources.CombiTimeTable VPTdata_weather1(
    tableOnFile=true,
    tableName="ROF-rad_module_temp_2023",
    fileName=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/UdK_VPT_ROF_radiation_module_temperature_2023_V2.txt"),
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=(31 + 28 + 31 + 17)*86400)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{42,-32},{50,-24}})));

  Modelica.Blocks.Sources.CombiTimeTable VPTdata_weather2(
    tableOnFile=true,
    tableName="ROF_wind-angle_speed_2023",
    fileName=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/UdK_VPT_ROF_wind-angle_speed_2023_V2.txt"),
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=(31 + 28 + 31 + 17)*86400)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{42,-44},{50,-36}})));

  Modelica.Blocks.Sources.CombiTimeTable VPTdata_weather3(
    tableOnFile=true,
    tableName="ROF_outside_temp_2023",
    fileName=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/UdK_VPT_ROF_outside_temperature_2023_V2.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=(31 + 28 + 31 + 17)*86400)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{42,-56},{50,-48}})));

  Modelica.Blocks.Sources.CombiTimeTable VPTdata_power(
    tableOnFile=true,
    tableName="power_2023",
    fileName=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/UdK_VPT_ROF_P1_1_2_power_2023_V2.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=(31 + 28 + 31 + 17)*86400)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{78,-36},{90,-24}})));

equation
  //Approximation of diffuse horizontal irradiation still necessary because
  //NIST data does not contain this measurement so far. Work in progress
  //nDay = floor(modTim.y/86400)*86400
  // "Zero-based day number in seconds (January 1=0, January 2=86400)";
  HGloHor= VPTdata_weather1.y[1];

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

  connect(from_degC.y, pVSystemSingleDiode.TDryBul) annotation (Line(points={{54.6,-8},
          {58,-8},{58,4},{54,4},{54,10.5},{62,10.5}},
                                             color={0,0,127}));
  connect(pVSystemSingleDiode.P, PSim)
    annotation (Line(points={{85,7},{96,7},{96,10},{110,10}},
                                                  color={0,0,127}));
  connect(HGloTil.weaBus, weaBus) annotation (Line(
      points={{38,50},{26,50}},
      color={255,204,51},
      thickness=0.5));
  connect(HGloTil.H, pVSystemSingleDiode.HGloTil) annotation (Line(points={{59,50},
          {64,50},{64,24},{56,24},{56,14},{62,14}},
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
  connect(zen.y, pVSystemSingleDiode.zenAngle)
    annotation (Line(points={{41,82},{64,82},{64,76},{62,76},{62,20}},
                                                      color={0,0,127}));
  connect(decAng.decAng, incAng.decAng) annotation (Line(points={{-37,10},{-32,10},
          {-32,16},{18,16},{18,28},{32,28},{32,-84.6},{37.8,-84.6}}, color={0,0,
          127}));
  connect(incAng.incAng, pVSystemSingleDiode.incAngle) annotation (Line(points={{61,-90},
          {70,-90},{70,-4},{86,-4},{86,24},{58,24},{58,26},{54,26},{54,18},{62,18}},
                        color={0,0,127}));
  connect(souHGloHorDif.y, pVSystemSingleDiode.HDifHor) annotation (Line(points={{27,-92},
          {32,-92},{32,-60},{34,-60},{34,18},{52,18},{52,28},{62,28},{62,16}},
                color={0,0,127}));
  connect(latLon[1].y, incAng.lat) annotation (Line(points={{-81.2,50},{12,50},{
          12,12},{36,12},{36,-64},{34,-64},{34,-90},{38,-90}}, color={0,0,127}));
  connect(solHouAng.solHouAng, incAng.solHouAng) annotation (Line(points={{21,-10},
          {34,-10},{34,-94.8},{38,-94.8}}, color={0,0,127}));
  connect(souHGloHorDif.y, weaBus.HDifHor) annotation (Line(points={{27,-92},{32,
          -92},{32,-60},{34,-60},{34,34},{26,34},{26,50}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(souAlt.y, weaBus.alt) annotation (Line(points={{2.8,64},{10,64},{10,66},
          {26,66},{26,50}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(VPTdata_power.y[1], PMea)
    annotation (Line(points={{90.6,-30},{110,-30}}, color={0,0,127}));
  connect(VPTdata_weather3.y[1], from_degC.u) annotation (Line(points={{50.4,-52},
          {54,-52},{54,-18},{40.8,-18},{40.8,-8}}, color={0,0,127}));
  connect(VPTdata_weather2.y[1], pVSystemSingleDiode.vWinSpe)
    annotation (Line(points={{50.4,-40},{62,-40},{62,9}}, color={0,0,127}));
  connect(VPTdata_weather1.y[1], weaBus.HGloHor) annotation (Line(points={{50.4,
          -28},{52,-28},{52,-20},{26,-20},{26,50}}, color={0,0,127}));
  connect(VPTdata_weather1.y[1], pVSystemSingleDiode.HGloHor) annotation (Line(
        points={{50.4,-28},{52,-28},{52,-20},{26,-20},{26,10},{52,10},{52,12},{62,
          12}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            100,100}})),
    experiment(
      StartTime=9244800,
      StopTime=10105920,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
   __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVSingleDiodeRooftopBuildingValidation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>The PVSystem single-diode model is validaded with empirical data from the Rooftop solar builidng of UdK Berlin: <a href=\"http://www.solar-rooftop.de/\">http://www.solar-rooftop.de/</a> </p>
<p>The dates 18.04.2023 to 28.04.2023 were chosen as an example for the PVSystem model. </p>
<p>The validation model proves that single diode PV models tend to overestimate the power output.</p>
<p>This is due to the neglection of staining, shading, other loss effects.</p>
</html>",revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVSingleDiodeRooftopBuildingValidation;
