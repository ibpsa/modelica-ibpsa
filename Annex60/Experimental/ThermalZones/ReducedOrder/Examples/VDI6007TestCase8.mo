within Annex60.Experimental.ThermalZones.ReducedOrder.Examples;
model VDI6007TestCase8 "Illustrates the use of ThermalZoneTwoElements"

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Annex60.BoundaryConditions.Types.DataSource.Parameter,
    ceiHeiSou=Annex60.BoundaryConditions.Types.DataSource.Parameter,
    totSkyCovSou=Annex60.BoundaryConditions.Types.DataSource.Parameter,
    opaSkyCovSou=Annex60.BoundaryConditions.Types.DataSource.Parameter,
    winSpeSou=Annex60.BoundaryConditions.Types.DataSource.Parameter,
    winDirSou=Annex60.BoundaryConditions.Types.DataSource.Parameter,
    calTSky=Annex60.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation,
    computeWetBulbTemperature=false,
    TDryBulSou=Annex60.BoundaryConditions.Types.DataSource.Input,
    TDewPoiSou=Annex60.BoundaryConditions.Types.DataSource.Parameter,
    relHumSou=Annex60.BoundaryConditions.Types.DataSource.Parameter,
    HInfHorSou=Annex60.BoundaryConditions.Types.DataSource.Input,
    TBlaSkySou=Annex60.BoundaryConditions.Types.DataSource.Input,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Annex60/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
    HSou=Annex60.BoundaryConditions.Types.RadiationDataSource.File)
    annotation (Placement(transformation(extent={{-98,52},{-78,72}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[2](each outSkyCon=true,
      each outGroCon=true,
    each til=1.5707963267949,
    each lat=0.87266462599716,
    azi={3.1415926535898,4.7123889803847})
    annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[2](
    each til=1.5707963267949,
    each lat=0.87266462599716,
    azi={3.1415926535898,4.7123889803847})
    annotation (Placement(transformation(extent={{-68,52},{-48,72}})));
  BoundaryConditions.SkyTemperature.BlackBody TBlaSky(calTSky=Annex60.BoundaryConditions.Types.SkyTemperatureCalculation.HorizontalRadiation)
    annotation (Placement(transformation(extent={{-66,-30},{-46,-10}})));
  CorrectionSolarGain.CorGDoublePane corGDoublePane(n=2, UWin=2.1)
    annotation (Placement(transformation(extent={{6,54},{26,74}})));
  Modelica.Blocks.Math.Sum
            aggWindow(nin=2, k={0.5,0.5})
    annotation (Placement(transformation(extent={{44,57},{58,71}})));
  ROM.ThermalZoneTwoElements thermalZoneTwoElements(
    VAir=52.5,
    AExt=11.5,
    alphaExt=2.7,
    AWin=14,
    ATransparent=14,
    alphaWin=2.7,
    gWin=1,
    ratioWinConRad=0.09,
    nExt=1,
    RExt={0.00331421908725},
    CExt={5259932.23},
    alphaRad=5,
    AInt=60.5,
    alphaInt=2.12,
    nInt=1,
    RInt={0.000668895639141},
    CInt={12391363.86},
    RWin=0.01642857143,
    RExtRem=0.1265217391)
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  EqAirTemp.EqAirTemp eqAirTemp(n=2,
    wfGround=0,
    wfWall={0.3043478260869566,0.6956521739130435},
    wfWin={0.5,0.5},
    withLongwave=true,
    aExt=0.7,
    alphaExtOut=20,
    alphaRad=5,
    alphaWinOut=20,
    aWin=0.03,
    eExt=0.9,
    TGround=285.15)
    annotation (Placement(transformation(extent={{-24,-14},{-4,6}})));
  Modelica.Blocks.Math.Add solRad[2]
    annotation (Placement(transformation(extent={{-38,6},{-28,16}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{8,-6},{20,6}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature1
    annotation (Placement(transformation(extent={{8,14},{20,26}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor  thermalConductorWin(R=
        0.003571428571)
    annotation (Placement(transformation(extent={{28,16},{38,26}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor  thermalConductorWall(R=
        0.00347826087)
    annotation (Placement(transformation(extent={{26,-4},{36,6}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow personsRad
    annotation (Placement(transformation(extent={{48,-42},{68,-22}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow personsConv
    annotation (Placement(transformation(extent={{48,-62},{68,-42}})));
  Modelica.Blocks.Sources.CombiTimeTable internalGains(
    table=[0,0,0,0; 3600,0,0,0; 7200,0,0,0; 10800,0,0,0; 14400,0,0,0; 18000,0,0,
        0; 21600,0,0,0; 25200,0,0,0; 25200,80,80,200; 28800,80,80,200; 32400,80,
        80,200; 36000,80,80,200; 39600,80,80,200; 43200,80,80,200; 46800,80,80,200;
        50400,80,80,200; 54000,80,80,200; 57600,80,80,200; 61200,80,80,200; 61200,
        0,0,0; 64800,0,0,0; 72000,0,0,0; 75600,0,0,0; 79200,0,0,0; 82800,0,0,0;
        86400,0,0,0],
    columns={2,3,4},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
  Modelica.Blocks.Sources.Constant const[2](each k=0)
    annotation (Placement(transformation(extent={{-20,14},{-14,20}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-100,-10},{-66,22}}),iconTransformation(extent=
            {{-176,-8},{-156,12}})));
  Modelica.Blocks.Sources.CombiTimeTable reference(
    tableOnFile=false,
    table=[3600,22; 7200,21.9; 10800,21.9; 14400,21.8; 18000,22; 21600,22.3; 25200,
        22.7; 28800,24.8; 32400,24.7; 36000,25.2; 39600,25.6; 43200,26.1; 46800,
        25.9; 50400,26.3; 54000,26.6; 57600,27.5; 61200,27.6; 64800,26; 68400,25.8;
        72000,25.6; 75600,25.6; 79200,25.5; 82800,25.5; 86400,25.5; 781200,37.6;
        784800,37.5; 788400,37.3; 792000,37.1; 795600,37.1; 799200,37.3; 802800,
        37.5; 806400,39.6; 810000,39.4; 813600,39.7; 817200,40; 820800,40.3; 824400,
        40; 828000,40.3; 831600,40.5; 835200,41.3; 838800,41.3; 842400,39.6; 846000,
        39.2; 849600,38.9; 853200,38.8; 856800,38.7; 860400,38.5; 864000,38.4; 5101200,
        40.9; 5104800,40.7; 5108400,40.5; 5112000,40.2; 5115600,40.3; 5119200,40.4;
        5122800,40.6; 5126400,42.6; 5130000,42.4; 5133600,42.7; 5137200,43; 5140800,
        43.3; 5144400,43; 5148000,43.2; 5151600,43.4; 5155200,44.2; 5158800,44.1;
        5162400,42.4; 5166000,42; 5169600,41.7; 5173200,41.6; 5176800,41.4; 5180400,
        41.2; 5184000,41.1],
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesConv
    annotation (Placement(transformation(extent={{48,-84},{68,-64}})));
  Modelica.Blocks.Sources.CombiTimeTable dryBulbTemp(
    table=[0,291.95,0,0; 3600,291.95,0,0; 3600,290.25,0,0; 7200,290.25,0,0;
        7200,289.65,0,0; 10800,289.65,0,0; 10800,289.25,0,0; 14400,289.25,0,0;
        14400,289.65,0,0; 18000,289.65,0,0; 18000,290.95,0,0; 21600,290.95,0,0;
        21600,293.45,0,0; 25200,293.45,0,0; 25200,295.95,0,0; 28800,295.95,0,0;
        28800,297.95,0,0; 32400,297.95,0,0; 32400,299.85,0,0; 36000,299.85,0,0;
        36000,301.25,0,0; 39600,301.25,0,0; 39600,302.15,0,0; 43200,302.15,0,0;
        43200,302.85,0,0; 46800,302.85,0,0; 46800,303.55,0,0; 50400,303.55,0,0;
        50400,304.05,0,0; 54000,304.05,0,0; 54000,304.15,0,0; 57600,304.15,0,0;
        57600,303.95,0,0; 61200,303.95,0,0; 61200,303.25,0,0; 64800,303.25,0,0;
        64800,302.05,0,0; 68400,302.05,0,0; 68400,300.15,0,0; 72000,300.15,0,0;
        72000,297.85,0,0; 75600,297.85,0,0; 75600,296.05,0,0; 79200,296.05,0,0;
        79200,295.05,0,0; 82800,295.05,0,0; 82800,294.05,0,0; 86400,294.05,0,0],
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-80,80},{-94,94}})));

  Modelica.Blocks.Sources.Constant infrared(each k=0)
    annotation (Placement(transformation(extent={{-86,42},{-92,48}})));
  Modelica.Blocks.Sources.CombiTimeTable tableSolRad(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    columns={2,3},
    table=[0,0,0; 3600,0,0; 10800,0,0; 14400,0,0; 14400,24,24; 18000,24,24;
        18000,58,58; 21600,58,58; 21600,91,91; 25200,91,91; 25200,203,124;
        28800,203,124; 28800,348,153; 32400,348,153; 32400,472,177; 36000,472,
        177; 36000,553,191; 39600,553,191; 39600,581,196; 43200,581,196; 43200,
        553,191; 46800,553,191; 46800,472,177; 50400,472,177; 50400,348,153;
        54000,348,153; 54000,203,124; 57600,203,124; 57600,91,91; 61200,91,91;
        61200,58,58; 64800,58,58; 64800,24,24; 68400,24,24; 68400,0,0; 72000,0,
        0; 82800,0,0; 86400,0,0])
    annotation (Placement(transformation(extent={{-80,20},{-94,34}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor indoorTemp
    annotation (Placement(transformation(extent={{96,-20},{88,-12}})));
  Modelica.Blocks.Sources.Constant TBlaSkyInput(each k=273.15)
    annotation (Placement(transformation(extent={{-68,76},{-74,82}})));
equation
  connect(eqAirTemp.TEqAirWindow, prescribedTemperature1.T) annotation (Line(
        points={{-4.2,-1.4},{0,-1.4},{0,20},{6.8,20}}, color={0,0,127}));
  connect(eqAirTemp.TEqAir, prescribedTemperature.T) annotation (Line(points={{
          -4.2,-9.6},{4,-9.6},{4,0},{6.8,0}}, color={0,0,127}));
  connect(TBlaSky.TBlaSky, eqAirTemp.TBlaSky) annotation (Line(points={{-45,-20},
          {-34,-20},{-34,-4.6},{-22,-4.6}}, color={0,0,127}));
  connect(prescribedTemperature1.port, thermalConductorWin.port_a)
    annotation (Line(points={{20,20},{28,20},{28,21}}, color={191,0,0}));
  connect(thermalConductorWin.port_b, thermalZoneTwoElements.window)
    annotation (Line(points={{38,21},{42,21},{42,19.8},{45,19.8}}, color={191,0,
          0}));
  connect(prescribedTemperature.port, thermalConductorWall.port_a)
    annotation (Line(points={{20,0},{26,0},{26,1}}, color={191,0,0}));
  connect(thermalConductorWall.port_b, thermalZoneTwoElements.extWall)
    annotation (Line(points={{36,1},{38,1},{38,2},{40,2},{40,12.4},{45,12.4}},
        color={191,0,0}));
  connect(corGDoublePane.solarRadWinTrans, aggWindow.u)
    annotation (Line(points={{25,64},{42.6,64}}, color={0,0,127}));
  connect(aggWindow.y, thermalZoneTwoElements.solRad) annotation (Line(points={
          {58.7,64},{66,64},{66,44},{26,44},{26,30.8},{45,30.8}}, color={0,0,
          127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-78,62},{-74,62},{-74,18},{-84,18},{-84,12},{-83,12},{-83,6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDewPoi, TBlaSky.TDewPoi) annotation (Line(
      points={{-83,6},{-82,6},{-82,-18},{-74,-18},{-74,-17},{-68,-17}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDryBul, TBlaSky.TDryBul) annotation (Line(
      points={{-83,6},{-83,-12},{-68,-12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDryBul, eqAirTemp.TDryBul) annotation (Line(
      points={{-83,6},{-83,-2},{-38,-2},{-38,-9.8},{-22,-9.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.radHorIR, TBlaSky.radHorIR) annotation (Line(
      points={{-83,6},{-82,6},{-82,-30},{-82,-28},{-68,-28}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.nOpa, TBlaSky.nOpa) annotation (Line(
      points={{-83,6},{-82,6},{-82,-22},{-82,-23},{-68,-23}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(internalGains.y[1], personsRad.Q_flow) annotation (Line(points={{22.8,
          -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
  connect(internalGains.y[2], personsConv.Q_flow)
    annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
  connect(internalGains.y[3], machinesConv.Q_flow) annotation (Line(points={{22.8,
          -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
  connect(const.y, eqAirTemp.sunblind) annotation (Line(points={{-13.7,17},{-12,
          17},{-12,8},{-14,8},{-14,4}}, color={0,0,127}));
  connect(HDifTil.HSkyDifTil, corGDoublePane.HSkyDifTil) annotation (Line(
        points={{-47,36},{-28,36},{-6,36},{-6,65.8},{6,65.8}}, color={0,0,127}));
  connect(HDirTil.H, corGDoublePane.HDirTil) annotation (Line(points={{-47,62},{
          -10,62},{-10,70},{6,70}}, color={0,0,127}));
  connect(HDirTil.H,solRad. u1) annotation (Line(points={{-47,62},{-42,62},{-42,
          14},{-39,14}}, color={0,0,127}));
  connect(HDirTil.inc, corGDoublePane.inc)
    annotation (Line(points={{-47,58},{6,58},{6,57.4}}, color={0,0,127}));
  connect(HDifTil.H,solRad. u2) annotation (Line(points={{-47,30},{-44,30},{-44,
          8},{-39,8}}, color={0,0,127}));
  connect(HDifTil.HGroDifTil, corGDoublePane.HGroDifTil) annotation (Line(
        points={{-47,24},{-4,24},{-4,61.6},{6,61.6}}, color={0,0,127}));
  connect(solRad.y, eqAirTemp.HSol) annotation (Line(points={{-27.5,11},{-26,11},
          {-26,0.4},{-22,0.4}}, color={0,0,127}));
  connect(weaDat.weaBus, HDifTil[1].weaBus) annotation (Line(
      points={{-78,62},{-74,62},{-74,30},{-68,30}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, HDifTil[2].weaBus) annotation (Line(
      points={{-78,62},{-74,62},{-74,30},{-68,30}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, HDirTil[1].weaBus) annotation (Line(
      points={{-78,62},{-73,62},{-68,62}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, HDirTil[2].weaBus) annotation (Line(
      points={{-78,62},{-73,62},{-68,62}},
      color={255,204,51},
      thickness=0.5));
  connect(dryBulbTemp.y[1], weaDat.TDryBul_in) annotation (Line(points={{-94.7,
          87},{-106,87},{-106,71},{-99,71}}, color={0,0,127}));
  connect(infrared.y, weaDat.HInfHor_in) annotation (Line(points={{-92.3,45},{
          -106,45},{-106,52.5},{-99,52.5}}, color={0,0,127}));
  connect(indoorTemp.port, thermalZoneTwoElements.intGainsConv)
    annotation (Line(points={{96,-16},{96,19.8},{91,19.8}}, color={191,0,0}));
  connect(TBlaSkyInput.y, weaDat.TBlaSky_in) annotation (Line(points={{-74.3,79},
          {-104,79},{-104,69},{-99,69}}, color={0,0,127}));
  connect(personsRad.port, thermalZoneTwoElements.intGainsRad) annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,26},{91,26}}, color={191,0,0}));
  connect(personsConv.port, indoorTemp.port) annotation (Line(points={{68,-52},
          {84,-52},{96,-52},{96,-16}}, color={191,0,0}));
  connect(machinesConv.port, indoorTemp.port)
    annotation (Line(points={{68,-74},{96,-74},{96,-16}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<p>For this example, the following boundary conditions are taken from Guideline VDI 6007:</p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">Dry bulb temperature</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Infrared horizontal radiation</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Global normal radiation</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Diffuse normal radiation</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Internal radiative gains from persons</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Internal convective gains from persons</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Internal convective gains from machines</span></li>
</ul>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">The guideline is also the source of the building physics, orientations, areas, set temperatures and reference values. As global and diffuse radiation are given in the guideline normal to the facades and are here used as normal to the sun, this example cannot be taken for validation. In addition, the calculation core is not configured to be exactly the VDI 6007 core. In this example, the windows are not merged with the exterior walls. The reference values are taken from test case 8. This case doesn&apos;t consider outdoor longwave radiation exchange but this example does. Furthermore, the test case considers sunblinds (closing at 100 w/m2) what is not included in this example. It&apos;s just to show a typical application.</span></p>
</html>"),
    experiment(StopTime=5.184e+006));
end VDI6007TestCase8;
