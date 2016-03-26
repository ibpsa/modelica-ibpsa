within Annex60.Experimental.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase7 "VDI 6007 Test Case 7 model"
  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Air.SimpleAir "Medium model";
  parameter Real m_flow_nominal = 10 "nominal mass flow";

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
    table=[3600,0; 7200,0; 10800,0; 14400,0; 18000,0; 21600,0; 25200,500; 28800,
        500; 32400,500; 36000,500; 39600,500; 43200,481; 46800,426; 50400,374; 54000,
        324; 57600,276; 61200,230; 64800,186; 68400,-500; 72000,-500; 75600,-500;
        79200,-500; 82800,-500; 86400,-500; 781200,-500; 784800,-500; 788400,-500;
        792000,-500; 795600,-500; 799200,-500; 802800,-142; 806400,-172; 810000,
        -201; 813600,-228; 817200,-254; 820800,-278; 824400,-302; 828000,-324; 831600,
        -345; 835200,-366; 838800,-385; 842400,-404; 846000,-500; 849600,-500; 853200,
        -500; 856800,-500; 860400,-500; 864000,-500; 5101200,-500; 5104800,-500;
        5108400,-500; 5112000,-500; 5115600,-500; 5119200,-500; 5122800,-149; 5126400,
        -179; 5130000,-207; 5133600,-234; 5137200,-259; 5140800,-284; 5144400,-307;
        5148000,-329; 5151600,-350; 5155200,-371; 5158800,-390; 5162400,-409; 5166000,
        -500; 5169600,-500; 5173200,-500; 5176800,-500; 5180400,-500; 5184000,-500])
    annotation (Placement(transformation(extent={{76,72},{96,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow machinesRad
    annotation (Placement(transformation(extent={{48,-98},{68,-78}})));

  Modelica.Blocks.Sources.Constant alphaWall(k=25*10.5)
    "Outdoor coefficient of heat transfer for walls" annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={30,-18})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{20,26},{30,36}})));
  Fluid.Movers.FlowControlled_m_flow         fan(
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = Medium) "Fan"
    annotation (Placement(transformation(extent={{-74,-52},{-54,-32}})));
  Modelica.Blocks.Sources.Constant mFan_flow(k=m_flow_nominal)
    "Mass flow rate of the fan"
    annotation (Placement(transformation(extent={{-94,-30},{-74,-10}})));
  Fluid.Sensors.TemperatureTwoPort
                             THeaOut(
      m_flow_nominal=m_flow_nominal, redeclare package Medium = Medium)
    "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{16,-52},{36,-32}})));
  Fluid.HeatExchangers.HeaterCooler_T         hea(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_maxHeat=500,
    Q_flow_maxCool=-500,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = Medium) "Heater"
    annotation (Placement(transformation(extent={{-24,-52},{-4,-32}})));
  Fluid.Sources.FixedBoundary
                        bou(                                   nPorts=1,
      redeclare package Medium = Medium)
    "Fixed pressure boundary condition, required to set a reference pressure"
    annotation (Placement(transformation(extent={{-58,-98},{-78,-78}})));
  Modelica.Blocks.Sources.CombiTimeTable setTemp(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    table=[0,295.1; 3600,295.1; 7200,295.1; 10800,295.1; 14400,295.1; 18000,
        295.1; 21600,295.1; 25200,300.1; 28800,300.1; 32400,300.1; 36000,300.1;
        39600,300.1; 43200,300.1; 46800,300.1; 50400,300.1; 54000,300.1; 57600,
        300.1; 61200,300.1; 64800,300.1; 68400,295.1; 72000,295.1; 75600,295.1;
        79200,295.1; 82800,295.1; 86400,295.1])
    annotation (Placement(transformation(extent={{-58,-8},{-42,8}})));
  Fluid.HeatExchangers.HeaterCooler_T         hea1(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_maxHeat=500,
    Q_flow_maxCool=-500,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = Medium) "Heater"
    annotation (Placement(transformation(extent={{-4,-82},{-24,-62}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatCool
    annotation (Placement(transformation(extent={{46,-38},{66,-18}})));
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
      Line(points={{68,-88},{84,-88},{98,-88},{98,25},{91,25}}, color={191,0,0}));
  connect(mFan_flow.y,fan. m_flow_in) annotation (Line(
      points={{-73,-20},{-64.2,-20},{-64.2,-30}},
      color={0,0,127}));
  connect(fan.port_b,hea. port_a) annotation (Line(
      points={{-54,-42},{-24,-42}},
      color={0,127,255}));
  connect(hea.port_b,THeaOut. port_a) annotation (Line(
      points={{-4,-42},{16,-42}},
      color={0,127,255}));
  connect(fan.port_a, bou.ports[1]) annotation (Line(points={{-74,-42},{-96,-42},
          {-96,-88},{-78,-88}}, color={0,127,255}));

  connect(setTemp.y[1], hea.TSet) annotation (Line(points={{-41.2,0},{-32,0},{-32,
          -36},{-26,-36}}, color={0,0,127}));
  connect(THeaOut.port_b, hea1.port_a) annotation (Line(points={{36,-42},{38,-42},
          {38,-72},{2,-72},{-4,-72}}, color={0,127,255}));
  connect(fan.port_a, hea1.port_b) annotation (Line(points={{-74,-42},{-96,-42},
          {-96,-72},{-24,-72}}, color={0,127,255}));
  connect(hea.Q_flow, heatCool.Q_flow) annotation (Line(points={{-3,-36},{6,-36},
          {6,-28},{46,-28}}, color={0,0,127}));
  connect(thermalZoneTwoElements.TIndAir, hea1.TSet) annotation (Line(points={{91,31},
          {100,31},{100,-66},{-2,-66}},            color={0,0,127}));
  connect(heatCool.port, thermalZoneTwoElements.intGainsConv) annotation (Line(
        points={{66,-28},{82,-28},{96,-28},{96,19.8},{91,19.8}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<p>Test Case 7 of the VDI 6007 Part 1: Calculation of heat load excited with a given radiative heat source and a setpoint profile for room version S. Is similar with Test Case 6, but with a maximum heating/cooling power.</p>
<p>Boundary Condtions:</p>
<ul>
<li>constant outdoor air temperature 22 degC</li>
<li>no solar or short-wave radiation on the exterior wall</li>
<li>no solar or short-wave radiation through the windows</li>
<li>no long-wave radiation exchange between exterior wall, windows and ambient environment</li>
</ul>
<p>This test case is thought to test heat load calculation with maximum heating power.</p>
</html>", revisions="<html>
<ul>
<li>January 11, 2016,&nbsp; by Moritz Lauster:<br>Implemented. </li>
</ul>
</html>"),
__Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Experimental/ThermalZones/ReducedOrder/Validation/VDI6007/TestCase7.mos"
        "Simulate and plot"));
end TestCase7;
