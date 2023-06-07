within IBPSA.Electrical.DC.Sources.Validation.BaseClasses;
partial model partialPVRooftopBuildingValidation
  "Partial model for validation with empirical data from a rooftop PV system in at UdK, Berlin, from May 21st to May 31st"
  extends Modelica.Icons.Example;
    parameter Modelica.Units.SI.Time timZon=+7200
    "Time zone";
  parameter Modelica.Units.SI.Angle lon=0.20934
    "Longitude";
  parameter Modelica.Units.SI.Angle lat=0.82481257
    "Latitude";
  parameter Real nDay=(31 + 28 + 31 + 30 + 21)*24*3600 "Day at which simulation starts"
                                                                                       annotation(final unit="s");
  parameter Modelica.Units.SI.Angle azi=0
    "Surface azimuth. azi=-90 degree if surface outward unit normal points toward east; azi=0 if it points toward south";
  parameter Modelica.Units.SI.Angle til=0.05235987755983
    "Surface tilt. til=90 degree for walls; til=0 for ceilings; til=180 for roof";
  parameter Real alt= 2 "Site altitude"
                                       annotation(final unit="m");

  constant Real G_sc(
    final quantity="Irradiance",
    final unit = "W/m2") = 1376
    "Solar constant";


  Modelica.Units.SI.Irradiance HGloHor;
  Modelica.Units.SI.Irradiance HGloHorDif;
  Real k_t(final unit="1", start=0.5) "Clearness index";

  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{42,-14},{54,-2}})));
  Modelica.Blocks.Interfaces.RealOutput PSim
    "Simulated DC output power"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput PMea
    "Measured DC power"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface HGloTil(til=til,
      azi=azi,
    rho=rho)
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  BoundaryConditions.WeatherData.Bus weaBus
    "Bus with weather data"
    annotation (Placement(transformation(extent={{16,40},{36,60}})));
  Modelica.Blocks.Sources.Constant latLon[2](
    k={lat,lon})
    "Latitude and Longitude for tilt irradiation block"
    annotation (Placement(transformation(extent={{-98,42},{-82,58}})));
  BoundaryConditions.SolarGeometry.ZenithAngle zen
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  BoundaryConditions.WeatherData.Bus weaBus1
    "Weather data"
    annotation (Placement(transformation(extent={{-36,24},{-16,44}})));
  BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
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
  Modelica.Blocks.Sources.Constant sounDay(k=nDay)
    "Number of validation day (April 18th 2023) in seconds"
    annotation (Placement(transformation(extent={{-98,-44},{-82,-28}})));
  IBPSA.Utilities.Time.ModelTime modTim
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Math.Add calcClockTime(
    k2=-1)
    "Computes clock time"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=0,origin={-58,-42})));

  BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incAng(azi=azi,
      til=til)
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Sources.RealExpression souHGloHorDif(
    y=HGloHorDif)
    annotation (Placement(transformation(extent={{6,-102},{26,-82}})));
  Modelica.Blocks.Sources.Constant souAlt(k=alt)
    "Altitude"
    annotation (Placement(transformation(extent={{-58,62},{-42,78}})));
  Modelica.Blocks.Sources.CombiTimeTable MeaDataRadModTemp(
    tableOnFile=true,
    tableName="ROF-rad_module_temp_2023",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/UdK_VPT_ROF_radiation_module_temperature_2023_V2.txt"),
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{80,-68},{88,-60}})));

  Modelica.Blocks.Sources.CombiTimeTable MeaDataWinAngSpe(
    tableOnFile=true,
    tableName="ROF_wind-angle_speed_2023",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/UdK_VPT_ROF_wind-angle_speed_2023_V2.txt"),
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{42,-44},{50,-36}})));

  Modelica.Blocks.Sources.CombiTimeTable MeaDataTAmb(
    tableOnFile=true,
    tableName="ROF_outside_temp_2023",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/UdK_VPT_ROF_outside_temperature_2023_V2.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{42,-56},{50,-48}})));

  Modelica.Blocks.Sources.CombiTimeTable VPTdata_power(
    tableOnFile=true,
    tableName="power_2023",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/UdK_VPT_ROF_P1_1_2_power_2023_V2.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay + 600)
    "The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de"
    annotation (Placement(transformation(extent={{78,-36},{90,-24}})));

  Modelica.Blocks.Sources.RealExpression souGloHorDif(y=HGloHorDif)
    annotation (Placement(transformation(extent={{100,40},{80,60}})));
  parameter Real rho=0.2 "Ground reflectance";
