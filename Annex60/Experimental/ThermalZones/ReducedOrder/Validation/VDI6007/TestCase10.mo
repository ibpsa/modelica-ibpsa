within Annex60.Experimental.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase10 "VDI 6007 Test Case 10 model"
  extends Modelica.Icons.Example;

  ROM.ThermalZoneTwoElements thermalZoneTwoElements(
    VAir=52.5,
    gWin=1,
    nExt=1,
    alphaRad=5,
    nInt=1,
    AWin=0,
    RWin=0.00000001,
    volAir(X_start={0,0}),
    ATransparent=7,
    ratioWinConRad=0.09,
    AExt=28,
    RExt={0.00171957698257},
    CExt={4338751.41},
    AInt=58,
    RInt={0.000779929073416},
    CInt={12334084.6919},
    alphaWin=2.7,
    RExtRem=0.01163854893,
    alphaExt=1.8666666666666667,
    T_start=290.75,
    alphaInt=2.3982758620689655)
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{8,-6},{20,6}})));
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
    table=[3600,17.6; 7200,17.6; 10800,17.5; 14400,17.5; 18000,17.6; 21600,17.8;
        25200,18; 28800,20; 32400,19.7; 36000,20; 39600,20.3; 43200,20.5; 46800,
        20.6; 50400,20.7; 54000,20.8; 57600,21.5; 61200,21.4; 64800,19.8; 68400,
        19.7; 72000,19.6; 75600,19.6; 79200,19.5; 82800,19.5; 86400,19.5;
        781200,24.7; 784800,24.6; 788400,24.5; 792000,24.4; 795600,24.4; 799200,
        24.5; 802800,24.6; 806400,26.6; 810000,26.2; 813600,26.4; 817200,26.6;
        820800,26.8; 824400,26.9; 828000,26.9; 831600,26.9; 835200,27.5; 838800,
        27.4; 842400,25.7; 846000,25.5; 849600,25.3; 853200,25.3; 856800,25.2;
        860400,25.1; 864000,25; 5101200,25.5; 5104800,25.3; 5108400,25.2;
        5112000,25.1; 5115600,25.1; 5119200,25.2; 5122800,25.3; 5126400,27.3;
        5130000,26.9; 5133600,27.1; 5137200,27.3; 5140800,27.4; 5144400,27.5;
        5148000,27.5; 5151600,27.5; 5155200,28.1; 5158800,28; 5162400,26.3;
        5166000,26.1; 5169600,26; 5173200,25.9; 5176800,25.8; 5180400,25.7;
        5184000,25.6])
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesConv
    annotation (Placement(transformation(extent={{48,-66},{68,-46}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow personsRad
    annotation (Placement(transformation(extent={{48,-102},{68,-82}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow personsConv
    annotation (Placement(transformation(extent={{48,-84},{68,-64}})));
  Modelica.Blocks.Sources.CombiTimeTable tableSolRadWindow(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=false,
    table=[0,0; 3600,0; 10800,0; 14400,0; 14400,17; 18000,17; 18000,38; 21600,
        38; 21600,59; 25200,59; 25200,98; 28800,98; 28800,186; 32400,186; 32400,
        287; 36000,287; 36000,359; 39600,359; 39600,385; 43200,385; 43200,359;
        46800,359; 46800,287; 50400,287; 50400,186; 54000,186; 54000,98; 57600,
        98; 57600,59; 61200,59; 61200,38; 64800,38; 64800,17; 68400,17; 68400,0;
        72000,0; 82800,0; 86400,0],
    columns={2})
    annotation (Placement(transformation(extent={{-84,66},{-70,80}})));
  Modelica.Blocks.Sources.Constant g_sunblind(k=0.15) annotation (Placement(
        transformation(
        extent={{-3,-3},{3,3}},
        rotation=-90,
        origin={-19,57})));
  Modelica.Blocks.Sources.Constant sunblind_open(k=1) annotation (Placement(
        transformation(
        extent={{-3,-3},{3,3}},
        rotation=-90,
        origin={-33,57})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold=100)
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-59,59})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-6,65},{4,75}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-26,38})));
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
    annotation (Placement(transformation(extent={{-90,-8},{-74,8}})));
  EqAirTemp.EqAirTempVDI
                      eqAirTemp(
    aExt=0.7,
    alphaExtOut=20,
    alphaRad=5,
    eExt=0.9,
    withLongwave=false,
    n=1,
    wfWall={0.04646093176283288},
    wfWin={0.32441554918476245},
    wfGround=0.6291235190524047,
    TGround=288.15)
    annotation (Placement(transformation(extent={{-24,-4},{-4,14}})));
  Modelica.Blocks.Sources.Constant const(k=273.15)
    annotation (Placement(transformation(extent={{-56,4},{-50,10}})));
  Modelica.Blocks.Sources.Constant HSol(k=0)
    annotation (Placement(transformation(extent={{-84,22},{-78,28}})));
  Modelica.Blocks.Sources.Constant sunblind(k=0) annotation (Placement(
        transformation(
        extent={{-3,-3},{3,3}},
        rotation=-90,
        origin={-15,23})));
  Modelica.Thermal.HeatTransfer.Components.Convection       thermalConductorWall
    annotation (Placement(transformation(extent={{34,5},{24,-5}})));
  Modelica.Blocks.Sources.Constant alphaWall(k=28*9.75)
    "Outdoor coefficient of heat transfer for walls" annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={28,-19})));
