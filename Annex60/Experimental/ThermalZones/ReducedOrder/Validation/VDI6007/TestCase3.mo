within Annex60.Experimental.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase3 "VDI 6007 Test Case 3 model"

  ROM.ThermalZoneTwoElements thermalZoneTwoElements(
    VAir=52.5,
    alphaExt=2.7,
    alphaWin=2.7,
    gWin=1,
    nExt=1,
    alphaRad=5,
    nInt=1,
    AWin=0,
    AExt=10.5,
    ATransparent=0,
    ratioWinConRad=0,
    AInt=75.5,
    alphaInt=2.24,
    RWin=0.00000001,
    volAir(X_start={0,0}),
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
    table=[3600,22; 7200,22; 10800,22; 14400,22; 18000,22; 21600,22; 25200,30.2;
        28800,30.8; 32400,31.2; 36000,31.6; 39600,32; 43200,32.4; 46800,32.8;
        50400,33.2; 54000,33.6; 57600,34; 61200,34.3; 64800,34.7; 68400,26.9;
        72000,26.7; 75600,26.7; 79200,26.6; 82800,26.6; 86400,26.6; 781200,43.7;
        784800,43.5; 788400,43.4; 792000,43.2; 795600,43; 799200,42.9; 802800,
        50.9; 806400,51.3; 810000,51.6; 813600,51.8; 817200,52.1; 820800,52.3;
        824400,52.5; 828000,52.8; 831600,53; 835200,53.3; 838800,53.5; 842400,
        53.7; 846000,45.8; 849600,45.4; 853200,45.3; 856800,45.1; 860400,44.9;
        864000,44.7; 5101200,48.7; 5104800,48.5; 5108400,48.3; 5112000,48.1;
        5115600,47.9; 5119200,47.7; 5122800,55.7; 5126400,56; 5130000,56.3;
        5133600,56.5; 5137200,56.7; 5140800,56.9; 5144400,57.1; 5148000,57.3;
        5151600,57.5; 5155200,57.7; 5158800,57.9; 5162400,58.1; 5166000,50.1;
        5169600,49.8; 5173200,49.5; 5176800,49.3; 5180400,49.1; 5184000,48.9])
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesConv
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
  connect(internalGains.y[1], machinesConv.Q_flow) annotation (Line(points={{
          22.8,-52},{36,-52},{36,-74},{48,-74}}, color={0,0,127}));
  connect(machinesConv.port, thermalZoneTwoElements.intGainsConv) annotation (
      Line(points={{68,-74},{82,-74},{96,-74},{96,19.8},{91,19.8}}, color={191,
          0,0}));
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
end TestCase3;
