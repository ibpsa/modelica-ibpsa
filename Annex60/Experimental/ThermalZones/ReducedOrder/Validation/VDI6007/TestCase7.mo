within Annex60.Experimental.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase7 "VDI 6007 Test Case 7 model"

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
    RExt={0.00436791293674},
    RExtRem=0.03895919557,
    CExt={1600848.94},
    RInt={0.000595693407511},
    CInt={14836354.6282},
    T_start=295.15)
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
    annotation (Placement(transformation(extent={{6,-96},{22,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable reference(
    tableOnFile=false,
    columns={2},
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    table=[3600,0; 7200,0; 10800,0; 14400,0; 18000,0; 21600,0; 25200,-500;
        28800,-500; 32400,-500; 36000,-500; 39600,-500; 43200,-481; 46800,-426;
        50400,-374; 54000,-324; 57600,-276; 61200,-230; 64800,-186; 68400,500;
        72000,500; 75600,500; 79200,500; 82800,500; 86400,500; 781200,500;
        784800,500; 788400,500; 792000,500; 795600,500; 799200,500; 802800,142;
        806400,172; 810000,201; 813600,228; 817200,254; 820800,278; 824400,302;
        828000,324; 831600,345; 835200,366; 838800,385; 842400,404; 846000,500;
        849600,500; 853200,500; 856800,500; 860400,500; 864000,500; 5101200,500;
        5104800,500; 5108400,500; 5112000,500; 5115600,500; 5119200,500;
        5122800,149; 5126400,179; 5130000,207; 5133600,234; 5137200,259;
        5140800,284; 5144400,307; 5148000,329; 5151600,350; 5155200,371;
        5158800,390; 5162400,409; 5166000,500; 5169600,500; 5173200,500;
        5176800,500; 5180400,500; 5184000,500])
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesRad
    annotation (Placement(transformation(extent={{48,-98},{68,-78}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor indoorTemp
    annotation (Placement(transformation(extent={{96,-20},{88,-12}})));
  Modelica.Blocks.Sources.Constant alphaWall(k=25*10.5)
    "Outdoor coefficient of heat transfer for walls" annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-18})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{20,26},{30,36}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    annotation (Placement(transformation(extent={{-4,-24},{-16,-12}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature1
    annotation (Placement(transformation(extent={{-38,-24},{-26,-12}})));
  Modelica.Blocks.Sources.CombiTimeTable setTemp(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    table=[0,295.1; 3600,295.1; 7200,295.1; 10800,295.1; 14400,295.1; 18000,
        295.1; 21600,295.1; 25200,300.1; 28800,300.1; 32400,300.1; 36000,300.1;
        39600,300.1; 43200,300.1; 46800,300.1; 50400,300.1; 54000,300.1; 57600,
        300.1; 61200,300.1; 64800,300.1; 68400,295.1; 72000,295.1; 75600,295.1;
        79200,295.1; 82800,295.1; 86400,295.1])
    annotation (Placement(transformation(extent={{-92,-26},{-76,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow maxHeat
    annotation (Placement(transformation(extent={{-46,-56},{-26,-36}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={-54,2})));
  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-62,-46})));
  Modelica.Blocks.Sources.Constant const1(
                                         k=0)
    annotation (Placement(transformation(extent={{-94,-42},{-84,-32}})));
  Modelica.Blocks.Sources.Constant const2(k=500)
    annotation (Placement(transformation(extent={{-94,-60},{-84,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow maxCool
    annotation (Placement(transformation(extent={{-46,-92},{-26,-72}})));
  Modelica.Blocks.Logical.Switch switch3 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-62,-82})));
  Modelica.Blocks.Sources.Constant const3(
                                         k=0)
    annotation (Placement(transformation(extent={{-94,-78},{-84,-68}})));
  Modelica.Blocks.Sources.Constant const4(k=-500)
    annotation (Placement(transformation(extent={{-94,-96},{-84,-86}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=500)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-10,-54})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=-500)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={6,-54})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-85,-3},{-75,7}})));
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
          22.8,-88},{22.8,-88},{48,-88}}, color={0,0,127}));
  connect(machinesRad.port, thermalZoneTwoElements.intGainsRad) annotation (
      Line(points={{68,-88},{84,-88},{98,-88},{98,26},{91,26}}, color={191,0,0}));
  connect(thermalZoneTwoElements.intGainsConv, indoorTemp.port)
    annotation (Line(points={{91,19.8},{96,19.8},{96,-16}}, color={191,0,0}));
  connect(prescribedTemperature1.port, heatFlowSensor.port_b)
    annotation (Line(points={{-26,-18},{-21,-18},{-16,-18}}, color={191,0,0}));
  connect(switch1.y, prescribedTemperature1.T) annotation (Line(points={{-47.4,
          2},{-44,2},{-44,-18},{-39.2,-18}}, color={0,0,127}));
  connect(switch2.y, maxHeat.Q_flow) annotation (Line(points={{-55.4,-46},{-50,
          -46},{-46,-46}}, color={0,0,127}));
  connect(maxHeat.port, heatFlowSensor.port_b) annotation (Line(points={{-26,
          -46},{-20,-46},{-20,-18},{-16,-18}}, color={191,0,0}));
  connect(const1.y, switch2.u1) annotation (Line(points={{-83.5,-37},{-75.75,
          -37},{-75.75,-41.2},{-69.2,-41.2}}, color={0,0,127}));
  connect(const2.y, switch2.u3) annotation (Line(points={{-83.5,-55},{-76,-55},
          {-76,-50.8},{-69.2,-50.8}}, color={0,0,127}));
  connect(heatFlowSensor.port_a, indoorTemp.port) annotation (Line(points={{-4,
          -18},{-4,-18},{-4,-36},{96,-36},{96,-16}}, color={191,0,0}));
  connect(switch3.y, maxCool.Q_flow) annotation (Line(points={{-55.4,-82},{-50,
          -82},{-46,-82}}, color={0,0,127}));
  connect(maxCool.port, heatFlowSensor.port_b) annotation (Line(points={{-26,
          -82},{-20,-82},{-20,-18},{-16,-18}}, color={191,0,0}));
  connect(const3.y, switch3.u1) annotation (Line(points={{-83.5,-73},{-75.75,
          -73},{-75.75,-77.2},{-69.2,-77.2}}, color={0,0,127}));
  connect(const4.y, switch3.u3) annotation (Line(points={{-83.5,-91},{-76,-91},
          {-76,-86.8},{-69.2,-86.8}}, color={0,0,127}));
  connect(heatFlowSensor.Q_flow, lessThreshold.u)
    annotation (Line(points={{-10,-24},{-10,-46.8}}, color={0,0,127}));
  connect(lessThreshold.y, switch2.u2) annotation (Line(points={{-10,-60.6},{
          -10,-64},{-96,-64},{-96,-46},{-69.2,-46}}, color={255,0,255}));
  connect(heatFlowSensor.Q_flow, greaterThreshold.u) annotation (Line(points={{
          -10,-24},{-10,-24},{-10,-40},{-10,-42},{6,-42},{6,-46.8}}, color={0,0,
          127}));
  connect(greaterThreshold.y, switch3.u2) annotation (Line(points={{6,-60.6},{0,
          -60.6},{0,-100},{-96,-100},{-96,-82},{-69.2,-82}}, color={255,0,255}));
  connect(setTemp.y[1], switch1.u1) annotation (Line(points={{-75.2,-18},{-70,
          -18},{-70,-2.8},{-61.2,-2.8}}, color={0,0,127}));
  connect(indoorTemp.T, switch1.u3) annotation (Line(points={{88,-16},{44,-16},
          {44,-30},{0,-30},{0,12},{-66,12},{-66,6.8},{-61.2,6.8}}, color={0,0,
          127}));
  connect(and1.y, switch1.u2) annotation (Line(points={{-74.5,2},{-74.5,2},{
          -61.2,2}}, color={255,0,255}));
  connect(lessThreshold.y, and1.u1) annotation (Line(points={{-10,-60.6},{-10,
          -64},{-96,-64},{-96,2},{-86,2}}, color={255,0,255}));
  connect(greaterThreshold.y, and1.u2) annotation (Line(points={{6,-60.6},{0,
          -60.6},{0,-100},{-98,-100},{-98,-2},{-86,-2}}, color={255,0,255}));
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
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end TestCase7;