equation
  //Approximation of diffuse horizontal irradiation still necessary because
  //NIST data does not contain this measurement so far. Work in progress

  // "Zero-based day number in seconds (January 1=0, January 2=86400)";
  HGloHor=MeaDataRadModTemp.y[1];

  k_t =if HGloHor <= 0.01 then 0 else min(1, max(0, (HGloHor)/(G_sc*(1.00011 + 0.034221
    *cos(2*Modelica.Constants.pi*sounDay.k/24/60/60/365) + 0.00128*sin(2*
    Modelica.Constants.pi*sounDay.k/24/60/60/365) + 0.000719*cos(2*2*Modelica.Constants.pi
    *sounDay.k/24/60/60/365) + 0.000077*sin(2*2*Modelica.Constants.pi*sounDay.k/
    24/60/60/365))*cos(zen.y))))                                            "following (Iqbal,1983)";

  // Erb´s diffuse fraction relation
  HGloHorDif = if HGloHor <=0.01 then
                 0
               elseif k_t <= 0.22 then
                 (HGloHor)*(1.0-0.09*k_t)
               elseif k_t > 0.8 then
                 (HGloHor)*0.165
               else
                 (HGloHor)*(0.9511-0.1604*k_t+4.388*k_t^2-16.638*k_t^3+12.336*k_t^4);

  connect(HGloTil.weaBus, weaBus) annotation (Line(
      points={{40,70},{26,70},{26,50}},
      color={255,204,51},
      thickness=0.5));
  connect(latLon[1].y, weaBus.lat)
    annotation (Line(points={{-81.2,50},{26,50}},color={0,0,127}));
  connect(latLon[2].y, weaBus.lon)
    annotation (Line(points={{-81.2,50},{26,50}},color={0,0,127}));
  connect(zen.weaBus, weaBus1) annotation (Line(
      points={{0,90},{-26,90},{-26,34}},
      color={255,204,51},
      thickness=0.5));
  connect(zen.y, weaBus.solZen)
    annotation (Line(points={{21,90},{26,90},{26,50}},
                                                    color={0,0,127}));
  connect(latLon[1].y, weaBus1.lat)
    annotation (Line(points={{-81.2,50},{-26,50},{-26,34}}, color={0,0,127}));
  connect(decAng.decAng, weaBus1.solDec) annotation (Line(points={{-39,10},{-32,
          10},{-32,34},{-26,34}},          color={0,0,127}));
  connect(solHouAng.solHouAng, weaBus1.solHouAng) annotation (Line(points={{21,-10},
          {26,-10},{26,34},{-26,34}},               color={0,0,127}));
  connect(solTim.solTim, solHouAng.solTim)
    annotation (Line(points={{1,-70},{26,-70},{26,-24},{-8,-24},{-8,-10},{-2,
          -10}},                                   color={0,0,127}));
  connect(decAng.decAng, weaBus.solDec) annotation (Line(points={{-39,10},{-32,
          10},{-32,16},{-6,16},{-6,50},{26,50}},
                                   color={0,0,127}));
  connect(solHouAng.solHouAng, weaBus.solHouAng) annotation (Line(points={{21,-10},
          {21,50},{26,50}},
        color={0,0,127}));
  connect(locTim.locTim, solTim.locTim) annotation (Line(points={{-19,-30},{-20,
          -30},{-20,-44},{-36,-44},{-36,-75.4},{-22,-75.4}},
                                         color={0,0,127}));
  connect(eqnTim.eqnTim, solTim.equTim)
    annotation (Line(points={{-59,-10},{-16,-10},{-16,-56},{-28,-56},{-28,-64},
          {-22,-64}},                                      color={0,0,127}));
  connect(sounDay.y, eqnTim.nDay) annotation (Line(points={{-81.2,-36},{-96,-36},
          {-96,-10},{-82,-10}}, color={0,0,127}));
  connect(sounDay.y, decAng.nDay) annotation (Line(points={{-81.2,-36},{-96,-36},
          {-96,18},{-68,18},{-68,10},{-62,10}}, color={0,0,127}));
  connect(calcClockTime.y, locTim.cloTim) annotation (Line(points={{-47,-42},{
          -46,-42},{-46,-30},{-42,-30}},
                                     color={0,0,127}));
  connect(modTim.y, calcClockTime.u1) annotation (Line(points={{-79,-70},{-72,
          -70},{-72,-54},{-76,-54},{-76,-48},{-70,-48}},
                                                    color={0,0,127}));
  connect(sounDay.y, calcClockTime.u2)
    annotation (Line(points={{-81.2,-36},{-70,-36}}, color={0,0,127}));
  connect(solTim.solTim, weaBus.solTim)
    annotation (Line(points={{1,-70},{26,-70},{26,50}},  color={0,0,127}));
  connect(calcClockTime.y, weaBus.cloTim)
    annotation (Line(points={{-47,-42},{26,-42},{26,50}}, color={0,0,127}));
  connect(decAng.decAng, incAng.decAng) annotation (Line(points={{-39,10},{-32,
          10},{-32,16},{18,16},{18,28},{32,28},{32,-84.6},{37.8,-84.6}},
                                                                     color={0,0,
          127}));
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
  connect(souAlt.y, weaBus.alt) annotation (Line(points={{-41.2,70},{-36,70},{
          -36,50},{26,50}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(VPTdata_power.y[1], PMea)
    annotation (Line(points={{90.6,-30},{110,-30}}, color={0,0,127}));
  connect(MeaDataTAmb.y[1], from_degC.u) annotation (Line(points={{50.4,-52},{54,
          -52},{54,-18},{40.8,-18},{40.8,-8}}, color={0,0,127}));
  connect(MeaDataRadModTemp.y[1], weaBus.HGloHor) annotation (Line(points={{88.4,
          -64},{92,-64},{92,-40},{60,-40},{60,50},{26,50}},
                                                    color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            100,100}})),
    experiment(
      StartTime=9244800,
      StopTime=10108800,
      Interval=10,
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
end partialPVRooftopBuildingValidation;
