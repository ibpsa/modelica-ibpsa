within IBPSA.Electrical.DC.Sources.Validation;
model PVSingleDiodeNISTValidation
  "Validation with empirical data from NIST for the date of June 14th 2016"
   extends Modelica.Icons.Example;
  PVSingleDiode pVSystemSingleDiode(
    til=0.17453292519943,
    azi=0,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVThermalEmpMountOpenRack
      partialPVThermal,
    n_mod=312,
    redeclare IBPSA.Electrical.Data.PV.SingleDiodeSharpNUU235F2 data,
    groRef=0.2,
    lat=0.68304158408499,
    lon=-1.3476664539029,
    alt=0.08,
    timZon=-18000)
    annotation (Placement(transformation(extent={{62,0},{82,20}})));
  Modelica.Blocks.Sources.CombiTimeTable NISTdata(
    tableOnFile=true,
    tableName="Roof2016",
    fileName=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/NIST_onemin_Roof_2016.txt"),
    columns={3,5,2,4},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    "The PVSystem model is validaded with measurement data from: https://pvdata.nist.gov/ "
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{46,2},{58,14}})));
  Modelica.Blocks.Interfaces.RealOutput PSim "Simulated DC output power"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Math.Gain kiloWattToWatt(k=1000)
    annotation (Placement(transformation(extent={{80,-36},{92,-24}})));
  Modelica.Blocks.Interfaces.RealOutput PMea "Measured DC power"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  BoundaryConditions.SolarIrradiation.GlobalPerezTiltedSurface HGloTil(til=
        pVSystemSingleDiode.til, azi=pVSystemSingleDiode.azi)
    annotation (Placement(transformation(extent={{38,40},{58,60}})));
  BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data"
    annotation (Placement(transformation(extent={{16,40},{36,60}})));
  Modelica.Blocks.Sources.Constant latLon[2](k={pVSystemSingleDiode.lat,
        pVSystemSingleDiode.lon})
    "Latitude and Longitude for tilt irradiation block"
    annotation (Placement(transformation(extent={{-98,42},{-82,58}})));
  BoundaryConditions.SolarGeometry.ZenithAngle zen
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  BoundaryConditions.WeatherData.Bus weaBus1
                         "Weather data"
    annotation (Placement(transformation(extent={{-44,20},{-24,40}})));
  BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    annotation (Placement(transformation(extent={{-58,0},{-38,20}})));
  BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle solHouAng
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  BoundaryConditions.WeatherData.BaseClasses.SolarTime       solTim
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime       locTim(timZon=
        pVSystemSingleDiode.timZon, lon=pVSystemSingleDiode.lon)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  BoundaryConditions.WeatherData.BaseClasses.EquationOfTime       eqnTim
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Constant nDay(k=(31 + 29 + 31 + 13)*24*3600)
    "Number of validation day (June 14th 2016) in seconds"
    annotation (Placement(transformation(extent={{-98,-44},{-82,-28}})));
  IBPSA.Utilities.Time.ModelTime modTim
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Math.Add calcClockTime(k2=-1) "Computes clock time"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-58,-42})));

equation
  connect(NISTdata.y[1], from_degC.u)
    annotation (Line(points={{61,-30},{64,-30},{64,0},{46,0},{46,8},{44.8,8}},
                                                   color={0,0,127}));
  connect(from_degC.y, pVSystemSingleDiode.TDryBul) annotation (Line(points={{58.6,8},
          {56,8},{56,14.7},{61.1,14.7}},     color={0,0,127}));
  connect(NISTdata.y[2], pVSystemSingleDiode.vWinSpe) annotation (Line(points={{61,-30},
          {64,-30},{64,12.5},{61.1,12.5}},                           color={0,0,
          127}));
  connect(pVSystemSingleDiode.P, PSim)
    annotation (Line(points={{83,10},{110,10}},   color={0,0,127}));
  connect(NISTdata.y[4], kiloWattToWatt.u) annotation (Line(points={{61,-30},{78.8,
          -30}},                    color={0,0,127}));
  connect(kiloWattToWatt.y, PMea)
    annotation (Line(points={{92.6,-30},{110,-30}}, color={0,0,127}));
  connect(HGloTil.weaBus, weaBus) annotation (Line(
      points={{38,50},{26,50}},
      color={255,204,51},
      thickness=0.5));
  connect(NISTdata.y[3], weaBus.HGloHor) annotation (Line(points={{61,-30},{64,-30},
          {64,0},{46,0},{46,36},{26,36},{26,50}},
                                  color={0,0,127}));
  connect(NISTdata.y[3], pVSystemSingleDiode.HGloHor) annotation (Line(points={{61,-30},
          {64,-30},{64,0},{46,0},{46,16.9},{61.1,16.9}},
                                                   color={0,0,127}));
  connect(HGloTil.H, pVSystemSingleDiode.HGloTil) annotation (Line(points={{59,50},
          {64,50},{64,24},{56,24},{56,19.1},{61.1,19.1}},
                                          color={0,0,127}));
  connect(latLon[1].y, weaBus.lat)
    annotation (Line(points={{-81.2,50},{26,50}},color={0,0,127}));
  connect(latLon[2].y, weaBus.lon)
    annotation (Line(points={{-81.2,50},{26,50}},color={0,0,127}));
  connect(zen.weaBus, weaBus1) annotation (Line(
      points={{-20,30},{-34,30}},
      color={255,204,51},
      thickness=0.5));
  connect(zen.y, weaBus.solZen)
    annotation (Line(points={{1,30},{26,30},{26,50}},
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
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,
            100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{
            100,100}}),                                  graphics={
                                                               Text(
          extent={{-92,102},{-34,68}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="1 - Air temperature in °C
2 - Wind speed in m/s
3 - Global horizontal irradiance in W/m2
4 - Ouput power in kW")}),
    experiment(
      StartTime=28684800,
      StopTime=28771200,
      Interval=10,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
   __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Electrical/DC/Sources/Validation/PVGeneratorSingleDiodeNISTValidation.mos"
        "Simulate and plot"),
    Documentation(info="<html><p>
  The PVSystem model is validaded with empirical data from: <a href=
  \"https://pvdata.nist.gov/\">https://pvdata.nist.gov/</a>
</p>
<p>
  The date 14.06.2016 was chosen as an example for the PVSystem model.
</p>
<p>
  The PV mounting is an open rack system based on the ground.
</p>
</html>",revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVSingleDiodeNISTValidation;
