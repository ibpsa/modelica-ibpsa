within Annex60.Experimental.ThermalZones.ReducedOrder.Validation;
model VDI6007TestCase8 "Illustrates the use of ThermalZoneTwoElements"

  Modelica.Blocks.Math.Sum
            aggWindow(nin=2, k={0.5,0.5})
    annotation (Placement(transformation(extent={{44,57},{58,71}})));
  ROM.ThermalZoneTwoElements thermalZoneTwoElements(
    VAir=52.5,
    alphaExt=2.7,
    ATransparent=14,
    alphaWin=2.7,
    gWin=1,
    ratioWinConRad=0.09,
    nExt=1,
    CExt={5259932.23},
    alphaRad=5,
    AInt=60.5,
    alphaInt=2.12,
    nInt=1,
    RInt={0.000668895639141},
    CInt={12391363.86},
    RWin=0.01642857143,
    AWin=0,
    AExt=25.5,
    RExt={0.0017362530106},
    RExtRem=0.01843137255)
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  EqAirTemp.EqAirTempVDI
                      eqAirTemp(n=2,
    wfGround=0,
    aExt=0.7,
    alphaExtOut=20,
    alphaRad=5,
    eExt=0.9,
    withLongwave=false,
    wfWall={0.4047663456281575,0.4047663456281575},
    wfWin={0.05796831135677373,0.13249899738691134},
    TGround=285.15)
    annotation (Placement(transformation(extent={{-24,-14},{-4,6}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{8,-6},{20,6}})));
  Modelica.Thermal.HeatTransfer.Components.Convection       thermalConductorWall
    annotation (Placement(transformation(extent={{36,6},{26,-4}})));
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
  Modelica.Blocks.Sources.Constant const(k=273.15)
    annotation (Placement(transformation(extent={{-52,-8},{-46,-2}})));
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
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[0,291.95; 3600,291.95; 3600,290.25; 7200,290.25; 7200,289.65; 10800,
        289.65; 10800,289.25; 14400,289.25; 14400,289.65; 18000,289.65; 18000,
        290.95; 21600,290.95; 21600,293.45; 25200,293.45; 25200,295.95; 28800,
        295.95; 28800,297.95; 32400,297.95; 32400,299.85; 36000,299.85; 36000,
        301.25; 39600,301.25; 39600,302.15; 43200,302.15; 43200,302.85; 46800,
        302.85; 46800,303.55; 50400,303.55; 50400,304.05; 54000,304.05; 54000,
        304.15; 57600,304.15; 57600,303.95; 61200,303.95; 61200,303.25; 64800,
        303.25; 64800,302.05; 68400,302.05; 68400,300.15; 72000,300.15; 72000,
        297.85; 75600,297.85; 75600,296.05; 79200,296.05; 79200,295.05; 82800,
        295.05; 82800,294.05; 86400,294.05])
    annotation (Placement(transformation(extent={{-90,-20},{-76,-6}})));

  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor indoorTemp
    annotation (Placement(transformation(extent={{96,-20},{88,-12}})));
  Modelica.Blocks.Sources.Constant alphaWall(k=25*25.5)
    "Outdoor coefficient of heat transfer for walls" annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-18})));
  Modelica.Blocks.Sources.CombiTimeTable tableSolRadWall(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    columns={2,3},
    table=[0,0,0; 3600,0,0; 10800,0,0; 14400,0,0; 14400,24,23; 18000,24,23; 18000,
        58,53; 21600,58,53; 21600,91,77; 25200,91,77; 25200,203,97; 28800,203,97;
        28800,348,114; 32400,348,114; 32400,472,131; 36000,472,131; 36000,553,144;
        39600,553,144; 39600,581,159; 43200,581,159; 43200,553,372; 46800,553,372;
        46800,472,557; 50400,472,557; 50400,348,685; 54000,348,685; 54000,203,733;
        57600,203,733; 57600,91,666; 61200,91,666; 61200,58,474; 64800,58,474; 64800,
        24,177; 68400,24,177; 68400,0,0; 72000,0,0; 82800,0,0; 86400,0,0])
    annotation (Placement(transformation(extent={{-90,0},{-76,14}})));
  Modelica.Blocks.Sources.CombiTimeTable tableSolRadWindow(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    columns={2,3},
    table=[0,0,0; 3600,0,0; 10800,0,0; 14400,0,0; 14400,17,17; 18000,17,17; 18000,
        38,36; 21600,38,36; 21600,59,51; 25200,59,51; 25200,98,64; 28800,98,64;
        28800,186,74; 32400,186,74; 32400,287,84; 36000,287,84; 36000,359,92; 39600,
        359,92; 39600,385,100; 43200,385,100; 43200,359,180; 46800,359,180; 46800,
        287,344; 50400,287,344; 50400,186,475; 54000,186,475; 54000,98,528; 57600,
        98,528; 57600,59,492; 61200,59,492; 61200,38,359; 64800,38,359; 64800,17,
        147; 68400,17,147; 68400,0,0; 72000,0,0; 82800,0,0; 86400,0,0])
    annotation (Placement(transformation(extent={{-84,56},{-70,70}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-14,28})));
  Modelica.Blocks.Sources.Constant g_sunblind(k=0.15) annotation (Placement(
        transformation(
        extent={{-3,-3},{3,3}},
        rotation=-90,
        origin={-1,47})));
  Modelica.Blocks.Sources.Constant sunblind_open(k=1) annotation (Placement(
        transformation(
        extent={{-3,-3},{3,3}},
        rotation=-90,
        origin={-23,47})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold=100)
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-59,49})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2(threshold=100)
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-45,49})));
  Modelica.Blocks.Logical.Or or1 annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-53,29})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-6,74},{4,84}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-6,56},{4,66}})));
equation
  connect(eqAirTemp.TEqAir, prescribedTemperature.T) annotation (Line(points={{
          -4.2,-9.6},{4,-9.6},{4,0},{6.8,0}}, color={0,0,127}));
  connect(internalGains.y[1], personsRad.Q_flow) annotation (Line(points={{22.8,
          -52},{28,-52},{28,-32},{48,-32}}, color={0,0,127}));
  connect(internalGains.y[2], personsConv.Q_flow)
    annotation (Line(points={{22.8,-52},{36,-52},{48,-52}}, color={0,0,127}));
  connect(internalGains.y[3], machinesConv.Q_flow) annotation (Line(points={{22.8,
          -52},{28,-52},{28,-74},{48,-74}}, color={0,0,127}));
  connect(indoorTemp.port, thermalZoneTwoElements.intGainsConv)
    annotation (Line(points={{96,-16},{96,19.8},{91,19.8}}, color={191,0,0}));
  connect(personsRad.port, thermalZoneTwoElements.intGainsRad) annotation (Line(
        points={{68,-32},{84,-32},{100,-32},{100,26},{91,26}}, color={191,0,0}));
  connect(personsConv.port, indoorTemp.port) annotation (Line(points={{68,-52},
          {84,-52},{96,-52},{96,-16}}, color={191,0,0}));
  connect(machinesConv.port, indoorTemp.port)
    annotation (Line(points={{68,-74},{96,-74},{96,-16}}, color={191,0,0}));
  connect(thermalConductorWall.fluid, prescribedTemperature.port)
    annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
  connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
    annotation (Line(points={{45,12.4},{40,12.4},{40,1},{36,1}}, color={191,0,0}));
  connect(alphaWall.y, thermalConductorWall.Gc)
    annotation (Line(points={{30,-13.6},{31,-13.6},{31,-4}}, color={0,0,127}));
  connect(thermalZoneTwoElements.solRad, aggWindow.y) annotation (Line(points={
          {45,30.8},{38,30.8},{38,48},{64,48},{64,64},{58.7,64}}, color={0,0,
          127}));
  connect(dryBulbTemp.y[1], eqAirTemp.TDryBul) annotation (Line(points={{-75.3,
          -13},{-28,-13},{-28,-9.8},{-22,-9.8}}, color={0,0,127}));
  connect(tableSolRadWall.y, eqAirTemp.HSol) annotation (Line(points={{-75.3,7},
          {-34,7},{-34,0.4},{-22,0.4}}, color={0,0,127}));
  connect(const.y, eqAirTemp.TBlaSky) annotation (Line(points={{-45.7,-5},{-33.85,
          -5},{-33.85,-4.6},{-22,-4.6}}, color={0,0,127}));
  connect(switch1.y, eqAirTemp.sunblind[1])
    annotation (Line(points={{-14,21.4},{-14,5}}, color={0,0,127}));
  connect(switch1.y, eqAirTemp.sunblind[2])
    annotation (Line(points={{-14,21.4},{-14,3}}, color={0,0,127}));
  connect(g_sunblind.y, switch1.u1) annotation (Line(points={{-1,43.7},{-1,40},
          {-9.2,40},{-9.2,35.2}}, color={0,0,127}));
  connect(sunblind_open.y, switch1.u3) annotation (Line(points={{-23,43.7},{-23,
          40},{-18.8,40},{-18.8,35.2}}, color={0,0,127}));
  connect(tableSolRadWindow.y[1], greaterThreshold1.u)
    annotation (Line(points={{-69.3,63},{-59,63},{-59,55}}, color={0,0,127}));
  connect(tableSolRadWindow.y[2], greaterThreshold2.u)
    annotation (Line(points={{-69.3,63},{-45,63},{-45,55}}, color={0,0,127}));
  connect(greaterThreshold1.y, or1.u2) annotation (Line(points={{-59,43.5},{-59,
          39.75},{-57,39.75},{-57,35}}, color={255,0,255}));
  connect(greaterThreshold2.y, or1.u1) annotation (Line(points={{-45,43.5},{-53,
          43.5},{-53,35}}, color={255,0,255}));
  connect(or1.y, switch1.u2) annotation (Line(points={{-53,23.5},{-53,20},{-32,
          20},{-32,56},{-14,56},{-14,35.2}}, color={255,0,255}));
  connect(tableSolRadWindow.y[1], product.u1) annotation (Line(points={{-69.3,
          63},{-18,63},{-18,82},{-7,82}}, color={0,0,127}));
  connect(switch1.y, product.u2) annotation (Line(points={{-14,21.4},{-14,21.4},
          {-14,14},{-14,16},{12,16},{12,72},{-14,72},{-14,76},{-7,76}}, color={
          0,0,127}));
  connect(tableSolRadWindow.y[2], product1.u1)
    annotation (Line(points={{-69.3,63},{-7,63},{-7,64}}, color={0,0,127}));
  connect(switch1.y, product1.u2) annotation (Line(points={{-14,21.4},{-14,16},
          {12,16},{12,54},{-12,54},{-12,58},{-7,58}}, color={0,0,127}));
  connect(product.y, aggWindow.u[1]) annotation (Line(points={{4.5,79},{22,79},
          {22,63.3},{42.6,63.3}}, color={0,0,127}));
  connect(product1.y, aggWindow.u[2]) annotation (Line(points={{4.5,61},{23.25,
          61},{23.25,64.7},{42.6,64.7}}, color={0,0,127}));
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
    experiment(
      StopTime=5.184e+006,
      Interval=3600,
      __Dymola_Algorithm="Lsodar"));
end VDI6007TestCase8;
