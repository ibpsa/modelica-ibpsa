within IBPSA.Electrical.DC.Sources.Validation.BaseClasses;
partial model partialPVRooftopBuildingValidation
  "Partial model for validation with empirical data from a rooftop PV system in
  at UdK, Berlin, from July 27th to Aug 9th"
  extends Modelica.Icons.Example;
    parameter Modelica.Units.SI.Time timZon=+7200
    "Time zone";
  parameter Modelica.Units.SI.Angle lon=0.20934
    "Longitude";
  parameter Modelica.Units.SI.Angle lat=0.82481257
    "Latitude";
  parameter Real nDay=(31+28+31+30+31+30+28)*24*3600 "Day at which simulation starts"
                                                                                     annotation(final unit="s");
  parameter Modelica.Units.SI.Angle azi=27.5*Modelica.Constants.pi/180
    "Surface azimuth. azi=-90 degree if surface outward unit normal points toward east; azi=0 if it points toward south";
  parameter Modelica.Units.SI.Angle til=2*Modelica.Constants.pi/180
    "Surface tilt. til=90 degree for walls; til=0 for ceilings; til=180 for roof";
  parameter Real alt= 2 "Site altitude"
                                       annotation(final unit="m");

  parameter Real rho=0.2 "Ground reflectance";

  constant Real G_sc(
    final quantity="Irradiance",
    final unit = "W/m2") = 1376
    "Solar constant";

  Modelica.Units.SI.Irradiance HGloHor;
  Modelica.Units.SI.Irradiance HGloHorDif;
  Real k_t(final unit="1", start=0.5) "Clearness index";

  Modelica.Blocks.Interfaces.RealOutput PDCSim "Simulated DC output power"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput PDCMea "Measured DC power"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface HGloTil(til=til,
      azi=azi,
    rho=rho)
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  Modelica.Blocks.Sources.CombiTimeTable MeaDatHGloHor(
    tableOnFile=true,
    tableName="MeaDatHGloHor",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/Solar_irradiation_PV.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay)
    "This file contains the global horizontal irradiation. The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de."
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Modelica.Blocks.Sources.CombiTimeTable MeaDatWinAngSpe(
    tableOnFile=true,
    tableName="MeaDatWinAngSpe",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/Wind_angle_speed_PV.txt"),
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    extrapolation=Modelica.Blocks.Types.Extrapolation.LastTwoPoints,
    shiftTime=nDay,
    verboseExtrapolation=false)
    "This file contains the wind speed and angle. The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de."
    annotation (Placement(transformation(extent={{-100,0},{-78,22}})));

  Modelica.Blocks.Sources.CombiTimeTable MeaDatTDryBul(
    tableOnFile=true,
    tableName="MeaDatTDryBul",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/Ambient_temperature_PV.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay)
    "This file contains the ambient temperature. The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de."
    annotation (Placement(transformation(extent={{-98,-60},{-80,-42}})));

  Modelica.Blocks.Sources.CombiTimeTable MeaDatPVPDC(
    tableOnFile=true,
    tableName="MeaDatPVPDC",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/DC_Power_PV.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay)
    "This file contains the DC power output of two selected modules. The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de."
    annotation (Placement(transformation(extent={{78,-36},{90,-24}})));

  Modelica.Blocks.Sources.RealExpression souGloHorDif(y=HGloHorDif)
    annotation (Placement(transformation(extent={{-100,-34},{-80,-14}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=ModelicaServices.ExternalReferences.loadResource(
        "modelica://IBPSA/Resources/weatherdata/Weather_TRY_Berlin_winter.mos"),
    TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.Input,
    winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.Input,
    HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor)
    annotation (Placement(transformation(extent={{-38,2},{-18,22}})));

  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{-62,-58},{-50,-46}})));
  Modelica.Blocks.Sources.Constant sounDay(k=nDay)
    "Number of validation day (April 18th 2023) in seconds"
    annotation (Placement(transformation(extent={{-14,-78},{2,-62}})));
  BoundaryConditions.SolarGeometry.IncidenceAngle incAng(azi=azi, til=til)
    annotation (Placement(transformation(extent={{16,-34},{26,-24}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-16,-20},{4,0}})));
  Modelica.Blocks.Routing.RealPassThrough zen
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Sources.CombiTimeTable MeaDatTMod(
    tableOnFile=true,
    tableName="MeaDatTMod",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/Module_temperature_PV.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay)
    "This file contains the module temperature of two selected modules. The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de."
    annotation (Placement(transformation(extent={{80,-76},{92,-64}})));

  Modelica.Blocks.Interfaces.RealOutput TModMea "Measure module temperature"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
equation
  //Approximation of diffuse horizontal irradiation still necessary because
  //NIST data does not contain this measurement so far. Work in progress

  // "Zero-based day number in seconds (January 1=0, January 2=86400)";
  HGloHor=MeaDatHGloHor.y[1];

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

  connect(MeaDatPVPDC.y[1], PDCMea)
    annotation (Line(points={{90.6,-30},{110,-30}}, color={0,0,127}));
  connect(weaDat.weaBus, HGloTil.weaBus) annotation (Line(
      points={{-18,12},{34,12},{34,70},{40,70}},
      color={255,204,51},
      thickness=0.5));
  connect(souGloHorDif.y, weaDat.HDifHor_in) annotation (Line(points={{-79,-24},
          {-60,-24},{-60,2.5},{-39,2.5}}, color={0,0,127}));
  connect(MeaDatTDryBul.y[1], from_degC.u) annotation (Line(points={{-79.1,-51},
          {-69.15,-51},{-69.15,-52},{-63.2,-52}}, color={0,0,127}));
  connect(from_degC.y, weaDat.TDryBul_in) annotation (Line(points={{-49.4,-52},{
          -42,-52},{-42,-6},{-44,-6},{-44,21},{-39,21}}, color={0,0,127}));
  connect(MeaDatHGloHor.y[1], weaDat.HGloHor_in)
    annotation (Line(points={{-79,-90},{-39,-90},{-39,-1}}, color={0,0,127}));
  connect(weaDat.weaBus, incAng.weaBus) annotation (Line(
      points={{-18,12},{10,12},{10,-29},{16,-29}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-18,12},{-6,12},{-6,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.solZen, zen.u) annotation (Line(
      points={{-6,-10},{-6,-50},{38,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(MeaDatTMod.y[1], TModMea)
    annotation (Line(points={{92.6,-70},{110,-70}}, color={0,0,127}));
  connect(MeaDatWinAngSpe.y[2], weaDat.winSpe_in) annotation (Line(points={{-76.9,
          11},{-76.9,10},{-46,10},{-46,8.1},{-39,8.1}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            100,100}})),
    experiment(
      StartTime=18057600,
      StopTime=19008000,
      Interval=300,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
   __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVSingleDiodeRooftopBuildingValidation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>The PVSystem single-diode model is validaded with empirical data from the Rooftop solar builidng of UdK Berlin: <a href=\"http://www.solar-rooftop.de/\">http://www.solar-rooftop.de/</a> </p>
<p>The dates 28.07.2023 to 09.08.2023 were chosen as an example for the PVSystem model. </p>
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
