within IBPSA.Electrical.DC.Sources.Validation.BaseClasses;
partial model partialPVRooftopBuildingValidation
  "Partial model for validation with empirical data from a rooftop PV system in at UdK, Berlin, from July 27th to Aug 9th"
  extends Modelica.Icons.Example;
    parameter Modelica.Units.SI.Time timZon=+7200
    "Time zone";
  parameter Modelica.Units.SI.Angle lon=0.2303835
    "Longitude";
  parameter Modelica.Units.SI.Angle lat=0.9128072
    "Latitude";
  parameter Modelica.Units.SI.Time nDay=(31+28+31+30+31+30+28)*24*3600 "Day at which simulation starts";
  parameter Modelica.Units.SI.Angle azi=27.5*Modelica.Constants.pi/180
    "Surface azimuth. azi=-90 degree if surface outward unit normal points toward east; azi=0 if it points toward south";
  parameter Modelica.Units.SI.Angle til=2*Modelica.Constants.pi/180
    "Surface tilt. til=90 degree for walls; til=0 for ceilings; til=180 for roof";
  parameter Real alt(final unit="m")= 2 "Site altitude";

  parameter Real rho=0.2 "Ground reflectance";

  constant Real G_sc(
    final quantity="Irradiance",
    final unit = "W/m2") = 1376
    "Solar constant";

  Modelica.Units.SI.Irradiance HGloHor;
  Modelica.Units.SI.Irradiance HGloHorDif;
  Real k_t(final unit="1", start=0.5) "Clearness index";
  Modelica.Units.SI.Angle solDec;
  Modelica.Units.SI.Angle solHouAng;
  Modelica.Units.SI.Time cloTim;

  Modelica.Blocks.Interfaces.RealOutput PDCSim(final unit="W")
    "Simulated DC output power"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput PDCMea(final unit="W")
    "Measured DC power"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface HGloTil(til=til,
      azi=azi,
    rho=rho)
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Modelica.Blocks.Sources.CombiTimeTable MeaDatHGloHor(
    tableOnFile=true,
    tableName="MeaDatHGloHor",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/Solar_irradiation.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay - 150)
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
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Modelica.Blocks.Sources.CombiTimeTable MeaDatTDryBul(
    tableOnFile=true,
    tableName="MeaDatTDryBul",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/Ambient_temperature_PV.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay)
    "This file contains the ambient temperature. The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de."
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  Modelica.Blocks.Sources.CombiTimeTable MeaDatPVPDC(
    tableOnFile=true,
    tableName="MeaDatPVPDC",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/DC_Power_PV_1_1_2.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay)
    "This file contains the DC power output of two selected modules. The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de."
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));

  Modelica.Blocks.Sources.RealExpression souGloHorDif(y=HGloHorDif)
    annotation (Placement(transformation(extent={{-100,-34},{-80,-14}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=ModelicaServices.ExternalReferences.loadResource(
        "modelica://IBPSA/Resources/weatherdata/Weather_TRY_Berlin_winter.mos"),
    TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.Input,
    winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.Input,
    HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.Constant sounDay(k=nDay)
    "Number of validation day (July 28th 2023) in seconds"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  BoundaryConditions.SolarGeometry.IncidenceAngle incAng(azi=azi, til=til)
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Modelica.Blocks.Routing.RealPassThrough zen
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Sources.CombiTimeTable MeaDatTMod(
    tableOnFile=true,
    tableName="MeaDatTMod",
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://IBPSA/Resources/Data/Electrical/DC/Sources/Validation/Module_temperature_PV.txt"),
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    shiftTime=nDay)
    "This file contains the module temperature of two selected modules. The PVSystem model is validaded with measurement data from Rooftop building: http://www.solar-rooftop.de."
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Modelica.Blocks.Interfaces.RealOutput TModMea(final unit="degC") "Measure module temperature"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput SolHouAng(final unit="rad") "Solar hour angle"
    annotation (Placement(transformation(extent={{100,-72},{120,-52}})));
  Modelica.Blocks.Interfaces.RealOutput SolDec(final unit="rad")
    "Solar decimal angle"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealOutput CloTim(final unit="s") "Clock time"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
equation
  //Approximation of diffuse horizontal irradiation still necessary because
  //the validation data does not contain this information so far

  HGloHor=MeaDatHGloHor.y[1];
  solDec=SolDec;
  solHouAng=SolHouAng;
  cloTim=CloTim;

  k_t = if HGloHor <= 0.01 then 0 else min(1, max(0, (HGloHor/(G_sc*
        (1+0.033*cos(360*(Modelica.Constants.pi/180)*cloTim/24/60/60/365)*
        (cos(lat)*cos(SolDec)*cos(SolHouAng)+sin(lat)*sin(SolDec)))))));

  // Erbs diffuse fraction relation
  HGloHorDif = if HGloHor <=0.01 then
                 0
               elseif k_t <= 0.22 then
                 (HGloHor)*(1.0-0.09*k_t)
               elseif k_t > 0.8 then
                 (HGloHor)*0.165
               else
                 (HGloHor)*(0.9511-0.1604*k_t+4.388*k_t^2-16.638*k_t^3+12.336*k_t^4);

  connect(MeaDatPVPDC.y[1], PDCMea)
    annotation (Line(points={{81,-10},{96,-10},{96,0},{110,0}},
                                                    color={0,0,127}));
  connect(weaDat.weaBus, HGloTil.weaBus) annotation (Line(
      points={{-40,10},{-6,10},{-6,50},{0,50}},
      color={255,204,51},
      thickness=0.5));
  connect(MeaDatTDryBul.y[1], from_degC.u) annotation (Line(points={{-79,-50},{
          -62,-50}},                              color={0,0,127}));
  connect(from_degC.y, weaDat.TDryBul_in) annotation (Line(points={{-39,-50},{
          -34,-50},{-34,28},{-61,28},{-61,19}},          color={0,0,127}));
  connect(MeaDatHGloHor.y[1], weaDat.HGloHor_in)
    annotation (Line(points={{-79,-90},{-74,-90},{-74,-64},{-104,-64},{-104,-3},
          {-61,-3}},                                        color={0,0,127}));
  connect(weaDat.weaBus, incAng.weaBus) annotation (Line(
      points={{-40,10},{-6,10},{-6,-10},{0,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-40,10},{-40,40}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.solZen, zen.u) annotation (Line(
      points={{-40,40},{-40,-64},{-30,-64},{-30,-50},{-22,-50}},
      color={255,204,51},
      thickness=0.5));
  connect(MeaDatTMod.y[1], TModMea)
    annotation (Line(points={{81,-50},{96,-50},{96,-40},{110,-40}},
                                                    color={0,0,127}));
  connect(MeaDatWinAngSpe.y[2], weaDat.winSpe_in) annotation (Line(points={{-79,10},
          {-68,10},{-68,6.1},{-61,6.1}},                color={0,0,127}));
  connect(souGloHorDif.y, weaDat.HDifHor_in) annotation (Line(points={{-79,-24},
          {-74,-24},{-74,0.5},{-61,0.5}}, color={0,0,127}));
  connect(weaBus.solHouAng, SolHouAng) annotation (Line(
      points={{-40,40},{-40,-66},{94,-66},{94,-62},{110,-62}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.solDec, SolDec) annotation (Line(
      points={{-40,40},{-40,-80},{110,-80}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.cloTim, CloTim) annotation (Line(
      points={{-40,40},{-40,-100},{110,-100}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            100,100}})),
    experiment(
      StartTime=18057600,
      StopTime=19008000,
      Interval=300,
      Tolerance=1e-06),
   __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVSingleDiodeRooftopBuildingValidation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>The PVSystem single-diode model is validaded with empirical data from the Rooftop solar builidng of UdK Berlin: <a href=\"http://www.solar-rooftop.de/\">http://www.solar-rooftop.de/</a> </p>
<p>The dates 28.07.2023 to 09.08.2023 were chosen as an example for the PVSystem model. </p>
<p>The validation model proves that single diode PV models tend to overestimate the power output.</p>
<p>This is due to the neglection of staining, shading, other loss effects.</p>
<p>The irradiation measurements need to be shifted 150 s backwards since the sensor integrates the solar power over a time interval.</p>
<p>This results in a lag between measured power and measured solar irradiation.</p>
</html>",revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialPVRooftopBuildingValidation;
