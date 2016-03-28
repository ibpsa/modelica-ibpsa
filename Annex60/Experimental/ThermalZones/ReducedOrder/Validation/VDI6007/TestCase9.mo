within Annex60.Experimental.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase9 "VDI 6007 Test Case 9 model"
  extends Modelica.Icons.Example;

  ROM.ThermalZoneTwoElements thermalZoneTwoElements(
    alphaExt=2.7,
    alphaWin=2.7,
    gWin=1,
    nExt=1,
    alphaRad=5,
    nInt=1,
    AWin=0,
    RWin=0.00000001,
    volAir(X_start={0,0}),
    ratioWinConRad=0.09,
    RExt={0.0017362530106},
    CExt={5259932.23},
    AInt=60.5,
    alphaInt=2.12,
    RInt={0.000668895639141},
    CInt={12391363.8631},
    AExt=25.5,
    RExtRem=0.01913729904,
    ATransparent=14,
    VAir=52.5,
    T_start=295.15)
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  Modelica.Thermal.HeatTransfer.Components.Convection thermalConductorWall
    annotation (Placement(transformation(extent={{36,6},{26,-4}})));
  Modelica.Blocks.Sources.CombiTimeTable internalGains(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[0,0,0,0; 3600,0,0,0; 7200,0,0,0; 10800,0,0,0; 14400,0,0,0; 18000,0,0,
        0; 21600,0,0,0; 25200,0,0,0; 25200,80,80,200; 28800,80,80,200; 32400,80,
        80,200; 36000,80,80,200; 39600,80,80,200; 43200,80,80,200; 46800,80,80,
        200; 50400,80,80,200; 54000,80,80,200; 57600,80,80,200; 61200,80,80,200;
        61200,0,0,0; 64800,0,0,0; 72000,0,0,0; 75600,0,0,0; 79200,0,0,0; 82800,
        0,0,0; 86400,0,0,0],
    columns={2,3,4})
    annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
  Modelica.Blocks.Sources.CombiTimeTable reference(
    tableOnFile=false,
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    table=[3600,22; 7200,21.9; 10800,21.9; 14400,21.8; 18000,22; 21600,22.3;
        25200,22.7; 28800,24.8; 32400,24.7; 36000,25.2; 39600,25.6; 43200,26.1;
        46800,25.9; 50400,26.3; 54000,26.6; 57600,27.5; 61200,27.6; 64800,26;
        68400,25.8; 72000,25.6; 75600,25.6; 79200,25.5; 82800,25.5; 86400,25.5;
        781200,37.6; 784800,37.4; 788400,37.3; 792000,37.1; 795600,37.1; 799200,
        37.3; 802800,37.5; 806400,39.6; 810000,39.4; 813600,39.7; 817200,40;
        820800,40.3; 824400,40; 828000,40.3; 831600,40.5; 835200,41.3; 838800,
        41.3; 842400,39.6; 846000,39.2; 849600,38.9; 853200,38.8; 856800,38.7;
        860400,38.5; 864000,38.4; 5101200,40.8; 5104800,40.6; 5108400,40.4;
        5112000,40.2; 5115600,40.2; 5119200,40.4; 5122800,40.5; 5126400,42.6;
        5130000,42.3; 5133600,42.6; 5137200,42.9; 5140800,43.2; 5144400,42.9;
        5148000,43.2; 5151600,43.4; 5155200,44.1; 5158800,44.1; 5162400,42.3;
        5166000,42; 5169600,41.6; 5173200,41.5; 5176800,41.3; 5180400,41.2;
        5184000,41])
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesConv
    annotation (Placement(transformation(extent={{48,-66},{68,-46}})));

  Modelica.Blocks.Sources.Constant alphaWall(k=25*25.5)
    "Outdoor coefficient of heat transfer for walls" annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-18})));
  Modelica.Blocks.Sources.CombiTimeTable outdoorTemp(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
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
    annotation (Placement(transformation(extent={{-92,-32},{-78,-18}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow personsRad
    annotation (Placement(transformation(extent={{48,-102},{68,-82}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow personsConv
    annotation (Placement(transformation(extent={{48,-84},{68,-64}})));
  Modelica.Blocks.Sources.CombiTimeTable tableSolRadWindow(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=[0,0,0; 3600,0,0; 10800,0,0; 14400,0,0; 14400,17,17; 18000,17,17;
        18000,38,36; 21600,38,36; 21600,59,51; 25200,59,51; 25200,98,64; 28800,
        98,64; 28800,186,74; 32400,186,74; 32400,287,84; 36000,287,84; 36000,
        359,92; 39600,359,92; 39600,385,100; 43200,385,100; 43200,359,180;
        46800,359,180; 46800,287,344; 50400,287,344; 50400,186,475; 54000,186,
        475; 54000,98,528; 57600,98,528; 57600,59,492; 61200,59,492; 61200,38,
        359; 64800,38,359; 64800,17,147; 68400,17,147; 68400,0,0; 72000,0,0;
        82800,0,0; 86400,0,0],
    columns={2,3})
    annotation (Placement(transformation(extent={{-92,66},{-78,80}})));
  Modelica.Blocks.Sources.Constant g_sunblind(k=0.15) annotation (Placement(
        transformation(
        extent={{-3,-3},{3,3}},
        rotation=-90,
        origin={-45,45})));
  Modelica.Blocks.Sources.Constant sunblind_open(k=1) annotation (Placement(
        transformation(
        extent={{-3,-3},{3,3}},
        rotation=-90,
        origin={-61,43})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold=100)
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-61,59})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-6,65},{4,75}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-54,30})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2(threshold=100)
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-25,59})));
  Modelica.Blocks.Math.Sum
            aggWindow(nin=2, k={0.5,0.5})
    annotation (Placement(transformation(extent={{30,63},{44,77}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-6,84},{4,94}})));
  EquivalentAirTemperature.EqAirTempVDI eqAirTemp(
    n=2,
    wfGround=0,
    aExt=0.7,
    alphaExtOut=20,
    alphaRad=5,
    eExt=0.9,
    wfWall={0.05796831135677373,0.13249899738691134},
    wfWin={0.4047663456281575,0.4047663456281575},
    withLongwave=true,
    TGround=285.15)
    annotation (Placement(transformation(extent={{-26,-16},{-6,2}})));
  Modelica.Blocks.Math.Add add(k1=-1) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-58,16})));
  Modelica.Blocks.Sources.Constant const1(k=1)
    annotation (Placement(transformation(extent={{-70,22},{-64,28}})));
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
    annotation (Placement(transformation(extent={{-92,6},{-78,20}})));
  Modelica.Blocks.Sources.Constant g_sunblind1(
                                              k=0.15) annotation (Placement(
        transformation(
        extent={{-3,-3},{3,3}},
        rotation=-90,
        origin={-11,47})));
  Modelica.Blocks.Sources.Constant sunblind_open1(
                                                 k=1) annotation (Placement(
        transformation(
        extent={{-3,-3},{3,3}},
        rotation=-90,
        origin={-27,45})));
  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-20,32})));
  Modelica.Blocks.Math.Add add1(k1=-1) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=-90,
        origin={-24,18})));
  Modelica.Blocks.Sources.Constant const2(k=1)
    annotation (Placement(transformation(extent={{-36,24},{-30,30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{4,-10},{16,2}})));
  Modelica.Blocks.Sources.CombiTimeTable HSky(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    table=[0,362.5; 0.36,362.5; 3600,364; 7200,364; 7200,364.5; 10800,364.5;
        10800,364; 14400,364; 14400,380.5; 18000,380.5; 18000,390.5; 21600,
        390.5; 21600,400.5; 25200,400.5; 25200,414; 28800,414; 28800,427.5;
        32400,427.5; 32400,439; 36000,439; 36000,448.5; 39600,448.5; 39600,457;
        43200,457; 43200,459.5; 46800,459.5; 46800,460; 50400,460; 50400,457.5;
        54000,457.5; 54000,452.5; 57600,452.5; 57600,445; 61200,445; 61200,
        438.5; 64800,438.5; 64800,437; 68400,437; 68400,420; 72000,420; 72000,
        412.5; 75600,412.5; 75600,405; 79200,405; 79200,397.5; 82800,397.5;
        82800,390; 86400,390])
    annotation (Placement(transformation(extent={{-92,-12},{-78,2}})));
  Modelica.Blocks.Math.Sqrt sqrt
    annotation (Placement(transformation(extent={{-74,-8},{-68,-2}})));
  Modelica.Blocks.Math.Sqrt sqrt1
    annotation (Placement(transformation(extent={{-64,-8},{-58,-2}})));
  Modelica.Blocks.Math.Gain gain(k=65.99081593)
    annotation (Placement(transformation(extent={{-52,-10},{-46,-4}})));
equation
  connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
    annotation (Line(points={{45,12.4},{40,12.4},{40,1},{36,1}}, color={191,0,0}));
  connect(alphaWall.y, thermalConductorWall.Gc)
    annotation (Line(points={{30,-13.6},{31,-13.6},{31,-4}}, color={0,0,127}));
  connect(personsRad.port, thermalZoneTwoElements.intGainsRad) annotation (Line(
        points={{68,-92},{68,-92},{98,-92},{98,25},{91,25}}, color={191,0,0}));
  connect(internalGains.y[1], personsRad.Q_flow) annotation (Line(points={{22.8,
          -52},{30,-52},{38,-52},{38,-92},{48,-92}}, color={0,0,127}));
  connect(internalGains.y[2], personsConv.Q_flow) annotation (Line(points={{
          22.8,-52},{38,-52},{38,-74},{48,-74}}, color={0,0,127}));
  connect(internalGains.y[3], machinesConv.Q_flow) annotation (Line(points={{
          22.8,-52},{38,-52},{38,-56},{48,-56}}, color={0,0,127}));
  connect(tableSolRadWindow.y[1],greaterThreshold1. u)
    annotation (Line(points={{-77.3,73},{-61,73},{-61,65}}, color={0,0,127}));
  connect(sunblind_open.y, switch1.u3) annotation (Line(points={{-61,39.7},{-61,
          38},{-57.2,38},{-57.2,34.8}}, color={0,0,127}));
  connect(g_sunblind.y, switch1.u1) annotation (Line(points={{-45,41.7},{-45,38},
          {-50.8,38},{-50.8,34.8}}, color={0,0,127}));
  connect(tableSolRadWindow.y[1], product1.u1) annotation (Line(points={{-77.3,
          73},{-77.3,73},{-7,73}},  color={0,0,127}));
  connect(tableSolRadWindow.y[2], greaterThreshold2.u)
    annotation (Line(points={{-77.3,73},{-25,73},{-25,65}}, color={0,0,127}));
  connect(tableSolRadWindow.y[2], product.u1) annotation (Line(points={{-77.3,
          73},{-16,73},{-16,92},{-7,92}}, color={0,0,127}));
  connect(aggWindow.y, thermalZoneTwoElements.solRad) annotation (Line(points={
          {44.7,70},{48,70},{48,40},{32,40},{32,30.8},{45,30.8}}, color={0,0,
          127}));
  connect(const1.y, add.u2) annotation (Line(points={{-63.7,25},{-60.4,25},{
          -60.4,20.8}}, color={0,0,127}));
  connect(tableSolRadWall.y, eqAirTemp.HSol) annotation (Line(points={{-77.3,13},
          {-68,13},{-68,2},{-46,2},{-46,-3.04},{-25,-3.04}}, color={0,0,127}));
  connect(switch1.y, add.u1) annotation (Line(points={{-54,25.6},{-54,24},{-54,
          20.8},{-55.6,20.8}}, color={0,0,127}));
  connect(greaterThreshold1.y, switch1.u2) annotation (Line(points={{-61,53.5},
          {-61,50},{-54,50},{-54,34.8}}, color={255,0,255}));
  connect(sunblind_open1.y, switch2.u3) annotation (Line(points={{-27,41.7},{
          -27,40},{-23.2,40},{-23.2,36.8}}, color={0,0,127}));
  connect(g_sunblind1.y, switch2.u1) annotation (Line(points={{-11,43.7},{-11,
          40},{-16.8,40},{-16.8,36.8}}, color={0,0,127}));
  connect(const2.y, add1.u2) annotation (Line(points={{-29.7,27},{-26.4,27},{
          -26.4,22.8}}, color={0,0,127}));
  connect(switch2.y, add1.u1) annotation (Line(points={{-20,27.6},{-20,26},{-20,
          22.8},{-21.6,22.8}}, color={0,0,127}));
  connect(greaterThreshold2.y, switch2.u2) annotation (Line(points={{-25,53.5},
          {-25,52},{-20,52},{-20,36.8}}, color={255,0,255}));
  connect(switch2.y, product.u2) annotation (Line(points={{-20,27.6},{-20,27.6},
          {-20,24},{-20,26},{-2,26},{-2,58},{-12,58},{-12,86},{-7,86}}, color={
          0,0,127}));
  connect(switch1.y, product1.u2) annotation (Line(points={{-54,25.6},{-54,22},
          {-38,22},{-38,10},{2,10},{2,62},{-10,62},{-10,67},{-7,67}}, color={0,
          0,127}));
  connect(product1.y, aggWindow.u[1]) annotation (Line(points={{4.5,70},{28.6,
          70},{28.6,69.3}}, color={0,0,127}));
  connect(product.y, aggWindow.u[2]) annotation (Line(points={{4.5,89},{16.25,
          89},{16.25,70.7},{28.6,70.7}}, color={0,0,127}));
  connect(eqAirTemp.TEqAir, prescribedTemperature.T) annotation (Line(points={{
          -6.2,-12.04},{-2,-12.04},{-2,-4},{2.8,-4}}, color={0,0,127}));
  connect(prescribedTemperature.port, thermalConductorWall.fluid)
    annotation (Line(points={{16,-4},{22,-4},{22,1},{26,1}}, color={191,0,0}));
  connect(add.y, eqAirTemp.sunblind[1]) annotation (Line(points={{-58,11.6},{-58,
          6},{-16,6},{-16,2}},       color={0,0,127}));
  connect(add1.y, eqAirTemp.sunblind[2]) annotation (Line(points={{-24,13.6},{-24,
          13.6},{-24,8},{-16,8},{-16,0.2}},      color={0,0,127}));
  connect(outdoorTemp.y[1], eqAirTemp.TDryBul) annotation (Line(points={{-77.3,-25},
          {-46,-25},{-46,-12.22},{-25,-12.22}},      color={0,0,127}));
  connect(HSky.y[1], sqrt.u)
    annotation (Line(points={{-77.3,-5},{-74.6,-5}}, color={0,0,127}));
  connect(sqrt.y, sqrt1.u)
    annotation (Line(points={{-67.7,-5},{-64.6,-5}}, color={0,0,127}));
  connect(sqrt1.y, gain.u) annotation (Line(points={{-57.7,-5},{-56,-5},{-56,-7},
          {-52.6,-7}}, color={0,0,127}));
  connect(gain.y, eqAirTemp.TBlaSky) annotation (Line(points={{-45.7,-7},{-33.85,
          -7},{-33.85,-7.54},{-25,-7.54}},        color={0,0,127}));
  connect(personsConv.port, thermalZoneTwoElements.intGainsConv) annotation (
      Line(points={{68,-74},{82,-74},{96,-74},{96,19.8},{91,19.8}}, color={191,
          0,0}));
  connect(machinesConv.port, thermalZoneTwoElements.intGainsConv) annotation (
      Line(points={{68,-56},{96,-56},{96,19.8},{91,19.8}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<p>Test Case 9 of the VDI 6007 Part 1: Calculation of indoor air temperature 
excited by a radiative and convective heat source for room version S with two 
exterior walls. It is based on Test Case 8.</p>
<p>Boundary Condtions:</p>
<ul>
<li>daily profile for outdoor air temperature in hourly steps</li>
<li>daily profile for solar radiation on the exterior wall</li>
<li>daily profile for solar radiation through the windows in hourly steps</li>
<li>sunblind closes at &GT;100 W/m2</li>
<li>long-wave radiation exchange between exterior wall, windows and ambient 
environment</li>
</ul>
<p>This test case is thought to test reaction of indoor air temperature at mixed 
internal gains and outdoor impacts including solar radiation and long-wave 
radiation on exterior walls.</p>
</html>", revisions="<html>
<ul>
<li>January 11, 2016,&nbsp; by Moritz Lauster:<br>Implemented. </li>
</ul>
</html>"),
__Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Experimental/ThermalZones/ReducedOrder/Validation/VDI6007/TestCase9.mos"
        "Simulate and plot"));
end TestCase9;
