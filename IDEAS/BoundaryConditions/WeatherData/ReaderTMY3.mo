within IDEAS.BoundaryConditions.WeatherData;
block ReaderTMY3 "Reader for TMY3 weather data"

  parameter String filNam="" "Name of weather data file" annotation (Dialog(
        __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
            "Select weather file")));
  parameter Modelica.SIunits.Angle lon(displayUnit="deg") "Longitude";
  parameter Modelica.SIunits.Angle lat(displayUnit="deg") "Latitude";
  parameter Modelica.SIunits.Time timZon(displayUnit="h") "Time zone";
  Bus weaBus "Weather Data Bus" annotation (Placement(transformation(extent={{
            294,-10},{314,10}}), iconTransformation(extent={{190,-10},{210,10}})));
  BaseClasses.SolarSubBus solBus "Sub bus with solar position"
    annotation (Placement(transformation(extent={{-2,-304},{18,-284}}),
        iconTransformation(extent={{-2,-200},{18,-180}})));

  constant Real epsCos = 1e-6 "Small value to avoid division by 0";

//protected
  Modelica.Blocks.Tables.CombiTable1Ds datRea(
    final tableOnFile=true,
    final fileName=BaseClasses.getAbsolutePath(                                         filNam),
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns={2,3,4,5,6,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,
        28,29,30},
    final tableName="data") "Data reader"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  BaseClasses.CheckTemperature cheTemDryBul "Check dry bulb temperature "
    annotation (Placement(transformation(extent={{160,-200},{180,-180}})));
  BaseClasses.CheckTemperature cheTemDewPoi "Check dew point temperature"
    annotation (Placement(transformation(extent={{160,-240},{180,-220}})));
  BaseClasses.ConvertRelativeHumidity conRelHum
    "Convert the relative humidity from percentage to [0, 1] "
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  BaseClasses.CheckPressure chePre "Check the air pressure"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));
  BaseClasses.CheckSkyCover cheTotSkyCov "Check the total sky cover"
    annotation (Placement(transformation(extent={{160,-40},{180,-20}})));
  BaseClasses.CheckSkyCover cheOpaSkyCov "Check the opaque sky cover"
    annotation (Placement(transformation(extent={{160,-160},{180,-140}})));
  BaseClasses.CheckRadiation cheGloHorRad
    "Check the global horizontal radiation"
    annotation (Placement(transformation(extent={{160,160},{180,180}})));
  BaseClasses.CheckRadiation cheDifHorRad
    "Check the diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{160,120},{180,140}})));
  BaseClasses.CheckRadiation cheDirNorRad "Check the direct normal radiation"
    annotation (Placement(transformation(extent={{160,200},{180,220}})));
  BaseClasses.CheckCeilingHeight cheCeiHei "Check the ceiling height"
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  BaseClasses.CheckWindSpeed cheWinSpe "Check the wind speed"
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
  BaseClasses.CheckRadiation cheHorRad "Check the horizontal radiation"
    annotation (Placement(transformation(extent={{160,240},{180,260}})));
  BaseClasses.CheckWindDirection cheWinDir "Check the wind direction"
    annotation (Placement(transformation(extent={{160,-280},{180,-260}})));
  SkyTemperature.BlackBody TBlaSky "Check the sky black-body temperature"
    annotation (Placement(transformation(extent={{240,-220},{260,-200}})));
  IDEAS.BoundaryConditions.WeatherData.BaseClasses.SimulationTime simTim
    "Simulation time"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Modelica.Blocks.Math.Add add
    "Add 30 minutes to time to shift weather data reader"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Modelica.Blocks.Sources.Constant con30mins(final k=1800)
    "Constant used to shift weather data reader"
    annotation (Placement(transformation(extent={{-180,192},{-160,212}})));
  Modelica.Blocks.Tables.CombiTable1Ds datRea1(
    final tableOnFile=true,
    final fileName=IDEAS.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(filNam),
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    final columns=8:11,
    final tableName="data") "Data reader"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  IDEAS.BoundaryConditions.WeatherData.BaseClasses.ConvertTime conTim1
    "Convert simulation time to calendar time"
    annotation (Placement(transformation(extent={{-110,160},{-90,180}})));
  BaseClasses.ConvertTime conTim "Convert simulation time to calendar time"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Modelica.Blocks.Math.UnitConversions.From_deg conWinDir
    "Convert the wind direction unit from [deg] to [rad]"
    annotation (Placement(transformation(extent={{120,-280},{140,-260}})));
  Modelica.Blocks.Math.UnitConversions.From_degC conTDryBul
    annotation (Placement(transformation(extent={{120,-200},{140,-180}})));
  BaseClasses.ConvertRadiation conHorRad
    annotation (Placement(transformation(extent={{120,240},{140,260}})));
  Modelica.Blocks.Math.UnitConversions.From_degC conTDewPoi
    "Convert the dew point temperature form [degC] to [K]"
    annotation (Placement(transformation(extent={{120,-240},{140,-220}})));
  BaseClasses.ConvertRadiation conDirNorRad
    annotation (Placement(transformation(extent={{120,200},{140,220}})));
  BaseClasses.ConvertRadiation conGloHorRad
    annotation (Placement(transformation(extent={{120,160},{140,180}})));
  BaseClasses.ConvertRadiation conDifHorRad
    annotation (Placement(transformation(extent={{120,120},{140,140}})));
  BaseClasses.CheckRelativeHumidity cheRelHum
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
  SolarGeometry.BaseClasses.AltitudeAngle altAng "Solar altitude angle"
    annotation (Placement(transformation(extent={{-30,-280},{-10,-260}})));
   SolarGeometry.BaseClasses.ZenithAngle zenAng(
     final lat = lat) "Zenith angle"
    annotation (Placement(transformation(extent={{-80,-226},{-60,-206}})));
   SolarGeometry.BaseClasses.Declination decAng "Declination angle"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
   SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng
    annotation (Placement(transformation(extent={{-140,-250},{-120,-230}})));
  Modelica.Blocks.Sources.Constant latitude(final k=lat) "Latitude"
    annotation (Placement(transformation(extent={{-180,-280},{-160,-260}})));
  Modelica.Blocks.Sources.Constant longitude(final k=lon) "Longitude"
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));

