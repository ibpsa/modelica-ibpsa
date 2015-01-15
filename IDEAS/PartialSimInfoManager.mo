within IDEAS;
partial model PartialSimInfoManager
  "Partial providing structure for SimInfoManager"
  parameter String filDir = Modelica.Utilities.Files.loadResource("modelica://IDEAS") + "/Inputs/"
    "Directory containing the weather data file, default under IDEAS/Inputs/";
  parameter String filNam = "Uccle.TMY" "Name of weather data file"
    annotation(Dialog(enable=useTmy3Reader));
  parameter Modelica.SIunits.Angle lat(displayUnit="deg") = 0.88749992463912
    "latitude of the locatioin";
  parameter Modelica.SIunits.Angle lon(displayUnit="deg") = 0.075921822461753;
  parameter Modelica.SIunits.Time timZonSta(displayUnit="h") = 3600
    "standard time zone";

  final parameter String filNamClim=filDir + filNam;

  parameter Boolean occBeh=false
    "put to true if  user behaviour is to be read from files"
    annotation (Dialog(group="User behaviour"));

  parameter Boolean DHW=false
    "put to true if domestic how water (DHW) consumption is to be read from files"
    annotation (Dialog(group="User behaviour"));
  parameter Boolean PV=false
    "put to true if photovoltaics is to be read from files "
    annotation (Dialog(group="Photovoltaics"));

protected
  replaceable IDEAS.Occupants.Extern.Interfaces.Occ_Files occupants
    constrainedby IDEAS.Occupants.Extern.Interfaces.Occ_Files
    "Specifies the files with occupant behavior"
    annotation (Dialog(group="User behaviour", enable=occBeh));

public
  parameter Integer nOcc=33 "Number of occupant profiles to be read"
    annotation (Dialog(group="User behaviour", enable=occBeh));

  parameter String fileNamePv="onePVpanel10min"
    "Filename for photvoltaic profiles"
    annotation (Dialog(group="Photovoltaics", enable=PV));
  parameter Integer nPV=33 "Number of photovoltaic profiles"
    annotation (Dialog(group="Photovoltaics", enable=PV));
  parameter Integer PNom=1000 "Nominal power (W) of the photovoltaic profiles"
    annotation (Dialog(group="Photovoltaics", enable=PV));
  parameter Boolean useTmy3Reader = true
    "Set to false if you do not want to use the TMY3 reader for providing data";
  final parameter Modelica.SIunits.Temperature Tdes = -8 + 273.15
    "design outdoor temperature";

  final parameter Modelica.SIunits.Temperature TdesGround = 10 + 273.15
    "design ground temperature";

protected
  final parameter Boolean DST = true
    "boolean to take into account daylight saving time";
  final parameter Integer yr = 2014 "depcited year for DST only";

  final parameter Boolean BesTest = Modelica.Utilities.Strings.isEqual(filNam, "BesTest.txt")
    "boolean to determine if this simulation is a BESTEST simulation";

public
  Modelica.SIunits.Irradiance solDirPer
    "direct irradiation on normal to solar zenith";
  Modelica.SIunits.Irradiance solDirHor
    "direct irradiation on horizontal surface";
  Modelica.SIunits.Irradiance solDifHor
    "difuse irradiation on horizontal surface";
  Modelica.SIunits.Irradiance solGloHor "global irradiation on horizontal";
  Modelica.SIunits.Temperature Te
    "ambient outdoor temperature for determination of sky radiation exchange";
  Modelica.SIunits.Temperature Tsky "effective overall sky temperature";
  Modelica.SIunits.Temperature TeAv
    "running average of ambient outdoor temperature of the last 5 days, not yet implemented";
  Modelica.SIunits.Temperature Tground "ground temperature";
  Modelica.SIunits.Velocity Va "air velocity";
  Real Fc "cloud factor";
  Modelica.SIunits.Irradiance irr "Irradiance";
  Boolean summer;

  Real relHum(final unit="1") "Relative humidity";
  Modelica.SIunits.Temperature TDewPoi "Dewpoint";

  Boolean day=true;

  Modelica.SIunits.Time timLoc "Local time";
  Modelica.SIunits.Time timSol "Solar time";
  Modelica.SIunits.Time timCal "Calendar time";

  Real hCon=IDEAS.Utilities.Math.Functions.spliceFunction(x=Va-5, pos= 7.1*abs(Va)^(0.78), neg=  4.0*Va + 5.6, deltax=0.5);
  Real TePow4 = Te^4;
  Real TskyPow4 = Tsky^4;
  Real angDec=asin(-sin(23.45*Modelica.Constants.pi/180)*cos((timLoc/86400 +
    10)*2*Modelica.Constants.pi/365.25));
  Real angHou =  (timSol/3600 - 12)*2*Modelica.Constants.pi/24;
  Real angZen = acos(cos(lat)*cos(angDec)*cos(angHou) + sin(lat)*sin(angDec));

