within IBPSA.BoundaryConditions.WeatherData;
block ReaderTMY3 "Reader for TMY3 weather data"

  parameter Boolean computeWetBulbTemperature = true
    "If true, then this model computes the wet bulb temperature"
    annotation(Evaluate=true);
  //--------------------------------------------------------------
  // Atmospheric pressure
  parameter IBPSA.BoundaryConditions.Types.DataSource pAtmSou=IBPSA.BoundaryConditions.Types.DataSource.Parameter
    "Atmospheric pressure"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Pressure pAtm=101325
    "Atmospheric pressure (used if pAtmSou=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput pAtm_in(
    final quantity="Pressure",
    final unit="Pa",
    displayUnit="Pa") if (pAtmSou == IBPSA.BoundaryConditions.Types.DataSource.Input)
    "Input pressure"
    annotation (Placement(transformation(extent={{-240,254},{-200,294}}),
        iconTransformation(extent={{-240,254},{-200,294}})));
  //--------------------------------------------------------------
  // Ceiling height
  parameter IBPSA.BoundaryConditions.Types.DataSource ceiHeiSou=IBPSA.BoundaryConditions.Types.DataSource.File
    "Ceiling height" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Real ceiHei(
    final quantity="Height",
    final unit="m",
    displayUnit="m") = 20000 "Ceiling height (used if ceiHei=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput ceiHei_in(
    final quantity="Height",
    final unit="m",
    displayUnit="m") if (ceiHeiSou == IBPSA.BoundaryConditions.Types.DataSource.Input)
    "Input ceiling height"
    annotation (Placement(transformation(extent={{-240,-10},{-200,30}}),
        iconTransformation(extent={{-240,-10},{-200,30}})));
  //--------------------------------------------------------------
  // Total sky cover
  parameter IBPSA.BoundaryConditions.Types.DataSource totSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File
    "Total sky cover" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Real totSkyCov(
    min=0,
    max=1,
    unit="1") = 0.5
    "Total sky cover (used if totSkyCov=Parameter). Use 0 <= totSkyCov <= 1"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput totSkyCov_in(
    min=0,
    max=1,
    unit="1") if (totSkyCovSou == IBPSA.BoundaryConditions.Types.DataSource.Input)
    "Input total sky cover"
    annotation (Placement(transformation(extent={{-240,-58},{-200,-18}}),
        iconTransformation(extent={{-240,-58},{-200,-18}})));
  // Opaque sky cover
  parameter IBPSA.BoundaryConditions.Types.DataSource opaSkyCovSou=IBPSA.BoundaryConditions.Types.DataSource.File
    "Opaque sky cover" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Real opaSkyCov(
    min=0,
    max=1,
    unit="1") = 0.5
    "Opaque sky cover (used if opaSkyCov=Parameter). Use 0 <= opaSkyCov <= 1"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput opaSkyCov_in(
    min=0,
    max=1,
    unit="1") if (opaSkyCovSou == IBPSA.BoundaryConditions.Types.DataSource.Input)
    "Input opaque sky cover"
    annotation (Placement(transformation(extent={{-240,32},{-200,72}}),
        iconTransformation(extent={{-240,32},{-200,72}})));
  //--------------------------------------------------------------
  // Dry bulb temperature
  parameter IBPSA.BoundaryConditions.Types.DataSource TDryBulSou=IBPSA.BoundaryConditions.Types.DataSource.File
    "Dry bulb temperature"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Temperature TDryBul(displayUnit="degC") = 293.15
    "Dry bulb temperature (used if TDryBul=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput TDryBul_in(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") if (TDryBulSou == IBPSA.BoundaryConditions.Types.DataSource.Input)
    "Input dry bulb temperature"
    annotation (Placement(transformation(extent={{-240,160},{-200,200}})));

  //--------------------------------------------------------------
  // Dew point temperature
  parameter IBPSA.BoundaryConditions.Types.DataSource TDewPoiSou=IBPSA.BoundaryConditions.Types.DataSource.File
    "Dew point temperature"
    annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Temperature TDewPoi(displayUnit="degC") = 283.15
    "Dew point temperature (used if TDewPoi=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput TDewPoi_in(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") if (TDewPoiSou == IBPSA.BoundaryConditions.Types.DataSource.Input)
    "Input dew point temperature"
    annotation (Placement(transformation(extent={{-240,204},{-200,244}})));

  //--------------------------------------------------------------
  // Black body sky temperature
  parameter IBPSA.BoundaryConditions.Types.DataSource TBlaSkySou=IBPSA.BoundaryConditions.Types.DataSource.File
    "Black-body sky temperature" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Temperature TBlaSky=273.15
    "Black-body sky temperature (used if TBlaSkySou=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput TBlaSky_in(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") if
    (TBlaSkySou == IBPSA.BoundaryConditions.Types.DataSource.Input)
    "Black-body sky temperature"
    annotation (Placement(transformation(extent={{-240,120},{-200,160}}),
        iconTransformation(extent={{-240,120},{-200,160}})));
  //--------------------------------------------------------------
  // Relative humidity
  parameter IBPSA.BoundaryConditions.Types.DataSource relHumSou=IBPSA.BoundaryConditions.Types.DataSource.File
    "Relative humidity" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Real relHum(
    min=0,
    max=1,
    unit="1") = 0.5 "Relative humidity (used if relHum=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput relHum_in(
    min=0,
    max=1,
    unit="1") if (relHumSou == IBPSA.BoundaryConditions.Types.DataSource.Input)
    "Input relative humidity"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-240,80},{-200,120}})));
  //--------------------------------------------------------------
  // Wind speed
  parameter IBPSA.BoundaryConditions.Types.DataSource winSpeSou=IBPSA.BoundaryConditions.Types.DataSource.File
    "Wind speed" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Velocity winSpe(min=0) = 1
    "Wind speed (used if winSpe=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput winSpe_in(
    final quantity="Velocity",
    final unit="m/s",
    min=0) if (winSpeSou == IBPSA.BoundaryConditions.Types.DataSource.Input)
    "Input wind speed"
    annotation (Placement(transformation(extent={{-240,-98},{-200,-58}}),
        iconTransformation(extent={{-240,-98},{-200,-58}})));
  //--------------------------------------------------------------
  // Wind direction
  parameter IBPSA.BoundaryConditions.Types.DataSource winDirSou=IBPSA.BoundaryConditions.Types.DataSource.File
    "Wind direction" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.Angle winDir=1.0
    "Wind direction (used if winDir=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput winDir_in(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") if (winDirSou == IBPSA.BoundaryConditions.Types.DataSource.Input)
    "Input wind direction"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
        iconTransformation(extent={{-240,-140},{-200,-100}})));
  //--------------------------------------------------------------
  // Infrared horizontal radiation
  parameter IBPSA.BoundaryConditions.Types.DataSource HInfHorSou=IBPSA.BoundaryConditions.Types.DataSource.File
    "Infrared horizontal radiation" annotation (Evaluate=true, Dialog(group="Data source"));
  parameter Modelica.SIunits.HeatFlux HInfHor=0.0
    "Infrared horizontal radiation (used if HInfHorSou=Parameter)"
    annotation (Dialog(group="Data source"));
  Modelica.Blocks.Interfaces.RealInput HInfHor_in(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") if (HInfHorSou == IBPSA.BoundaryConditions.Types.DataSource.Input)
    "Input infrared horizontal radiation"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
        iconTransformation(extent={{-240,-180},{-200,-140}})));

   parameter IBPSA.BoundaryConditions.Types.RadiationDataSource HSou=IBPSA.BoundaryConditions.Types.RadiationDataSource.File
    "Global, diffuse, and direct normal radiation"
     annotation (Evaluate=true, Dialog(group="Data source"));
  //--------------------------------------------------------------
  // Global horizontal radiation
  Modelica.Blocks.Interfaces.RealInput HGloHor_in(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") if (HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor)
    "Input global horizontal radiation"
    annotation (Placement(transformation(extent={{-240,-320},{-200,-280}}),
        iconTransformation(extent={{-240,-280},{-200,-240}})));
  //--------------------------------------------------------------
  // Diffuse horizontal radiation
  Modelica.Blocks.Interfaces.RealInput HDifHor_in(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") if (HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor)
    "Input diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{-240,-240},{-200,-200}}),
        iconTransformation(extent={{-240,-210},{-200,-170}})));
  //--------------------------------------------------------------
  // Direct normal radiation
  Modelica.Blocks.Interfaces.RealInput HDirNor_in(final quantity="RadiantEnergyFluenceRate",
      final unit="W/m2") if
                          (HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor or HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor)
    "Input direct normal radiation"
    annotation (Placement(transformation(extent={{-240,-280},{-200,-240}}),
        iconTransformation(extent={{-240,-240},{-200,-200}})));

  //--------------------------------------------------------------
  parameter String filNam="" "Name of weather data file" annotation (
    Dialog(loadSelector(filter="Weather files (*.mos)",
                        caption="Select weather file")));
  final parameter Modelica.SIunits.Angle lon(displayUnit="deg")=
    IBPSA.BoundaryConditions.WeatherData.BaseClasses.getLongitudeTMY3(
    filNam) "Longitude";
  final parameter Modelica.SIunits.Angle lat(displayUnit="deg")=
    IBPSA.BoundaryConditions.WeatherData.BaseClasses.getLatitudeTMY3(
    filNam) "Latitude";
  final parameter Modelica.SIunits.Time timZon(displayUnit="h")=
    IBPSA.BoundaryConditions.WeatherData.BaseClasses.getTimeZoneTMY3(filNam)
    "Time zone";

  Bus weaBus "Weather data bus" annotation (Placement(transformation(extent={{
            290,-10},{310,10}}), iconTransformation(extent={{190,-10},{210,10}})));

  parameter IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation
    calTSky=IBPSA.BoundaryConditions.Types.SkyTemperatureCalculation.TemperaturesAndSkyCover
    "Computation of black-body sky temperature" annotation (
    choicesAllMatching=true,
    Evaluate=true,
    Dialog(group="Sky temperature"));

  constant Real epsCos = 1e-6 "Small value to avoid division by 0";
  constant Modelica.SIunits.HeatFlux solCon = 1367.7 "Solar constant";

  BaseClasses.SourceSelector pAtmSel(
    datSou=pAtmSou,
    p=pAtm) "Source selection for atmospheric pressure"
    annotation (Placement(transformation(extent={{0,260},{20,280}})));
  BaseClasses.SourceSelector TDewPoiSel(datSou=TDewPoiSou, p=TDewPoi)
    "Source selection for dewpoint temperature pressure"
    annotation (Placement(transformation(extent={{92,-240},{112,-220}})));
  BaseClasses.SourceSelector TDryBulSel(datSou=TDryBulSou, p=TDryBul)
    "Source selection for drybulb temperature pressure"
    annotation (Placement(transformation(extent={{92,-200},{112,-180}})));
  BaseClasses.SourceSelector TBlaSkySel(datSou=TBlaSkySou, p=TBlaSky)
    "Source selection for sky black body radiation"
    annotation (Placement(transformation(extent={{240,-180},{260,-160}})));
  BaseClasses.SourceSelector relHumSel(datSou=relHumSou, p=relHum)
    "Source selection for relative humidity"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  BaseClasses.SourceSelector opaSkyCovSel(datSou=opaSkyCovSou, p=opaSkyCov)
    "Source selection for opaque sky cover"
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  BaseClasses.SourceSelector ceiHeiSel(datSou=ceiHeiSou, p=ceiHei)
                                       "Source selection for ceiling height"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  BaseClasses.SourceSelector totSkyCovSel(datSou=totSkyCovSou, p=totSkyCov)
    "Source selection for total sky cover"
    annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
  BaseClasses.SourceSelector winSpeSel(datSou=winSpeSou, p=winSpe)
    "Source selection for wind speed"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  BaseClasses.SourceSelector winDirSel(datSou=winDirSou, p=winDir)
                                       "Source selection for wind speed"
    annotation (Placement(transformation(extent={{120,-280},{140,-260}})));