public
  Modelica.Blocks.Interfaces.RealInput sol annotation (Placement(transformation(
          extent={{-220,-180},{-180,-140}}), iconTransformation(extent={{-220,-180},
            {-180,-140}})));
equation
  //---------------------------------------------------------------------------
  // Select atmospheric pressure connector
  connect(datRea.y[4], chePre.PIn);
  //---------------------------------------------------------------------------
  // Select dry bulb temperature connector
  connect(conTDryBul.y, cheTemDryBul.TIn);
  //---------------------------------------------------------------------------
  // Select relative humidity connector
  connect(conRelHum.relHumOut, cheRelHum.relHumIn);
  //---------------------------------------------------------------------------
  // Select wind speed connector
  connect(datRea.y[12], cheWinSpe.winSpeIn);
  //---------------------------------------------------------------------------
  // Select wind direction connector
  connect(conWinDir.y, cheWinDir.nIn);
  //---------------------------------------------------------------------------
  // Select global horizontal radiation connector
  connect(conGloHorRad.HOut, cheGloHorRad.HIn);
  //---------------------------------------------------------------------------
  // Select diffuse horizontal radiation connector
  connect(conDifHorRad.HOut, cheDifHorRad.HIn);
  //---------------------------------------------------------------------------
  // Select direct normal radiation connector
  connect(conDirNorRad.HOut, cheDirNorRad.HIn);

  connect(chePre.POut, weaBus.pAtm) annotation (Line(
      points={{181,70},{220,70},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheTotSkyCov.nOut, weaBus.nTot) annotation (Line(
      points={{181,-30},{220,-30},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheOpaSkyCov.nOut, weaBus.nOpa) annotation (Line(
      points={{181,-150},{220,-150},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheGloHorRad.HOut, weaBus.HGloHor) annotation (Line(
      points={{181,170},{220,170},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheDifHorRad.HOut, weaBus.HDifHor) annotation (Line(
      points={{181,130},{220,130},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheDirNorRad.HOut, weaBus.HDirNor) annotation (Line(
      points={{181,210},{220,210},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheCeiHei.ceiHeiOut, weaBus.celHei) annotation (Line(
      points={{181,-110},{220,-110},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheWinSpe.winSpeOut, weaBus.winSpe) annotation (Line(
      points={{181,-70},{220,-70},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheHorRad.HOut, weaBus.radHorIR) annotation (Line(
      points={{181,250},{220,250},{220,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheWinDir.nOut, weaBus.winDir) annotation (Line(
      points={{181,-270},{280,-270},{280,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheOpaSkyCov.nOut, TBlaSky.nOpa) annotation (Line(
      points={{181,-150},{220,-150},{220,-213},{238,-213}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheHorRad.HOut, TBlaSky.radHorIR) annotation (Line(
      points={{181,250},{220,250},{220,-218},{238,-218}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBlaSky.TBlaSky, weaBus.TBlaSky) annotation (Line(
      points={{261,-210},{280,-210},{280,0},{292,0},{292,5.55112e-16},{304,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(simTim.y, weaBus.cloTim) annotation (Line(
      points={{-159,6.10623e-16},{34.75,6.10623e-16},{34.75,0},{124.5,0},{124.5,
          5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(simTim.y, add.u2) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,164},{-142,164}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con30mins.y, add.u1) annotation (Line(
      points={{-159,202},{-150,202},{-150,176},{-142,176}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, conTim1.simTim) annotation (Line(
      points={{-119,170},{-112,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTim1.calTim, datRea1.u) annotation (Line(
      points={{-89,170},{-82,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(simTim.y, conTim.simTim) annotation (Line(
      points={{-159,6.10623e-16},{-150,6.10623e-16},{-150,-30},{-122,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTim.calTim, datRea.u) annotation (Line(
      points={{-99,-30},{-82,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[13], cheTotSkyCov.nIn) annotation (Line(
      points={{-59,-30},{158,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[14], cheOpaSkyCov.nIn) annotation (Line(
      points={{-59,-30},{20,-30},{20,-150},{158,-150}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[16], cheCeiHei.ceiHeiIn) annotation (Line(
      points={{-59,-30},{20,-30},{20,-110},{158,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[11], conWinDir.u) annotation (Line(
      points={{-59,-30},{20,-30},{20,-270},{118,-270}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[1], conHorRad.HIn) annotation (Line(
      points={{-59,170},{20,170},{20,250},{118,250}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conHorRad.HOut, cheHorRad.HIn) annotation (Line(
      points={{141,250},{158,250}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheTemDryBul.TOut, TBlaSky.TDryBul) annotation (Line(
      points={{181,-190},{220,-190},{220,-202},{238,-202}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[1], conTDryBul.u) annotation (Line(
      points={{-59,-30},{20,-30},{20,-190},{118,-190}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea.y[2], conTDewPoi.u) annotation (Line(
      points={{-59,-30},{20,-30},{20,-230},{118,-230}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conTDewPoi.y, cheTemDewPoi.TIn) annotation (Line(
      points={{141,-230},{158,-230}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheTemDewPoi.TOut, weaBus.TDewPoi) annotation (Line(
      points={{181,-230},{280,-230},{280,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TBlaSky.TDewPoi, cheTemDewPoi.TOut) annotation (Line(
      points={{238,-207},{220,-207},{220,-230},{181,-230}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[3], conDirNorRad.HIn) annotation (Line(
      points={{-59,170},{20,170},{20,210},{118,210}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[2], conGloHorRad.HIn) annotation (Line(
      points={{-59,170},{30,170},{30,170},{118,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(datRea1.y[4], conDifHorRad.HIn) annotation (Line(
      points={{-59,170},{20,170},{20,130},{118,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRelHum.relHumIn, datRea.y[3]) annotation (Line(
      points={{118,30},{20,30},{20,-30},{-59,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cheRelHum.relHumOut, weaBus.relHum) annotation (Line(
      points={{181,30},{280,30},{280,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(cheTemDryBul.TOut, weaBus.TDryBul) annotation (Line(
      points={{181,-190},{280,-190},{280,5.55112e-16},{304,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(decAng.decAng, zenAng.decAng)
                                     annotation (Line(
      points={{-119,-210},{-82,-210},{-82,-210.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHouAng.solHouAng, zenAng.solHouAng)
                                              annotation (Line(
      points={{-119,-240},{-100,-240},{-100,-220.8},{-82,-220.8}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(decAng.nDay, simTim.y) annotation (Line(
      points={{-142,-210},{-150,-210},{-150,-180},{0,-180},{0,6.10623e-16},{
          -159,6.10623e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zenAng.zen, altAng.zen) annotation (Line(
      points={{-59,-216},{-40,-216},{-40,-270},{-32,-270}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(altAng.alt, solBus.alt) annotation (Line(
      points={{-9,-270},{8,-270},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(zenAng.zen, solBus.zen) annotation (Line(
      points={{-59,-216},{-40,-216},{-40,-294},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(solBus, weaBus.sol) annotation (Line(
      points={{8,-294},{122,-294},{122,-292},{290,-292},{290,5.55112e-16},{304,
          5.55112e-16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  connect(decAng.decAng, solBus.dec) annotation (Line(
      points={{-119,-210},{-100,-210},{-100,-294},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(solHouAng.solHouAng, solBus.solHouAng) annotation (Line(
      points={{-119,-240},{-100,-240},{-100,-294},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(longitude.y, solBus.lon) annotation (Line(
      points={{-119,-270},{-100,-270},{-100,-294},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(latitude.y, solBus.lat) annotation (Line(
      points={{-159,-270},{-150,-270},{-150,-294},{8,-294}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(sol, weaBus.solTim) annotation (Line(
      points={{-200,-160},{54,-160},{54,0},{304,0}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(sol, solHouAng.solTim) annotation (Line(
      points={{-200,-160},{-172,-160},{-172,-240},{-142,-240}},
      color={0,0,127},
      smooth=Smooth.None));
 annotation (
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
        Ellipse(
          extent={{-146,154},{28,-20}},
          lineColor={255,220,220},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,0}),
        Polygon(
          points={{104,76},{87.9727,12.9844},{88,12},{120,22},{148,20},{174,8},
              {192,-58},{148,-132},{20,-140},{-130,-136},{-156,-60},{-140,-6},{
              -92,-4},{-68.2109,-21.8418},{-68,-22},{-82,40},{-48,90},{44,110},
              {104,76}},
          lineColor={220,220,220},
          lineThickness=0.1,
          fillPattern=FillPattern.Sphere,
          smooth=Smooth.Bezier,
          fillColor={230,230,230})}),
    Documentation(info="<html>
<p>
This component reads TMY3 weather data (Wilcox and Marion, 2008) or user specified weather data. 
</p>
<p>
The following parameters are automatically read from the weather file:
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
<p>
By default, the data bus contains the wet bulb temperature.
This introduces a nonlinear equation.
However, we have not observed an increase in computing time because
of this equation.
To disable the computation of the wet bulb temperature, set
<code>computeWetBulbTemperature=false</code>.
</p>
<p>
This model has the option of using a constant value, using the data from the weather file, 
or using data from an input connector for the following variables: 
atmospheric pressure, relative humidity, dry bulb temperature, 
global horizontal radiation, diffuse horizontal radiation, wind direction and wind speed.
</p>
<p>
By default, all data are obtained from the weather data file,
except for the atmospheric pressure, which is set to the
parameter <code>pAtm=101325</code> Pascals.
</p>
<p>
The parameter <code>*Sou</code> configures the source of the data.
For the atmospheric pressure, dry bulb temperature, relative humidity, wind speed and wind direction,
the enumeration
<a href=\"modelica://Buildings.BoundaryConditions.Types.DataSource\">
Buildings.BoundaryConditions.Types.DataSource</a>
is used as follows:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
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
<a href=\"modelica://Buildings.BoundaryConditions.Types.RadiationDataSource\">
Buildings.BoundaryConditions.Types.RadiationDataSource</a>,
and allows the following configurations:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
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
<p>
<b>Notes</b>
</p>
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
<p>
The ReaderTMY3 should only be used with TMY3 data. It contains a time shift for solar radiation data that is explained below. This time shift needs to be removed if the user may want to use the ReaderTMY3 for other weather data types. 
</p>
</li>
</ol>
<h4>Implementation</h4>
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
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/BoundaryConditions/WeatherData/RadiationTimeShift.png\" border=\"1\" />
</p>
<h4>References</h4>
<ul>
<li>
Wilcox S. and W. Marion. <i>Users Manual for TMY3 Data Sets</i>. 
Technical Report, NREL/TP-581-43156, revised May 2008.
</li>
</ul>
</html>
", revisions="<html>
<ul>
<li>
October 8, 2013, by Michael Wetter:<br/>
Improved the algorithm that determines the absolute path of the file.
Now weather files are searched in the path specified, and if not found, the urls
<code>file://</code>, <code>modelica://</code> and <code>modelica://Buildings</code>
are added in this order to search for the weather file.
This allows using the data reader without having to specify an absolute path,
as long as the <code>Buildings</code> library
is on the <code>MODELICAPATH</code>.
This change was implemented in 
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</a>
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
1. Added optional connectors for dry bulb temperature, relative humidity, wind speed, wind direction, global horizontal radiation, diffuse horizontal radiation.<br/>
2. Separate the unit convertion for TMY3 data and data validity check. 
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
                                                      extent={{-200,-300},{300,300}}),
        graphics));
end ReaderTMY3;