protected
  IDEAS.Climate.Time.SimTimes timMan(
    timZonSta=timZonSta,
    lon=lon,
    DST=false,
    ifSolCor=true)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Modelica.Blocks.Tables.CombiTable1Ds tabQCon(
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    fileName=filDir + occupants.filQCon,
    columns=2:nOcc + 1) if occBeh
    annotation (Placement(transformation(extent={{-40,-34},{-26,-20}})));
  Modelica.Blocks.Tables.CombiTable1Ds tabQRad(
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    fileName=filDir + occupants.filQRad,
    columns=2:nOcc + 1) if occBeh
    annotation (Placement(transformation(extent={{-36,-38},{-22,-24}})));
  Modelica.Blocks.Sources.CombiTimeTable tabPre(
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    fileName=filDir + occupants.filPres,
    columns=2:nOcc + 1) if occBeh
    annotation (Placement(transformation(extent={{0,-34},{14,-20}})));
  Modelica.Blocks.Tables.CombiTable1Ds tabP(
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    fileName=filDir + occupants.filP,
    columns=2:nOcc + 1) if occBeh
    annotation (Placement(transformation(extent={{-40,-58},{-26,-44}})));
  Modelica.Blocks.Tables.CombiTable1Ds tabQ(
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    fileName=filDir + occupants.filQ,
    columns=2:nOcc + 1) if occBeh
    annotation (Placement(transformation(extent={{-36,-62},{-22,-48}})));
  Modelica.Blocks.Sources.CombiTimeTable tabDHW(
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    fileName=filDir + occupants.filDHW,
    columns=2:nOcc + 1) if DHW
    annotation (Placement(transformation(extent={{0,-58},{14,-44}})));
  Modelica.Blocks.Tables.CombiTable1Ds tabPPV(
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableOnFile=true,
    tableName="data",
    fileName=filDir + fileNamePv,
    columns=2:nPV + 1) if PV
    annotation (Placement(transformation(extent={{-36,-12},{-22,2}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=filNamClim, lat=lat, lon=lon, timZon=timZonSta) if useTmy3Reader
    annotation (Placement(transformation(extent={{-38,10},{-18,30}})));
  Utilities.Psychrometrics.X_pTphi XiEnv(use_p_in=false)
    annotation (Placement(transformation(extent={{-30,-96},{-10,-76}})));
  Modelica.Blocks.Sources.RealExpression phiEnv(y=relHum)
    annotation (Placement(transformation(extent={{-70,-102},{-50,-82}})));
  Modelica.Blocks.Sources.RealExpression TEnv(y=Te)
    annotation (Placement(transformation(extent={{-70,-86},{-50,-66}})));
  Climate.Meteo.Solar.BaseClasses.RelativeAirMass
                  relativeAirMass
    annotation (Placement(transformation(extent={{-78,42},{-60,60}})));
  Climate.Meteo.Solar.BaseClasses.SkyBrightness
                skyBrightness
    annotation (Placement(transformation(extent={{-52,42},{-34,60}})));
  Climate.Meteo.Solar.BaseClasses.SkyClearness
               skyClearness
    annotation (Placement(transformation(extent={{-78,70},{-60,88}})));
public
  Climate.Meteo.Solar.BaseClasses.SkyBrightnessCoefficients
                            skyBrightnessCoefficients
    annotation (Placement(transformation(extent={{-18,60},{0,78}})));
protected
  Modelica.Blocks.Sources.RealExpression zenithAngle(y=angZen)
    annotation (Placement(transformation(extent={{-110,46},{-90,66}})));
  Modelica.Blocks.Sources.RealExpression solGloHorIn(y=solGloHor)
    annotation (Placement(transformation(extent={{-110,78},{-90,98}})));
  Modelica.Blocks.Sources.RealExpression solDifHorIn(y=solDifHor)
    annotation (Placement(transformation(extent={{-110,62},{-90,82}})));
equation

  connect(timMan.timCal, tabQCon.u) annotation (Line(
      points={{-60,6},{-52,6},{-52,-27},{-41.4,-27}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timMan.timCal, tabQRad.u) annotation (Line(
      points={{-60,6},{-50,6},{-50,-31},{-37.4,-31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timMan.timCal, tabP.u) annotation (Line(
      points={{-60,6},{-52,6},{-52,-51},{-41.4,-51}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timMan.timCal, tabQ.u) annotation (Line(
      points={{-60,6},{-50,6},{-50,-55},{-37.4,-55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timMan.timCal, tabPPV.u) annotation (Line(
      points={{-60,6},{-48,6},{-48,-5},{-37.4,-5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timMan.timSol, weaDat.sol) annotation (Line(
      points={{-60,10},{-50,10},{-50,12},{-38,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEnv.y,XiEnv. T) annotation (Line(
      points={{-49,-76},{-32,-76},{-32,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(phiEnv.y,XiEnv. phi) annotation (Line(
      points={{-49,-92},{-32,-92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyClearness.skyCle,skyBrightnessCoefficients. skyCle) annotation (
      Line(
      points={{-59.46,79},{-56,79},{-56,70.8},{-18,70.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyBrightness.skyBri,skyBrightnessCoefficients. skyBri) annotation (
      Line(
      points={{-34,56.4},{-22,56.4},{-22,67.2},{-18,67.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relativeAirMass.relAirMas,skyBrightness. relAirMas) annotation (Line(
      points={{-60,56.4},{-52,56.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zenithAngle.y, relativeAirMass.angZen) annotation (Line(
      points={{-89,56},{-84,56},{-84,56.4},{-78,56.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zenithAngle.y, skyClearness.angZen) annotation (Line(
      points={{-89,56},{-89,84.4},{-78,84.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyBrightnessCoefficients.angZen, skyClearness.angZen) annotation (
      Line(
      points={{-18,74.4},{-52,74.4},{-52,96},{-84,96},{-84,84},{-86,84},{-85,84.4},
          {-78,84.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyClearness.solGloHor, solGloHorIn.y) annotation (Line(
      points={{-78,79},{-88,79},{-88,88},{-89,88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDifHorIn.y, skyClearness.solDifHor) annotation (Line(
      points={{-89,72},{-84,72},{-84,73.6},{-78,73.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyClearness.solDifHor, skyBrightness.solDifHor) annotation (Line(
      points={{-78,73.6},{-80,73.6},{-80,66},{-56,66},{-56,51},{-52,51}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="sim",
    defaultComponentPrefixes="inner",
    missingInnerMessage=
        "Your model is using an outer \"sim\" component. An inner \"sim\" component is not defined. For simulation drag IDEAS.SimInfoManager into your model.",
    Icon(graphics={
        Line(points={{-80,-30},{88,-30}}, color={0,0,0}),
        Line(points={{-76,-68},{-46,-30}}, color={0,0,0}),
        Line(points={{-42,-68},{-12,-30}}, color={0,0,0}),
        Line(points={{-8,-68},{22,-30}},  color={0,0,0}),
        Line(points={{28,-68},{58,-30}}, color={0,0,0}),
        Rectangle(
          extent={{-60,76},{60,-24}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
        Rectangle(
          extent={{-50,66},{50,-4}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          pattern=LinePattern.None),
        Rectangle(
          extent={{-10,-34},{10,-24}},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-40,-60},{-40,-60}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,-34},{40,-34},{50,-44},{-52,-44},{-40,-34}},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{44,0},{38,40}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{34,0},{28,12}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{24,0},{18,56}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{14,0},{8,36}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{4,0},{-2,12}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-6,0},{-46,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Text(
          extent={{-50,66},{-20,26}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Italic},
          fontName="Bookman Old Style",
          textString="i")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    Documentation(info="<html>
</html>"));
end PartialSimInfoManager;
