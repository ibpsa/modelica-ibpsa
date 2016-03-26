within Annex60.Experimental.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase4 "VDI 6007 Test Case 4 model"
  extends Modelica.Icons.Example;

  ROM.ThermalZoneTwoElements thermalZoneTwoElements(
    VAir=52.5,
    alphaExt=2.7,
    alphaWin=2.7,
    gWin=1,
    nExt=1,
    nInt=1,
    AWin=0,
    AExt=10.5,
    ATransparent=0,
    ratioWinConRad=0,
    AInt=75.5,
    alphaInt=2.24,
    RWin=0.00000001,
    volAir(X_start={0,0}),
    alphaRad=5,
    RExt={0.00404935160802},
    RExtRem=0.03959436542,
    CExt={47861.76},
    T_start=295.15,
    RInt={0.00338564974804},
    CInt={7445364.89759})
    annotation (Placement(transformation(extent={{44,-2},{92,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
    prescribedTemperature(T=295.15)
    annotation (Placement(transformation(extent={{8,-6},{20,6}})));
  Modelica.Thermal.HeatTransfer.Components.Convection       thermalConductorWall
    annotation (Placement(transformation(extent={{36,6},{26,-4}})));
  Modelica.Blocks.Sources.CombiTimeTable internalGains(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[0,0; 3600,0; 7200,0; 10800,0; 14400,0; 18000,0; 21600,0; 21600,1000;
        25200,1000; 28800,1000; 32400,1000; 36000,1000; 39600,1000; 43200,1000;
        46800,1000; 50400,1000; 54000,1000; 57600,1000; 61200,1000; 64800,1000;
        64800,0; 68400,0; 72000,0; 75600,0; 79200,0; 82800,0; 86400,0],
    columns={2})
    annotation (Placement(transformation(extent={{6,-60},{22,-44}})));
  Modelica.Blocks.Sources.CombiTimeTable reference(
    tableOnFile=false,
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    table=[3600,22; 7200,22; 10800,22; 14400,22; 18000,22; 21600,22; 25200,25.1;
        28800,25.7; 32400,26.1; 36000,26.5; 39600,26.9; 43200,27.3; 46800,27.7;
        50400,28.1; 54000,28.5; 57600,28.9; 61200,29.3; 64800,29.7; 68400,26.9;
        72000,26.7; 75600,26.7; 79200,26.7; 82800,26.6; 86400,26.6; 781200,43.8;
        784800,43.6; 788400,43.5; 792000,43.3; 795600,43.1; 799200,43; 802800,
        45.9; 806400,46.3; 810000,46.6; 813600,46.8; 817200,47.1; 820800,47.3;
        824400,47.6; 828000,47.8; 831600,48.1; 835200,48.3; 838800,48.5; 842400,
        48.8; 846000,45.9; 849600,45.6; 853200,45.4; 856800,45.2; 860400,45;
        864000,44.8; 5101200,48.8; 5104800,48.6; 5108400,48.4; 5112000,48.2;
        5115600,48; 5119200,47.8; 5122800,50.7; 5126400,51.1; 5130000,51.3;
        5133600,51.5; 5137200,51.7; 5140800,51.9; 5144400,52.1; 5148000,52.4;
        5151600,52.6; 5155200,52.8; 5158800,53; 5162400,53.2; 5166000,50.2;
        5169600,49.9; 5173200,49.7; 5176800,49.5; 5180400,49.2; 5184000,49])
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesRad
    annotation (Placement(transformation(extent={{48,-84},{68,-64}})));

  Modelica.Blocks.Sources.Constant alphaWall(k=25*10.5)
    "Outdoor coefficient of heat transfer for walls" annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-18})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{20,26},{30,36}})));
equation
  connect(thermalConductorWall.fluid, prescribedTemperature.port)
    annotation (Line(points={{26,1},{24,1},{24,0},{20,0}}, color={191,0,0}));
  connect(thermalZoneTwoElements.extWall, thermalConductorWall.solid)
    annotation (Line(points={{45,12.4},{40,12.4},{40,1},{36,1}}, color={191,0,0}));
  connect(alphaWall.y, thermalConductorWall.Gc)
    annotation (Line(points={{30,-13.6},{31,-13.6},{31,-4}}, color={0,0,127}));
  connect(const.y, thermalZoneTwoElements.solRad) annotation (Line(points={{
          30.5,31},{37.25,31},{37.25,30.8},{45,30.8}}, color={0,0,127}));
  connect(internalGains.y[1], machinesRad.Q_flow) annotation (Line(points={{
          22.8,-52},{36,-52},{36,-74},{48,-74}}, color={0,0,127}));
  connect(machinesRad.port, thermalZoneTwoElements.intGainsRad) annotation (
      Line(points={{68,-74},{84,-74},{98,-74},{98,25},{91,25}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test Case 4 of the VDI6007 Part 1: </span><span style=\"font-family: Arial,sans-serif;\"><a name=\"result_box\">C</a></span><span style=\"font-family: MS Shell Dlg 2;\">alculation of indoor air temperature excited by a radiative heat source for room version L.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Boundary Condtions:</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">constant outdoor air temperature 22 degC </span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">no solar or short-wave radiation on the exterior wall </span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">no solar or short-wave radiation through the windows </span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">no long-wave radiation exchange between exterior wall, windows and ambient environment </span></li>
</ul>
<p><span style=\"font-family: MS Shell Dlg 2;\">This test case is thought to test basic functionalities.</span></p>
</html>", revisions="<html>
<ul>
<li>January 11, 2016,&nbsp; by Moritz Lauster:<br>Implemented. </li>
</ul>
</html>"),
    experiment(
      StopTime=5.184e+006,
      Interval=3600,
      __Dymola_Algorithm="Lsodar"));
end TestCase4;