protected
  final parameter Modelica.SIunits.Time[2] timeSpan=
    IBPSA.BoundaryConditions.WeatherData.BaseClasses.getTimeSpanTMY3(filNam, "tab1")
  "Start time, end time of weather data";

  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=filNam,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns={2,3,4,5,6,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,
        28,29,30,8}) "Data reader"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  IBPSA.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature
    cheTemDryBul "Check dry bulb temperature "
    annotation (Placement(transformation(extent={{160,-200},{180,-180}})));
  IBPSA.BoundaryConditions.WeatherData.BaseClasses.CheckTemperature
    cheTemDewPoi "Check dew point temperature"
    annotation (Placement(transformation(extent={{160,-240},{180,-220}})));
  Modelica.Blocks.Math.Gain conRelHum(final k=0.01) if
       relHumSou == IBPSA.BoundaryConditions.Types.DataSource.File
    "Convert the relative humidity from percentage to [0, 1] "
    annotation (Placement(transformation(extent={{40,14},{60,34}})));
  BaseClasses.CheckPressure chePre "Check the air pressure"
    annotation (Placement(transformation(extent={{240,260},{260,280}})));
  Modelica.Blocks.Nonlinear.Limiter
                            limTotSkyCov(
    uMax=10,
    uMin=0,
    strict=true,
    homotopyType=Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy)
    "Limit the total sky cover"
    annotation (Placement(transformation(extent={{160,-40},{180,-20}})));
  Modelica.Blocks.Nonlinear.Limiter limOpaSkyCov(
    uMax=10,
    uMin=0,
    strict=true,
    homotopyType=Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy)
    "Limit the opaque sky cover"
    annotation (Placement(transformation(extent={{160,-160},{180,-140}})));
  BaseClasses.LimitMin limGloHorRad
    "Limit the global horizontal radiation"
    annotation (Placement(transformation(extent={{160,180},{180,200}})));
  BaseClasses.LimitMin limDifHorRad
    "Limit the diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{160,140},{180,160}})));
  BaseClasses.LimitMin limDirNorRad "Limit the direct normal radiation"
    annotation (Placement(transformation(extent={{160,220},{180,240}})));
  BaseClasses.LimitMin limCeiHei "Limit the ceiling height"
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  BaseClasses.LimitMin limWinSpe "Limit the wind speed"
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
  BaseClasses.LimitMin limHorRad
    "Limit the horizontal infrared irradiation"
    annotation (Placement(transformation(extent={{160,100},{180,120}})));
  Modelica.Blocks.Nonlinear.Limiter limWinDir(
    uMax=2*Modelica.Constants.pi,
    uMin=0,
    strict=true,
    homotopyType=Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy)
    "Limit the wind direction"
    annotation (Placement(transformation(extent={{160,-280},{180,-260}})));
  SkyTemperature.BlackBody TBlaSkyCom(final calTSky=calTSky) if
       TBlaSkySou == IBPSA.BoundaryConditions.Types.DataSource.File
    "Computation of the black-body sky temperature"
    annotation (Placement(transformation(extent={{240,-220},{260,-200}})));
  Utilities.Time.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Modelica.Blocks.Math.Add add
    "Add 30 minutes to time to shift weather data reader"
    annotation (Placement(transformation(extent={{-112,180},{-92,200}})));
  Modelica.Blocks.Sources.Constant con30mins(final k=1800)
    "Constant used to shift weather data reader"
    annotation (Placement(transformation(extent={{-160,186},{-140,206}})));
  IBPSA.BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(
      final lon=lon, final timZon=timZon) "Local civil time"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  Modelica.Blocks.Tables.CombiTable1Ds datRea1(
    final tableOnFile=true,
    final tableName="tab1",
    final fileName=filNam,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns=9:11) "Data reader"
    annotation (Placement(transformation(extent={{-52,180},{-32,200}})));
  IBPSA.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim1(
    final weaDatStaTim = timeSpan[1],
    final weaDatEndTim = timeSpan[2])
    "Convert simulation time to calendar time"
    annotation (Placement(transformation(extent={{-82,180},{-62,200}})));
  IBPSA.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim(
    final weaDatStaTim = timeSpan[1],
    final weaDatEndTim = timeSpan[2])
    "Convert simulation time to calendar time"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  BaseClasses.EquationOfTime eqnTim "Equation of time"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  BaseClasses.SolarTime solTim "Solar time"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));

  // Conditional connectors
  Modelica.Blocks.Interfaces.RealInput HGloHor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput HDifHor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput HDirNor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput HInfHor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Needed to connect to conditional connector";

  Modelica.Blocks.Math.UnitConversions.From_deg conWinDir
    "Convert the wind direction unit from [deg] to [rad]"
    annotation (Placement(transformation(extent={{40,-286},{60,-266}})));
  Modelica.Blocks.Math.UnitConversions.From_degC conTDryBul
    annotation (Placement(transformation(extent={{40,-200},{60,-180}})));
  BaseClasses.ConvertRadiation conHorRad "Convert the radiation from Wh/m2 to W/m2"
   annotation (Placement(transformation(extent={{120,100},{140,120}})));


  Modelica.Blocks.Math.UnitConversions.From_degC conTDewPoi
    "Convert the dew point temperature form [degC] to [K]"
    annotation (Placement(transformation(extent={{40,-240},{60,-220}})));
  BaseClasses.ConvertRadiation conDirNorRad "Convert the radiation from Wh/m2 to W/m2"
    annotation (Placement(transformation(extent={{0,220},{20,240}})));
  BaseClasses.ConvertRadiation conGloHorRad "Convert the radiation from Wh/m2 to W/m2"
    annotation (Placement(transformation(extent={{120,180},{140,200}})));
  BaseClasses.ConvertRadiation conDifHorRad "Convert the radiation from Wh/m2 to W/m2"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  Modelica.Blocks.Nonlinear.Limiter limRelHum(
    uMax=1,
    uMin=0,
    strict=true,
    homotopyType=Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy)
    "Limiter for relative humidity"
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
  SolarGeometry.BaseClasses.AltitudeAngle altAng "Solar altitude angle"
    annotation (Placement(transformation(extent={{-30,-280},{-10,-260}})));
   SolarGeometry.BaseClasses.ZenithAngle zenAng(
     final lat = lat) "Zenith angle"
    annotation (Placement(transformation(extent={{-20,-226},{0,-206}})));
   SolarGeometry.BaseClasses.Declination decAng "Declination angle"
    annotation (Placement(transformation(extent={{-78,-220},{-58,-200}})));
   SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{-78,-250},{-58,-230}})));
  Latitude latitude(final latitude=lat) "Latitude"
    annotation (Placement(transformation(extent={{-120,-290},{-100,-270}})));
  Longitude longitude(final longitude=lon) "Longitude"
    annotation (Placement(transformation(extent={{-78,-280},{-58,-260}})));

  //---------------------------------------------------------------------------
  // Optional instanciation of a block that computes the wet bulb temperature.
  // This block may be needed for evaporative cooling towers.
  // By default, it is enabled. This introduces a nonlinear equation, but
  // we have not observed an increase in computing time because of this equation.
  IBPSA.Utilities.Psychrometrics.TWetBul_TDryBulPhi tWetBul_TDryBulXi(
      redeclare package Medium = IBPSA.Media.Air,
      TDryBul(displayUnit="degC")) if computeWetBulbTemperature
    annotation (Placement(transformation(extent={{240,-60},{260,-40}})));

  //---------------------------------------------------------------------------
  // Conversion blocks for sky cover
  Modelica.Blocks.Math.Gain conTotSkyCov(final k=0.1) if
       totSkyCovSou == IBPSA.BoundaryConditions.Types.DataSource.File
    "Convert sky cover from [0...10] to [0...1]"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Blocks.Math.Gain conOpaSkyCov(final k=0.1) if
       opaSkyCovSou == IBPSA.BoundaryConditions.Types.DataSource.File
    "Convert sky cover from [0...10] to [0...1]"
    annotation (Placement(transformation(extent={{40,-166},{60,-146}})));
  IBPSA.BoundaryConditions.WeatherData.BaseClasses.CheckBlackBodySkyTemperature cheTemBlaSky(TMin=0)
    "Check black body sky temperature"
    annotation (Placement(transformation(extent={{240,-140},{260,-120}})));

  // Blocks that are added in order to set the name of the output signal,
  // which then is displayed in the GUI of the weather data connector.
  block Latitude "Generate constant signal of type Real"
    extends Modelica.Blocks.Icons.Block;

    parameter Modelica.SIunits.Angle latitude "Latitude";

    Modelica.Blocks.Interfaces.RealOutput y(
      unit="rad",
      displayUnit="deg") "Latitude of the location"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    y = latitude;
    annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-81,32},{84,-24}},
          lineColor={0,0,0},
            textString="Latitude")}),
    Documentation(info="<html>
<p>
Block to output the latitude of the location.
This block is added so that the latitude is displayed
with a comment in the GUI of the weather bus connector.
</p>
<h4>Implementation</h4>
<p>
If
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">
Modelica.Blocks.Sources.Constant</a> where used, then
the comment for the latitude would be \"Connector of Real output signal\".
As this documentation string cannot be overwritten, a new block
was implemented.
</p>
</html>", revisions="<html>
<ul>
<li>
January 4, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Latitude;

  block Longitude "Generate constant signal of type Real"
    extends Modelica.Blocks.Icons.Block;

    parameter Modelica.SIunits.Angle longitude "Longitude";

    Modelica.Blocks.Interfaces.RealOutput y(
      unit="rad",
      displayUnit="deg") "Longitude of the location"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    y = longitude;
    annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-81,32},{84,-24}},
          lineColor={0,0,0},
            textString="Longitude")}),
    Documentation(info="<html>
<p>
Block to output the longitude of the location.
This block is added so that the longitude is displayed
with a comment in the GUI of the weather bus connector.
</p>
<h4>Implementation</h4>
<p>
If
<a href=\"modelica://Modelica.Blocks.Sources.Constant\">
Modelica.Blocks.Sources.Constant</a> where used, then
the comment for the longitude would be \"Connector of Real output signal\".
As this documentation string cannot be overwritten, a new block
was implemented.
</p>
</html>", revisions="<html>
<ul>
<li>
January 4, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Longitude;

equation
  //---------------------------------------------------------------------------
  // Select global horizontal radiation connector
  if HSou ==  IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor then
    connect(HGloHor_in, HGloHor_in_internal)
      "Get HGloHor using user input file";
  elseif HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor then
     HDirNor_in_internal*cos(zenAng.zen)+HDifHor_in_internal = HGloHor_in_internal
      "Calculate the HGloHor using HDirNor and HDifHor according to (A.4.14) and (A.4.15)";
  else
    connect(conGloHorRad.HOut, HGloHor_in_internal)
      "Get HGloHor using weather data file";
  end if;
  connect(HGloHor_in_internal,limGloHorRad.u);
  //---------------------------------------------------------------------------
  // Select diffuse horizontal radiation connector
  if HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor then
     connect(HDifHor_in, HDifHor_in_internal)
      "Get HDifHor using user input file";
  elseif  HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor then
    HDifHor_in_internal = HGloHor_in_internal - HDirNor_in_internal*cos(zenAng.zen)
      "Calculate the HGloHor using HDirNor and HDifHor according to (A.4.14) and (A.4.15)";
  else
    connect(conDifHorRad.HOut, HDifHor_in_internal)
      "Get HDifHor using weather data file";
  end if;
  connect(HDifHor_in_internal,limDifHorRad.u);
  //---------------------------------------------------------------------------
  // Select direct normal radiation connector
  if HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor or HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor then
     connect(HDirNor_in, HDirNor_in_internal)
      "Get HDirNor using user input file";
  elseif  HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor then
      HDirNor_in_internal = min(
        solCon,
        (HGloHor_in_internal -HDifHor_in_internal)*
          IBPSA.Utilities.Math.Functions.spliceFunction(
            x=cos(zenAng.zen),
            pos=IBPSA.Utilities.Math.Functions.inverseXRegularized(cos(zenAng.zen),epsCos),
            neg=0,
            deltax=epsCos))
      "Calculate the HDirNor using HGloHor and HDifHor according to (A.4.14) and (A.4.15)";
  else
    connect(conDirNorRad.HOut, HDirNor_in_internal)
      "Get HDirNor using weather data file";
  end if;
  connect(HDirNor_in_internal,limDirNorRad.u);

  //---------------------------------------------------------------------------
  // Select infrared radiation connector
  if HInfHorSou == IBPSA.BoundaryConditions.Types.DataSource.Parameter then
    HInfHor_in_internal = HInfHor;
  elseif HInfHorSou == IBPSA.BoundaryConditions.Types.DataSource.Input then
    connect(HInfHor_in, HInfHor_in_internal);
  else
    connect(conHorRad.HOut, HInfHor_in_internal);
  end if;
  connect(HInfHor_in_internal,limHorRad.u);

  connect(limTotSkyCov.y, weaBus.nTot) annotation (Line(points={{181,-30},{220,
          -30},{220,0},{300,0}}, color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(limOpaSkyCov.y, weaBus.nOpa) annotation (Line(points={{181,-150},{220,
          -150},{220,0},{300,0}}, color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(limGloHorRad.y, weaBus.HGloHor) annotation (Line(points={{181,190},{
          220,190},{220,0},{300,0}}, color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(limDifHorRad.y, weaBus.HDifHor) annotation (Line(points={{181,150},{
          220,150},{220,0},{300,0}}, color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(limDirNorRad.y, weaBus.HDirNor) annotation (Line(points={{181,230},{
          220,230},{220,0},{300,0}}, color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(limCeiHei.y, weaBus.celHei) annotation (Line(
      points={{181,-110},{220,-110},{220,0},{300,0}},
      color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(limWinSpe.y, weaBus.winSpe) annotation (Line(points={{181,-70},{220,-70},
          {220,0},{300,0}}, color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(limHorRad.y, weaBus.HHorIR) annotation (Line(points={{181,110},{220,
          110},{220,0},{300,0}}, color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(limWinDir.y, weaBus.winDir) annotation (Line(points={{181,-270},{280,
          -270},{280,0},{300,0}}, color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(limOpaSkyCov.y, TBlaSkyCom.nOpa) annotation (Line(points={{181,-150},
          {220,-150},{220,-213},{238,-213}}, color={0,0,127}));
  connect(limHorRad.y, TBlaSkyCom.HHorIR) annotation (Line(points={{181,110},{
          220,110},{220,-218},{238,-218}}, color={0,0,127}));
  connect(modTim.y, weaBus.cloTim) annotation (Line(
      points={{-139,6.10623e-16},{34.75,6.10623e-16},{34.75,0},{300,0}},
      color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(modTim.y, add.u2) annotation (Line(
      points={{-139,0},{-128,0},{-128,184},{-114,184}},
      color={0,0,127}));
  connect(con30mins.y, add.u1) annotation (Line(
      points={{-139,196},{-114,196}},
      color={0,0,127}));
  connect(add.y, conTim1.modTim) annotation (Line(
      points={{-91,190},{-84,190}},
      color={0,0,127}));
  connect(conTim1.calTim, datRea1.u) annotation (Line(
      points={{-61,190},{-54,190}},
      color={0,0,127}));
  connect(modTim.y, locTim.cloTim) annotation (Line(
      points={{-139,6.10623e-16},{-128,6.10623e-16},{-128,-150},{-102,-150}},
      color={0,0,127}));
  connect(modTim.y, conTim.modTim) annotation (Line(
      points={{-139,6.10623e-16},{-128,6.10623e-16},{-128,-30},{-92,-30}},
      color={0,0,127}));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-69,-30},{-52,-30}},
      color={0,0,127}));
  connect(modTim.y, eqnTim.nDay) annotation (Line(
      points={{-139,6.10623e-16},{-128,6.10623e-16},{-128,-110},{-102,-110}},
      color={0,0,127}));
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(
      points={{-79,-110},{-70,-110},{-70,-124},{-62,-124}},
      color={0,0,127}));
  connect(locTim.locTim, solTim.locTim) annotation (Line(
      points={{-79,-150},{-72,-150},{-72,-135.4},{-62,-135.4}},
      color={0,0,127}));
  connect(solTim.solTim, weaBus.solTim) annotation (Line(
      points={{-39,-130},{-10,-130},{-10,0},{300,0}},
      color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(datRea.y[11], conWinDir.u) annotation (Line(
      points={{-29,-30},{20,-30},{20,-276},{38,-276}},
      color={0,0,127}));
  connect(cheTemDryBul.TOut, TBlaSkyCom.TDryBul) annotation (Line(
      points={{181,-190},{220,-190},{220,-202},{238,-202}},
      color={0,0,127}));
  connect(datRea.y[1], conTDryBul.u) annotation (Line(
      points={{-29,-30},{20,-30},{20,-190},{38,-190}},
      color={0,0,127}));
  connect(datRea.y[2], conTDewPoi.u) annotation (Line(
      points={{-29,-30},{20,-30},{20,-230},{38,-230}},
      color={0,0,127}));
  connect(cheTemDewPoi.TOut, weaBus.TDewPoi) annotation (Line(
      points={{181,-230},{280,-230},{280,0},{300,0}},
      color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TBlaSkyCom.TDewPoi, cheTemDewPoi.TOut) annotation (Line(
      points={{238,-207},{220,-207},{220,-230},{181,-230}},
      color={0,0,127}));
  connect(datRea1.y[2], conDirNorRad.HIn) annotation (Line(
      points={{-31,190},{-16,190},{-16,230},{-2,230}},
      color={0,0,127}));
  connect(datRea1.y[1], conGloHorRad.HIn) annotation (Line(
      points={{-31,190},{118,190}},
      color={0,0,127}));
  connect(datRea1.y[3], conDifHorRad.HIn) annotation (Line(
      points={{-31,190},{20,190},{20,150},{118,150}},
      color={0,0,127}));
  connect(conRelHum.u, datRea.y[3]) annotation (Line(points={{38,24},{20,24},{20,
          -30},{-29,-30}},    color={0,0,127}));
  connect(limRelHum.y, weaBus.relHum) annotation (Line(points={{181,30},{280,30},
          {280,0},{300,0}}, color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheTemDryBul.TOut, weaBus.TDryBul) annotation (Line(
      points={{181,-190},{280,-190},{280,0},{300,0}},
      color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(decAng.decAng, zenAng.decAng)
                                  annotation (Line(
      points={{-57,-210},{-22,-210},{-22,-210.6}},
      color={0,0,127}));
  connect(solHouAng.solHouAng, zenAng.solHouAng)  annotation (Line(
      points={{-57,-240},{-50,-240},{-50,-220},{-32,-220},{-32,-220.8},{-22,-220.8}},
      color={0,0,127}));
  connect(solHouAng.solTim, solTim.solTim) annotation (Line(
      points={{-80,-240},{-100,-240},{-100,-174},{-10,-174},{-10,-130},{-39,-130}},
      color={0,0,127}));
  connect(decAng.nDay, modTim.y) annotation (Line(
      points={{-80,-210},{-90,-210},{-90,-180},{0,-180},{0,6.10623e-16},{-139,6.10623e-16}},
      color={0,0,127}));
  connect(zenAng.zen, altAng.zen) annotation (Line(
      points={{1,-216},{8,-216},{8,-240},{-40,-240},{-40,-270},{-32,-270}},
      color={0,0,127}));

  // Connectors for wet bulb temperature.
  // These are removed if computeWetBulbTemperature = false
  connect(tWetBul_TDryBulXi.TWetBul, weaBus.TWetBul) annotation (Line(
      points={{261,-50},{280,-50},{280,0},{300,0}},
      color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheTemDryBul.TOut, tWetBul_TDryBulXi.TDryBul) annotation (Line(
      points={{181,-190},{220,-190},{220,-42},{239,-42}},
      color={0,0,127}));
  connect(limRelHum.y, tWetBul_TDryBulXi.phi) annotation (Line(points={{181,30},
          {230,30},{230,-50},{239,-50}}, color={0,0,127}));

  connect(altAng.alt, weaBus.solAlt) annotation (Line(
      points={{-9,-270},{8,-270},{8,-290},{290,-290},{290,0},{300,0}},
      color={0,0,127}));
  connect(zenAng.zen, weaBus.solZen) annotation (Line(
      points={{1,-216},{8,-216},{8,-290},{290,-290},{290,0},{300,0}},
      color={0,0,127}));
  connect(decAng.decAng, weaBus.solDec) annotation (Line(
      points={{-57,-210},{-50,-210},{-50,-290},{290,-290},{290,0},{300,0}},
      color={0,0,127}));
  connect(solHouAng.solHouAng, weaBus.solHouAng) annotation (Line(
      points={{-57,-240},{-50,-240},{-50,-290},{290,-290},{290,0},{300,0}},
      color={0,0,127}));
  connect(longitude.y, weaBus.lon) annotation (Line(
      points={{-57,-270},{-50,-270},{-50,-290},{290,-290},{290,0},{300,0}},
      color={0,0,127}));
  connect(latitude.y, weaBus.lat) annotation (Line(
      points={{-99,-280},{-88,-280},{-88,-290},{290,-290},{290,0},{300,0}},
      color={0,0,127}));
  connect(datRea.y[26], conHorRad.HIn) annotation (Line(points={{-29,-30},{20,-30},
          {20,110},{118,110}},      color={0,0,127}));
  connect(pAtmSel.y, chePre.PIn)
    annotation (Line(points={{21,270},{238,270}},   color={0,0,127}));
  connect(pAtmSel.uCon, pAtm_in) annotation (Line(points={{-1,276},{-110,276},{
          -110,274},{-220,274}},
                            color={0,0,127}));
  connect(datRea.y[4], pAtmSel.uFil) annotation (Line(points={{-29,-30},{-20,
          -30},{-20,264},{-1,264}},
                               color={0,0,127}));
  connect(cheTemDewPoi.TIn, TDewPoiSel.y)
    annotation (Line(points={{158,-230},{113,-230}}, color={0,0,127}));
  connect(TDewPoiSel.uFil, conTDewPoi.y) annotation (Line(points={{91,-236},{76,
          -236},{76,-230},{61,-230}}, color={0,0,127}));
  connect(TDewPoiSel.uCon, TDewPoi_in) annotation (Line(points={{91,-224},{82,-224},
          {82,146},{-168,146},{-168,224},{-220,224}}, color={0,0,127}));
  connect(TDryBulSel.y, cheTemDryBul.TIn)
    annotation (Line(points={{113,-190},{158,-190}}, color={0,0,127}));
  connect(TDryBulSel.uFil, conTDryBul.y) annotation (Line(points={{91,-196},{70,
          -196},{70,-190},{61,-190}}, color={0,0,127}));
  connect(TDryBulSel.uCon, TDryBul_in) annotation (Line(points={{91,-184},{78,-184},
          {78,142},{-176,142},{-176,180},{-220,180}}, color={0,0,127}));

  connect(TBlaSkySel.y, weaBus.TBlaSky) annotation (Line(points={{261,-170},{280,
          -170},{280,0},{300,0}}, color={0,0,127}));
  connect(TBlaSkySel.y, cheTemBlaSky.TIn) annotation (Line(points={{261,-170},{270,
          -170},{270,-148},{230,-148},{230,-130},{238,-130}}, color={0,0,127}));
  connect(TBlaSkyCom.TBlaSky, TBlaSkySel.uFil) annotation (Line(points={{261,-210},
          {268,-210},{268,-186},{232,-186},{232,-176},{239,-176}}, color={0,0,127}));
  connect(TBlaSky_in, TBlaSkySel.uCon) annotation (Line(points={{-220,140},{74,140},
          {74,-168},{228,-168},{228,-164},{239,-164}}, color={0,0,127}));
  connect(relHumSel.y, limRelHum.u)
    annotation (Line(points={{141,30},{158,30}}, color={0,0,127}));
  connect(relHumSel.uFil, conRelHum.y)
    annotation (Line(points={{119,24},{61,24}},  color={0,0,127}));
  connect(relHum_in, relHumSel.uCon) annotation (Line(points={{-220,100},{110,100},
          {110,36},{119,36}}, color={0,0,127}));
  connect(limOpaSkyCov.u, opaSkyCovSel.y)
    annotation (Line(points={{158,-150},{141,-150}}, color={0,0,127}));
  connect(conOpaSkyCov.y, opaSkyCovSel.uFil)
    annotation (Line(points={{61,-156},{119,-156}}, color={0,0,127}));
  connect(opaSkyCov_in, opaSkyCovSel.uCon) annotation (Line(points={{-220,52},{70,
          52},{70,-144},{119,-144}}, color={0,0,127}));
  connect(ceiHeiSel.y, limCeiHei.u)
    annotation (Line(points={{141,-110},{158,-110}}, color={0,0,127}));
  connect(ceiHeiSel.uFil, datRea.y[16]) annotation (Line(points={{119,-116},{20,
          -116},{20,-30},{-29,-30}}, color={0,0,127}));
  connect(ceiHeiSel.uCon, ceiHei_in) annotation (Line(points={{119,-104},{-40,-104},
          {-40,-90},{-180,-90},{-180,10},{-220,10}}, color={0,0,127}));
  connect(totSkyCovSel.uFil, conTotSkyCov.y) annotation (Line(points={{119,-36},
          {100,-36},{100,-30},{61,-30}}, color={0,0,127}));
  connect(totSkyCovSel.uCon, totSkyCov_in) annotation (Line(points={{119,-24},{108,
          -24},{108,-50},{-190,-50},{-190,-38},{-220,-38}}, color={0,0,127}));
  connect(totSkyCovSel.y, limTotSkyCov.u)
    annotation (Line(points={{141,-30},{158,-30}}, color={0,0,127}));
  connect(winSpeSel.y, limWinSpe.u)
    annotation (Line(points={{141,-70},{158,-70}}, color={0,0,127}));
  connect(conTotSkyCov.u, datRea.y[13])
    annotation (Line(points={{38,-30},{-29,-30}}, color={0,0,127}));
  connect(winSpeSel.uFil, datRea.y[12]) annotation (Line(points={{119,-76},{-20,
          -76},{-20,-30},{-29,-30}}, color={0,0,127}));
  connect(winSpeSel.uCon, winSpe_in) annotation (Line(points={{119,-64},{-190,-64},
          {-190,-78},{-220,-78}}, color={0,0,127}));
  connect(winDirSel.y, limWinDir.u)
    annotation (Line(points={{141,-270},{158,-270}}, color={0,0,127}));
  connect(conWinDir.y, winDirSel.uFil)
    annotation (Line(points={{61,-276},{119,-276}}, color={0,0,127}));
  connect(winDirSel.uCon, winDir_in) annotation (Line(points={{119,-264},{66,-264},
          {66,-80},{-190,-80},{-190,-120},{-220,-120}}, color={0,0,127}));
  connect(pAtmSel.y, weaBus.pAtm) annotation (Line(points={{21,270},{220,270},{
          220,0},{300,0}}, color={0,0,127}));
  connect(tWetBul_TDryBulXi.p, pAtmSel.y) annotation (Line(points={{239,-58},{
          220,-58},{220,270},{21,270}}, color={0,0,127}));
  connect(conOpaSkyCov.u, datRea.y[14]) annotation (Line(points={{38,-156},{20,
          -156},{20,-30},{-29,-30}}, color={0,0,127}));
    annotation (Placement(transformation(extent={{120,100},{140,120}})),
    defaultComponentName="weaDat",
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-200},{200,200}},
        initialScale=0.05), graphics={
        Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={124,142,255},
          fillColor={124,142,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-162,270},{138,230}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          visible=(pAtmSou == IBPSA.BoundaryConditions.Types.DataSource.Input),
          extent={{-190,216},{-164,184}},
          lineColor={0,0,127},
          textString="p"),
        Text(
          visible=(TDryBulSou == IBPSA.BoundaryConditions.Types.DataSource.Input),
          extent={{-194,162},{-118,118}},
          lineColor={0,0,127},
          textString="TDryBul"),
        Text(
          visible=(relHumSou == IBPSA.BoundaryConditions.Types.DataSource.Input),
          extent={{-190,92},{-104,66}},
          lineColor={0,0,127},
          textString="relHum"),
        Text(
        visible=(winSpeSou == IBPSA.BoundaryConditions.Types.DataSource.Input),
          extent={{-196,44},{-110,2}},
          lineColor={0,0,127},
          textString="winSpe"),
        Text(
          visible=(winDirSou == IBPSA.BoundaryConditions.Types.DataSource.Input),
          extent={{-192,-18},{-106,-60}},
          lineColor={0,0,127},
          textString="winDir"),
        Text(
        visible=(HSou ==  IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor),
        extent={{-202,-88},{-112,-108}},
          lineColor={0,0,127},
          textString="HGloHor"),
        Text(visible=(HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor),
        extent={{-202,-142},{-116,-164}},
          lineColor={0,0,127},
          textString="HDifHor"),
        Text(
        visible=(HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor or HSou == IBPSA.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor),
        extent={{-200,-186},{-126,-214}},
          lineColor={0,0,127},
          textString="HDirNor"),
        Ellipse(
          extent={{-146,154},{28,-20}},
          lineColor={255,220,220},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,0}),
        Polygon(
          points={{94,106},{77.9727,42.9844},{78,42},{110,52},{138,50},{164,38},
              {182,-28},{138,-102},{10,-110},{-140,-106},{-166,-30},{-150,24},{-102,
              26},{-78.2109,8.1582},{-78,8},{-92,70},{-58,120},{34,140},{94,106}},
          lineColor={220,220,220},
          lineThickness=0.1,
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.Bezier,
          fillColor={230,230,230}),
        Text(
          extent={{140,-106},{-126,-192}},
          lineColor={255,255,255},
          textString=DynamicSelect("", String(weaBus.TDryBul-273.15, format=".1f")))}),
    Documentation(info="<html>
<p>
This component reads TMY3 weather data (Wilcox and Marion, 2008) or user specified weather data.
The Modelica built-in variable <code>time</code> determines what row
of the weather file is read.
The value of <code>time</code> is the number of seconds
that have passed since January 1st at midnight (00:00) in the local time zone.
The local time zone value, longitude and latitute are also read from the weather data,
such that the solar position computations are consistent with the weather data.
</p>
<p>
The weather data format is the Typical Meteorological Year (TMY3)
as obtained from the EnergyPlus web site at
<a href=\"http://energyplus.net/weather\">
http://energyplus.net/weather</a>. These
data, which are in the EnergyPlus format, need to be converted as described
below.
</p>
<!-- ============================================== -->
<h4>Output to weaBus</h4>
<p>
The following variables serve as output and are accessible via <code>weaBus</code>:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<!-- ============================================== -->
<tr>
  <th>Name
  </th>
  <th>Unit
  </th>
  <th>Description
  </th>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>HDifHor</code>
  </td>
  <td>
    W/m2
  </td>
  <td>
    Horizontal diffuse solar radiation.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>HDifNor</code>
  </td>
  <td>
    W/m2
  </td>
  <td>
    Direct normal radiation.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>HGloHor</code>
  </td>
  <td>
    W/m2
  </td>
  <td>
    Horizontal global radiation.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>HHorIR</code>
  </td>
  <td>
    W/m2
  </td>
  <td>
    Horizontal infrared irradiation.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>TBlaSky</code>
  </td>
  <td>
    K
  </td>
  <td>
    Output temperature.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>TDewPoi</code>
  </td>
  <td>
    K
  </td>
  <td>
    Dew point temperature.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>TDryBul</code>
  </td>
  <td>
    K
  </td>
  <td>
    Dry bulb temperature at ground level.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>TWetBul</code>
  </td>
  <td>
    K
  </td>
  <td>
    Wet bulb temperature.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>celHei</code>
  </td>
  <td>
    m
  </td>
  <td>
    Ceiling height.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>cloTim</code>
  </td>
  <td>
    s
  </td>
  <td>
    One-based day number in seconds.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>lat</code>
  </td>
  <td>
    rad
  </td>
  <td>
  Latitude of the location.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>lon</code>
  </td>
  <td>
    rad
  </td>
  <td>
  Longitude of the location.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>nOpa</code>
  </td>
  <td>
    1
  </td>
  <td>
  Opaque sky cover [0, 1].
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>nTot</code>
  </td>
  <td>
    1
  </td>
  <td>
   Total sky Cover [0, 1].
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>pAtm</code>
  </td>
  <td>
    Pa
  </td>
  <td>
    Atmospheric pressure.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>relHum</code>
  </td>
  <td>
    1
  </td>
  <td>
    Relative humidity.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>solAlt</code>
  </td>
  <td>
    rad
  </td>
  <td>
    Altitude angle.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>solDec</code>
  </td>
  <td>
    rad
  </td>
  <td>
    Declination angle.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>solHouAng</code>
  </td>
  <td>
    rad
  </td>
  <td>
    Solar hour angle.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>solTim</code>
  </td>
  <td>
    s
  </td>
  <td>
    Solar time.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>solZen</code>
  </td>
  <td>
    rad
  </td>
  <td>
    Zenith angle.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>winDir</code>
  </td>
  <td>
    rad
  </td>
  <td>
    Wind direction.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    <code>winSpe</code>
  </td>
  <td>
    m/s
  </td>
  <td>
    Wind speed.
  </td>
</tr>
</table>
<!-- ============================================== -->
<h4>Adding new weather data</h4>
<p>
To add new weather data, proceed as follows:
</p>
<ol>
<li>
Download the weather data file with the <code>epw</code> extension from
<a href=\"http://energyplus.net/weather\">
http://energyplus.net/weather</a>.
</li>
<li>
Add the file to <code>IBPSA/Resources/weatherdata</code> (or to any directory
for which you have write permission).
</li>
<li>
On a console window, type<pre>
  cd IBPSA/Resources/weatherdata
  java -jar ../bin/ConvertWeatherData.jar inputFile.epw
</pre>
This will generate the weather data file <code>inputFile.mos</code>, which can be read
by the model
<a href=\"modelica://IBPSA.BoundaryConditions.WeatherData.ReaderTMY3\">
IBPSA.BoundaryConditions.WeatherData.ReaderTMY3</a>.
</li>
</ol>
<!-- ============================================== -->
<h4>Location data that are read automatically from the weather data file</h4>
<p>
The following location data are automatically read from the weather file:
</p>
<ul>
<li>
The latitude of the weather station, <code>lat</code>,
</li>
<li>
the longitude of the weather station, <code>lon</code>, and
</li>
<li>
the time zone relative to Greenwich Mean Time, <code>timZone</code>.
</li>
</ul>
<!-- ============================================== -->
<h4>Wet bulb temperature</h4>
<p>
By default, the data bus contains the wet bulb temperature.
This introduces a nonlinear equation.
However, we have not observed an increase in computing time because
of this equation.
To disable the computation of the wet bulb temperature, set
<code>computeWetBulbTemperature=false</code>.
</p>
<!-- ============================================== -->
<h4>Using constant or user-defined input signals for weather data</h4>
<p>
This model has the option of using a constant value, using the data from the weather file,
or using data from an input connector for the following variables:
</p>
<ul>
<li>
The atmospheric pressure,
</li>
<li>
the ceiling height,
</li>
<li>
the total sky cover,
</li>
<li>
the opaque sky cover,
</li>
<li>
the dry bulb temperature,
</li>
<li>
the dew point temperature,
</li>
<li>
the sky black body temperature,
</li>
<li>
the relative humidity,
</li>
<li>
the wind direction,
</li>
<li>
the wind speed,
</li>
<li>
the global horizontal radiation, direct normal and diffuse horizontal radiation,
and
</li>
<li>
the infrared horizontal radiation.
</li>
</ul>
<p>
By default, all data are obtained from the weather data file,
except for the atmospheric pressure, which is set to the
parameter <code>pAtm=101325</code> Pascals.
</p>
<p>
The parameter <code>*Sou</code> configures the source of the data.
For the atmospheric pressure, temperatures, relative humidity, wind speed and wind direction,
the enumeration
<a href=\"modelica://IBPSA.BoundaryConditions.Types.DataSource\">
IBPSA.BoundaryConditions.Types.DataSource</a>
is used as follows:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<!-- ============================================== -->
<tr>
  <th>Parameter <code>*Sou</code>
  </th>
  <th>Data used to compute weather data.
  </th>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    File
  </td>
  <td>
    Use data from file.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    Parameter
  </td>
  <td>
    Use value specified by the parameter.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    Input
  </td>
  <td>
    Use value from the input connector.
  </td>
</tr>
</table>
<p>
Because global, diffuse and direct radiation are related to each other, the parameter
<code>HSou</code> is treated differently.
It is set to a value of the enumeration
<a href=\"modelica://IBPSA.BoundaryConditions.Types.RadiationDataSource\">
IBPSA.BoundaryConditions.Types.RadiationDataSource</a>,
and allows the following configurations:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<!-- ============================================== -->
<tr>
  <th>Parameter <code>HSou</code>
  </th>
  <th>Data used to compute weather data.
  </th>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    File
  </td>
  <td>
    Use data from file.
  </td>
</tr>
<!-- ============================================== -->
<tr>
  <td>
    Input_HGloHor_HDifHor
  </td>
  <td>
    Use global horizontal and diffuse horizontal radiation from input connector.
  </td>
</tr>
<tr>
  <td>
    Input_HDirNor_HDifHor
  </td>
  <td>
    Use direct normal and diffuse horizontal radiation from input connector.
  </td>
</tr>
<tr>
  <td>
    Input_HDirNor_HGloHor
  </td>
  <td>
    Use direct normal and global horizontal radiation from input connector.
  </td>
</tr>
</table>
<!-- ============================================== -->
<h4>Length of weather data and simulation period</h4>
<p>
If weather data span a year, which is the default for TMY3 data, or multiple years,
then this model can be used for simulations that span multiple years. The simulation
start time needs to be set to the clock time of the respective start time. For example,
to start at January 2 at 10am, set start time to <code>t=(24+10)*3600</code> seconds.
For this computation, the used date and time (here January 2, 10 am) must be expressed in the same time zone
as the one that is used to define the TMY3 file. This is usually the local (winter) time zone.
The parameter `timZon` represents the TMY3 file time zone, expressed in seconds compared to UTC.
</p>
<p>
Moreover, weather data need not span a whole year, or it can span across New Year.
In this case, the simulation cannot exceed the time of the weather data file. Otherwise,
the simulation stops with an error.
</p>
<p>
As weather data have one entry at the start of the time interval, the end time of the weather
data file is computed as the last time entry plus the average time increment of the file.
For example, an hourly weather data file has 8760 entries, starting on January 1 at 0:00.
The last entry in the file will be for December 31 at 23:00. As the time increment is 1 hour,
the model assumes the weather file to end at December 31 at 23:00 plus 1 hour, e.g., at January 1 at 0:00.
</p>
<!-- ============================================== -->
<h4>Notes</h4>
<ol>
<li>
<p>
In HVAC systems, when the fan is off, changes in atmospheric pressure can cause small air flow rates
in the duct system due to change in pressure and hence in the mass of air that is stored
in air volumes (such as in fluid junctions or in the room model).
This may increase computing time. Therefore, the default value for the atmospheric pressure is set to a constant.
Furthermore, if the initial pressure of air volumes are different
from the atmospheric pressure, then fast pressure transients can happen in the first few seconds of the simulation.
This can cause numerical problems for the solver. To avoid this problem, set the atmospheric pressure to the
same value as the medium default pressure, which is typically set to the parameter <code>Medium.p_default</code>.
For medium models for moist air and dry air, the default is
<code>Medium.p_default=101325</code> Pascals.
</p>
</li>
<li>
<p>
Different units apply depending on whether data are obtained from a file, or
from a parameter or an input connector:
</p>
<ul>
<li>
When using TMY3 data from a file (e.g. <code>USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos</code>), the units must be the same as the original TMY3 file used by EnergyPlus (e.g.
<code>USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw</code>).
The TMY3 data used by EnergyPlus are in both SI units and non-SI units.
If <code>Resources/bin/ConvertWeatherData.jar</code> is used to convert the <code>.epw</code> file to an <code>.mos</code> file, the units of the TMY3 data are preserved and the file can be directly
used by this data reader.
The data reader will automatically convert units to the SI units used by Modelica.
For example, the dry bulb temperature <code>TDryBul</code> in TMY3 is in degree Celsius.
The data reader will automatically convert the data to Kelvin.
The wind direction <code>winDir</code> in TMY3 is degrees and will be automatically converted to radians.
</li>
<li>
When using data from a parameter or from an input connector,
the data must be in the SI units used by Modelica.
For instance, the unit must be
<code>Pa</code> for pressure,
<code>K</code> for temperature,
<code>W/m2</code> for solar radiations and
<code>rad</code> for wind direction.
</li>
</ul>
</li>
<li>
The ReaderTMY3 should only be used with TMY3 data. It contains a time shift for solar radiation data
that is explained below. This time shift needs to be removed if the user may want to
use the ReaderTMY3 for other weather data types.
</li>
</ol>
<h4>Implementation</h4>
<h5>Start and end data for annual weather data files</h5>
<p>
The TMY3 weather data, as well as the EnergyPlus weather data, start at 1:00 AM
on January 1, and provide hourly data until midnight on December 31.
Thus, the first entry for temperatures, humidity, wind speed etc. are values
at 1:00 AM and not at midnight. Furthermore, the TMY3 weather data files can have
values at midnight of December 31 that may be significantly different from the values
at 1:00 AM on January 1.
Since annual simulations require weather data that start at 0:00 on January 1,
data need to be provided for this hour. Due to the possibly large change in
weatherdata between 1:00 AM on January 1 and midnight at December 31,
the weather data files in the IBPSA library do not use the data entry from
midnight at December 31 as the value for <i>t=0</i>. Rather, the
value from 1:00 AM on January 1 is duplicated and used for 0:00 on January 1.
To maintain a data record with <i>8760</i> hours, the weather data record from
midnight at December 31 is deleted.
These changes in the weather data file are done in the Java program
<code>IBPSA/Resources/bin/ConvertWeatherData.jar</code> that converts
EnergyPlus weather data file to Modelica weather data files, and which is described
above.
The length of the weather data is calculated as the
end time stamp minus start time stamp plus average increment, where the
average increment is equal to the end time stamp minus start time stamp divided
by the number of rows minus 1.
This only works correctly for weather files with equidistant time stamps.
</p>
<h5>Time shift for solar radiation data</h5>
<p>
To read weather data from the TMY3 weather data file, there are
two data readers in this model. One data reader obtains all data
except solar radiation, and the other data reader reads only the
solar radiation data, shifted by <i>30</i> minutes.
The reason for this time shift is as follows:
The TMY3 weather data file contains for solar radiation the
\"...radiation received
on a horizontal surface during
the 60-minute period ending at
the timestamp.\"

Thus, as the figure below shows, a more accurate interpolation is obtained if
time is shifted by <i>30</i> minutes prior to reading the weather data.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://IBPSA/Resources/Images/BoundaryConditions/WeatherData/RadiationTimeShift.png\"
border=\"1\" />
</p>
<h4>References</h4>
<ul>
<li>
Wilcox S. and W. Marion. <i>Users Manual for TMY3 Data Sets</i>.
Technical Report, NREL/TP-581-43156, revised May 2008.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 20, 2019, by Filip Jorissen:<br/>
Better clarified the meaning of <code>time</code> in the documentation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1192\">#1192</a>.
</li>
<li>
March 5, 2019, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">#842</a>.
</li>
<li>
September 20, 2018, by Michael Wetter:<br/>
Corrected documentation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1022\">#1022</a>.
</li>
<li>
December 4, 2017, by Michael Wetter:<br/>
Removed function call to <code>getAbsolutePath</code>, as this causes in Dymola 2018FD01
the error
\"A call of loadResource with a non-literal string remains in the generated code; it will not work for an URI.\"
when exporting <a href=\"modelica://IBPSA.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZone\">
IBPSA.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZone</a>
as an FMU. Instead, if the weather file is specified as a Modelica, URI, syntax such as
<code>Modelica.Utilities.Files.loadResource(\"modelica://IBPSA/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos\")</code>
should be used.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/867\">#867</a>.
</li>
<li>
February 18, 2017, by Filip Jorissen:<br/>
Infrared radiation on horizontal surface is now delayed by 30 minutes
such that the results in
<a href=\"modelica://IBPSA.BoundaryConditions.SkyTemperature.Examples.BlackBody\">TBlaSky</a>
are consistent.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/648\">#648</a>.
</li>
<li>
December 06, 2016, by Thierry S. Nouidui:<br/>
Constrained the direct normal radiation to not be bigger than the solar constant when using
global and diffuse solar radiation data provided via the inputs connectors.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/608\">#608</a>.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Introduced <code>absFilNam</code> to avoid multiple calls to
<a href=\"modelica://IBPSA.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath\">
IBPSA.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</a>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
</li>
<li>
January 6, 2016, by Moritz Lauster:<br/>
Changed output <code>radHorIR</code> to <code>HHorIR</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/376\">#376</a>.
</li>
<li>
January 4, 2016, by Moritz Lauster:<br/>
Added a table in documentation with output variables accessible via <code>weaBus</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/376\">#376</a>.
</li>
<li>
December 15, 2015, by Michael Wetter:<br/>
Added the block <code>cheTemBlaSky</code>. This also allows to graphically
connect the black body sky temperature to the weather bus, which is required
in Dymola 2016 for the variable <code>weaBus.TBlaSky</code> to appear
in the graphical editor.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/377\">#377</a>.
</li>
<li>
September 24, 2015, by Marcus Fuchs:<br/>
Replace Dymola specific annotation by <code>loadSelector</code>
for MSL compliancy as reported by @tbeu at
<a href=\"https://github.com/RWTH-EBC/AixLib/pull/107\">RWTH-EBC/AixLib#107</a>
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Removed redundant but consistent
<code>connect(TBlaSkyCom.TBlaSky, weaBus.TBlaSky)</code>
statement.
This avoids a warning if
<a href=\"modelica://IBPSA.BoundaryConditions.SolarIrradiation.BaseClasses.Examples.SkyClearness\">
IBPSA.BoundaryConditions.SolarIrradiation.BaseClasses.Examples.SkyClearness</a>
is translated in pedantic mode in Dymola 2016.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
March 26, 2015, by Michael Wetter:<br/>
Added option to obtain the black body sky temperature
from a parameter or an input signal.
</li>
<li>
October 17, 2014, by Michael Wetter:<br/>
Corrected error that led the total and opaque sky cover to be ten times
too low if its value was obtained from the parameter or the input connector.
For the standard configuration in which the sky cover is obtained from
the weather data file, the model was correct. This error only affected
the other two possible configurations.
</li>
<li>
September 12, 2014, by Michael Wetter:<br/>
Removed redundant connection <code>connect(conHorRad.HOut, cheHorRad.HIn);</code>.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
May 5, 2013, by Thierry S. Nouidui:<br/>
Added the option to use a constant, an input signal or the weather file as the source
for the ceiling height, the total sky cover, the opaque sky cover, the dew point temperature,
and the infrared horizontal radiation <code>HInfHor</code>.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Improved the algorithm that determines the absolute path of the file.
Now weather files are searched in the path specified, and if not found, the urls
<code>file://</code>, <code>modelica://</code> and <code>modelica://IBPSA</code>
are added in this order to search for the weather file.
This allows using the data reader without having to specify an absolute path,
as long as the <code>IBPSA</code> library
is on the <code>MODELICAPATH</code>.
This change was implemented in
<a href=\"modelica://IBPSA.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath\">
IBPSA.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</a>
and improves this weather data reader.
</li>
<li>
May 2, 2013, by Michael Wetter:<br/>
Added function call to <code>getAbsolutePath</code>.
</li>
<li>
October 16, 2012, by Michael Wetter:<br/>
Added computation of the wet bulb temperature.
Computing the wet bulb temperature introduces a nonlinear
equation. As we have not observed an increase in computing time
because of computing the wet bulb temperature, it is computed
by default. By setting the parameter
<code>computeWetBulbTemperature=false</code>, the computation of the
wet bulb temperature can be removed.
Revised documentation.
</li>
<li>
August 11, 2012, by Wangda Zuo:<br/>
Renamed <code>radHor</code> to <code>radHorIR</code> and
improved the optional inputs for radiation data.
</li>
<li>
July 24, 2012, by Wangda Zuo:<br/>
Corrected the notes of SI unit requirements for input files.
</li>
<li>
July 13, 2012, by Michael Wetter:<br/>
Removed assignment of <code>HGloHor_in</code> in its declaration,
because this gives an overdetermined system if the input connector
is used.
Removed non-required assignments of attribute <code>displayUnit</code>.
</li>
<li>
February 25, 2012, by Michael Wetter:<br/>
Added subbus for solar position, which is needed by irradition and
shading model.
</li>
<li>
November 29, 2011, by Michael Wetter:<br/>
Fixed wrong display unit for <code>pAtm_in_internal</code> and
made propagation of parameter final.
</li>
<li>
October 27, 2011, by Wangda Zuo:<br/>
<ol>
<li>
Added optional connectors for dry bulb temperature, relative humidity, wind speed, wind direction, global horizontal radiation, diffuse horizontal radiation.<br/>
</li>
<li>
Separate the unit conversion for TMY3 data and data validity check.
</li>
</ol>
</li>
<li>
October 3, 2011, by Michael Wetter:<br/>
Propagated value for sky temperature calculation to make it accessible as a parameter.
</li>
<li>
July 20, 2011, by Michael Wetter:<br/>
Added the option to use a constant, an input signal or the weather file as the source
for the atmospheric pressure.
</li><li>
March 15, 2011, by Wangda Zuo:<br/>
Delete the wet bulb temperature since it may cause numerical problem.
</li>
<li>
March 7, 2011, by Wangda Zuo:<br/>
Added wet bulb temperature. Changed reader to read only needed columns.
Added explanation for 30 minutes shift for radiation data.
</li>
<li>
March 5, 2011, by Michael Wetter:<br/>
Changed implementation to obtain longitude and time zone directly
from weather file.
</li>
<li>
June 25, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,
     extent={{-200,-300},{300,300}})));
end ReaderTMY3;