equation
  connect(personsRad.port, thermalZoneTwoElements.intGainsRad) annotation (Line(
        points={{68,-92},{68,-92},{98,-92},{98,25},{91,25}}, color={191,0,0}));
  connect(internalGains.y[1], personsRad.Q_flow) annotation (Line(points={{22.8,
          -52},{30,-52},{38,-52},{38,-92},{48,-92}}, color={0,0,127}));
  connect(internalGains.y[2], personsConv.Q_flow) annotation (Line(points={{
          22.8,-52},{38,-52},{38,-74},{48,-74}}, color={0,0,127}));
  connect(internalGains.y[3], machinesConv.Q_flow) annotation (Line(points={{
          22.8,-52},{38,-52},{38,-56},{48,-56}}, color={0,0,127}));
  connect(tableSolRadWindow.y[1],greaterThreshold1. u)
    annotation (Line(points={{-69.3,73},{-59,73},{-59,65}}, color={0,0,127}));
  connect(sunblind_open.y, switch1.u3) annotation (Line(points={{-33,53.7},{-33,
          48},{-30.8,48},{-30.8,45.2}}, color={0,0,127}));
  connect(g_sunblind.y, switch1.u1) annotation (Line(points={{-19,53.7},{-19,48},
          {-21.2,48},{-21.2,45.2}}, color={0,0,127}));
  connect(tableSolRadWindow.y[1], product1.u1) annotation (Line(points={{-69.3,
          73},{-37.65,73},{-7,73}}, color={0,0,127}));
  connect(greaterThreshold1.y, switch1.u2) annotation (Line(points={{-59,53.5},
          {-59,46},{-40,46},{-40,64},{-26,64},{-26,45.2}}, color={255,0,255}));
  connect(switch1.y, product1.u2) annotation (Line(points={{-26,31.4},{-26,28},
          {-10,28},{-10,67},{-7,67}}, color={0,0,127}));
  connect(product1.y, thermalZoneTwoElements.solRad) annotation (Line(points={{
          4.5,70},{20,70},{20,30.8},{45,30.8}}, color={0,0,127}));
  connect(outdoorTemp.y[1], eqAirTemp.TDryBul)
    annotation (Line(points={{-73.2,0},{-22,0},{-22,-0.22}}, color={0,0,127}));
  connect(const.y,eqAirTemp. TBlaSky) annotation (Line(points={{-49.7,7},{
          -28.85,7},{-28.85,4.46},{-22,4.46}},    color={0,0,127}));
  connect(eqAirTemp.TEqAir, prescribedTemperature.T) annotation (Line(points={{
          -4.2,-0.04},{0.9,-0.04},{0.9,0},{6.8,0}}, color={0,0,127}));
  connect(HSol.y, eqAirTemp.HSol[1]) annotation (Line(points={{-77.7,25},{-32,
          25},{-32,8.96},{-22,8.96}}, color={0,0,127}));
  connect(sunblind.y, eqAirTemp.sunblind[1]) annotation (Line(points={{-15,19.7},
          {-15,15.85},{-14,15.85},{-14,12.2}}, color={0,0,127}));
  connect(alphaWall.y,thermalConductorWall. Gc)
    annotation (Line(points={{28,-14.6},{29,-14.6},{29,-5}}, color={0,0,127}));
  connect(prescribedTemperature.port, thermalConductorWall.fluid)
    annotation (Line(points={{20,0},{24,0}}, color={191,0,0}));
  connect(thermalConductorWall.solid, thermalZoneTwoElements.extWall)
    annotation (Line(points={{34,0},{40,0},{40,12.4},{45,12.4}}, color={191,0,0}));
  connect(personsConv.port, thermalZoneTwoElements.intGainsConv) annotation (
      Line(points={{68,-74},{82,-74},{96,-74},{96,19.8},{91,19.8}}, color={191,
          0,0}));
  connect(machinesConv.port, thermalZoneTwoElements.intGainsConv) annotation (
      Line(points={{68,-56},{96,-56},{96,19.8},{91,19.8}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test Case 10 of the VDI6007 Part 1: </span><span style=\"font-family: Arial,sans-serif;\"><a name=\"result_box\">C</a></span><span style=\"font-family: MS Shell Dlg 2;\">alculation of indoor air temperature excited by a radiative and convective heat source for room version S. It is based on Test Case 5, but with a non-adiabatic floor plate to an adjacent room with a fixed temperature.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Boundary Condtions:</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">daily profile for outdoor air temperature in hourly steps </span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">no solar or short-wave radiation on the exterior wall </span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">daily profile for solar radiation through the windows in hourly steps</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">sunblind closes at &GT;100 W/m2</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">no long-wave radiation exchange between exterior wall, windows and ambient environment </span></li>
</ul>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">This test case is thought to test linking to ajdacent rooms with fixed temperature.</span></p>
</html>", revisions="<html>
<ul>
<li>January 11, 2016,&nbsp; by Moritz Lauster:<br>Implemented. </li>
</ul>
</html>"),
    experiment(
      StopTime=5.184e+006,
      Interval=3600,
      __Dymola_Algorithm="Lsodar"));
end TestCase10;
