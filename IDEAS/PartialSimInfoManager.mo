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

  replaceable IDEAS.Occupants.Extern.Interfaces.Occ_Files occupants
    constrainedby IDEAS.Occupants.Extern.Interfaces.Occ_Files
    "Specifies the files with occupant behavior"
    annotation (Dialog(group="User behaviour", enable=occBeh));
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
    annotation (Placement(transformation(extent={{-36,2},{-22,16}})));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=filNamClim, lat=lat, lon=lon, timZon=timZonSta) if useTmy3Reader
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Utilities.Psychrometrics.X_pTphi XiEnv(use_p_in=false)
    annotation (Placement(transformation(extent={{-30,-96},{-10,-76}})));
  Modelica.Blocks.Sources.RealExpression phiEnv(y=relHum)
    annotation (Placement(transformation(extent={{-70,-102},{-50,-82}})));
  Modelica.Blocks.Sources.RealExpression TEnv(y=Te)
    annotation (Placement(transformation(extent={{-70,-86},{-50,-66}})));
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
      points={{-60,6},{-48,6},{-48,9},{-37.4,9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timMan.timSol, weaDat.sol) annotation (Line(
      points={{-60,10},{-50,10},{-50,42},{-40,42}},
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
  annotation (
    defaultComponentName="sim",
    defaultComponentPrefixes="inner",
    missingInnerMessage=
        "Your model is using an outer \"sim\" component. An inner \"sim\" component is not defined. For simulation drag IDEAS.SimInfoManager into your model.",
    Icon(graphics={
        Ellipse(
          extent={{-60,78},{74,-58}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{18,52},{30,44},{36,44},{36,46},{34,48},{34,56},{22,60},{16,
              60},{10,58},{6,54},{8,52},{2,52},{-8,48},{-14,52},{-24,48},{-26,
              40},{-18,40},{-14,32},{-14,28},{-12,24},{-16,10},{-8,2},{-8,-2},{
              -6,-6},{-4,-4},{0,-6},{2,-12},{10,-18},{18,-24},{22,-30},{26,-36},
              {32,-44},{34,-50},{36,-58},{60,-44},{72,-28},{72,-18},{64,-14},{
              58,-12},{48,-12},{44,-14},{40,-16},{34,-16},{26,-24},{20,-22},{20,
              -18},{24,-12},{16,-16},{8,-12},{8,-8},{10,-2},{16,0},{24,0},{28,-2},
              {30,-8},{32,-6},{28,2},{30,12},{34,18},{36,20},{38,24},{34,26},{
              36,32},{26,38},{18,38},{20,32},{18,28},{12,32},{14,38},{16,42},{
              24,40},{22,46},{16,50},{18,52}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-34,64},{-30,62},{-26,64},{-24,60},{-36,58},{-24,52},{-16,54},
              {-14,62},{-8,68},{6,74},{12,74},{22,70},{28,64},{30,64},{44,62},{
              46,58},{42,56},{50,50},{66,34},{68,20},{74,12},{80,46},{70,78},{
              44,90},{2,90},{-32,80},{-34,64}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Bitmap(extent={{22,-8},{20,-8}}, fileName=""),
        Ellipse(extent={{-60,78},{74,-58}}, lineColor={95,95,95}),
        Polygon(
          points={{-66,-20},{-70,-16},{-72,-20},{-68,-30},{-60,-42},{-60,-40},{
              -62,-32},{-66,-20}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,-4},{-58,0},{-54,-2},{-54,-12},{-52,-20},{-48,-24},{-50,
              -28},{-50,-30},{-54,-28},{-56,-26},{-58,-12},{-62,-4}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,0},{-46,4},{-42,4},{-40,0},{-40,-4},{-38,-16},{-38,-22},
              {-40,-24},{-44,-22},{-44,-16},{-48,0}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,2},{-28,4},{-24,4},{-24,0},{-24,-12},{-24,-20},{-26,-24},
              {-30,-24},{-32,-6},{-32,2}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-6,-36},{-12,-42},{-8,-42},{-4,-36},{0,-26},{-2,-22},{-6,-22},
              {-8,-26},{-10,-32},{-8,-36},{-6,-36}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-60,-44},{-58,-40},{-54,-40},{-50,-36},{-42,-32},{-36,-32},{
              -32,-28},{-26,-28},{-24,-34},{-24,-36},{-26,-38},{-20,-42},{-16,-46},
              {-12,-46},{-8,-48},{-10,-52},{-12,-60},{-16,-66},{-20,-68},{-26,-70},
              {-30,-70},{-34,-70},{-36,-74},{-40,-76},{-42,-76},{-48,-72},{-54,
              -62},{-60,-44}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,67,62},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics),
    Documentation(info="<html>
</html>"));
end PartialSimInfoManager;
