within IDEAS.Climate;
model SimInfoManager
  "Simulation information manager for handling time and climate data required in each for simulation."

replaceable IDEAS.Climate.Meteo.Detail detail(LocNam=city.LocNam)
    "Timeframe detail of the climate data" annotation (choicesAllMatching = true);
replaceable IDEAS.Climate.Meteo.location city
    "Location of the depicted climate data" annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.Angle lat(displayUnit="deg") = city.lat
    "latitude of the locatioin";
  parameter Modelica.SIunits.Angle lon(displayUnit="deg") = city.lon;
  parameter Modelica.SIunits.Temperature Tdes = city.Tdes
    "design outdoor temperature";
  parameter Modelica.SIunits.Temperature TdesGround = city.TdesGround
    "design ground temperature";
  parameter Modelica.SIunits.Time timZonSta = city.timZonSta
    "standard time zone";
  parameter Boolean DST = city.DST "take into account daylight saving time";
  parameter Integer yr = city.yr "depcited year for DST only";

  final parameter Boolean BesTest = Modelica.Utilities.Strings.isEqual(city.LocNam,"BesTest");

public
  Modelica.SIunits.Irradiance solDirPer
    "direct irradiation on normal to solar zenith";
  Modelica.SIunits.Irradiance solDirHor
    "direct irradiation on horizontal surface";
  Modelica.SIunits.Irradiance solDifHor
    "difuse irradiation on horizontal surface";
  Modelica.SIunits.Irradiance solGloHor = solDirHor + solDifHor
    "global irradiation on horizontal";
  Modelica.SIunits.Temperature Te
    "ambient outdoor temperature for determination of sky radiation exchange";
  Modelica.SIunits.Temperature Tsky "effective overall sky temperature";
  Modelica.SIunits.Temperature TeAv = Te
    "running average of ambient outdoor temperature of the last 5 days, not yet implemented";
  Modelica.SIunits.Temperature Tground = TdesGround "ground temperature";
  Modelica.SIunits.Velocity Va "air velocity";
  Real Fc "cloud factor";
  Modelica.SIunits.Irradiance irr;
  Boolean summer;

  Boolean day = true;

  Real workday;
  Real weekend;

  Modelica.SIunits.Time timLoc;
  Modelica.SIunits.Time timSol;
  Modelica.SIunits.Time timCal;

  IDEAS.BaseClasses.Control.Hyst_NoEvent calcWE(uLow=604800, uHigh=432000)
    "calculation of weekend or workday"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  IDEAS.BaseClasses.Control.rem_NoEvent remWE(interval=604800)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

protected
  IDEAS.Climate.Time.SimTimes timMan(
    delay=detail.timestep/2,
    timZonSta=timZonSta,
    lon=lon,
    DST=false,
    ifSolCor=true)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Tables.CombiTable1Ds climate_nonSolar(final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final tableOnFile=true, final tableName="data",final fileName=detail.filNam, final columns = {15,16,12,10})
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Tables.CombiTable1Ds climate_solar(
    final tableOnFile=true, final tableName="data",final fileName=detail.filNam, final columns = {7,11,14},
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

algorithm
    weekend := calcWE.y;
    workday := 1-calcWE.y;

equation

  solDirPer = climate_solar.y[3];
  solDirHor = climate_solar.y[1]-climate_solar.y[2];
  solDifHor = climate_solar.y[2];
  Te = climate_nonSolar.y[1]+273.15;

  if not BesTest then
    Tsky = Te - (23.8 - 0.2025 * (Te-273.15)*(1-0.87*Fc));
    Fc = 0.2;
    Va = 2.5;
  else
    Tsky = climate_nonSolar.y[2]+273.15;
    Fc = climate_nonSolar.y[3]*0.87;
    Va = climate_nonSolar.y[4];
  end if;

  irr = climate_solar.y[1];
  summer = timMan.summer;
  timLoc = timMan.timLoc;
  timSol = timMan.timSol;
  timCal = timMan.timCal;

  connect(remWE.y, calcWE.u) annotation (Line(
      points={{-19,-10},{-0.8,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timMan.timCal, remWE.u) annotation (Line(
      points={{-60,66},{-56,66},{-56,-10},{-42,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timMan.timCalSol, climate_solar.u) annotation (Line(
      points={{-60,62},{-52,62},{-52,30},{-42,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(timMan.timSol, climate_nonSolar.u) annotation (Line(
      points={{-60,70},{-42,70}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(defaultComponentName="sim", defaultComponentPrefixes="inner",  missingInnerMessage="Your model is using an outer \"sim\" component. An inner \"sim\" component is not defined. For simulation drag IDEAS.SimInfoManager into your model.",
        Icon(graphics={
        Ellipse(
          extent={{-70,70},{70,-70}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,50},{2,-2}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{2,0},{18,-16},{14,-20},{-4,-2},{2,0}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,0},{-84,0},{-64,-26},{-44,0},{-70,0}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-84,0},{-64,-26},{-44,0},{-34,-44},{-48,-60},{-80,-40},{-84,
              0}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(graphics));
end SimInfoManager;
