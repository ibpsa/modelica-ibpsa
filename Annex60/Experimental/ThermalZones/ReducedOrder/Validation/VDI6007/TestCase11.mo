within Annex60.Experimental.ThermalZones.ReducedOrder.Validation.VDI6007;
model TestCase11 "VDI 6007 Test Case 11 model"
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
    RWin=0.00000001,
    volAir(X_start={0,0}),
    alphaRad=5,
    RExt={0.00436791293674},
    RExtRem=0.03895919557,
    CExt={1600848.94},
    RInt={0.000595693407511},
    CInt={14836354.6282},
    alphaInt=3,
    T_start=295.15,
    indoorPortIntWalls=true)
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
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    columns={2,3},
    table=[3600,22,0; 7200,22,0; 10800,22,0; 14400,22,0; 18000,22,0; 21600,22,0;
        25200,24.9,500; 28800,25.2,500; 32400,25.6,500; 36000,25.9,500; 39600,
        26.2,500; 43200,26.5,500; 46800,26.8,500; 50400,27,464; 54000,27,397;
        57600,27,333; 61200,27,272; 64800,27,215; 68400,25.3,-500; 72000,25.2,-500;
        75600,25.1,-500; 79200,24.9,-500; 82800,24.8,-500; 86400,24.7,-500;
        781200,26.2,-500; 784800,26.1,-500; 788400,26,-500; 792000,25.8,-500;
        795600,25.7,-500; 799200,25.6,-500; 802800,27,126; 806400,27,76; 810000,
        27,28; 813600,27,-121; 817200,27,-391; 820800,27,-500; 824400,27.1,-500;
        828000,27.2,-500; 831600,27.3,-500; 835200,27.4,-500; 838800,27.5,-500;
        842400,27.6,-500; 846000,27,-500; 849600,26.9,-500; 853200,26.7,-500;
        856800,26.6,-500; 860400,26.5,-500; 864000,26.4,-500; 5101200,26.2,-500;
        5104800,26.1,-500; 5108400,26,-500; 5112000,25.8,-500; 5115600,25.7,-500;
        5119200,25.6,-500; 5122800,27,126; 5126400,27,76; 5130000,27,28;
        5133600,27,-121; 5137200,27,-391; 5140800,27,-500; 5144400,27.1,-500;
        5148000,27.2,-500; 5151600,27.3,-500; 5155200,27.4,-500; 5158800,27.5,-500;
        5162400,27.6,-500; 5166000,27,-500; 5169600,26.9,-500; 5173200,26.7,-500;
        5176800,26.6,-500; 5180400,26.5,-500; 5184000,26.4,-500])
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
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = Medium,
    Q_flow_maxCool=0) "Heater"
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
    annotation (Placement(transformation(extent={{-50,-28},{-34,-12}})));
  Fluid.HeatExchangers.HeaterCooler_T         hea1(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_maxHeat=500,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = Medium,
    Q_flow_maxCool=-500) "Heater"
    annotation (Placement(transformation(extent={{-4,-82},{-24,-62}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heat
    annotation (Placement(transformation(extent={{48,-44},{68,-24}})));
  Fluid.Movers.FlowControlled_m_flow         fan1(
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = Medium) "Fan"
    annotation (Placement(transformation(extent={{-76,52},{-56,72}})));
  Modelica.Blocks.Sources.Constant mFan_flow1(
                                             k=m_flow_nominal)
    "Mass flow rate of the fan"
    annotation (Placement(transformation(extent={{-96,74},{-76,94}})));
  Fluid.Sensors.TemperatureTwoPort TCooOut(m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium) "Outlet temperature of the cooler"
    annotation (Placement(transformation(extent={{-12,52},{8,72}})));
  Fluid.HeatExchangers.HeaterCooler_T coo(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_maxCool=-500,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = Medium,
    Q_flow_maxHeat=0) "Cooler"
    annotation (Placement(transformation(extent={{-38,52},{-18,72}})));
  Fluid.Sources.FixedBoundary bouCoo(nPorts=1, redeclare package Medium =
        Medium)
    "Fixed pressure boundary condition, required to set a reference pressure"
    annotation (Placement(transformation(extent={{-60,6},{-80,26}})));
  Fluid.HeatExchangers.HeaterCooler_T         coo1(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_maxHeat=500,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = Medium,
    Q_flow_maxCool=0) "Cooler"
    annotation (Placement(transformation(extent={{-20,26},{-40,46}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow cool
    annotation (Placement(transformation(extent={{-8,74},{12,94}})));
  Modelica.Blocks.Sources.CombiTimeTable setTemp1(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    columns={2},
    table=[0,295.1; 3600,295.1; 7200,295.1; 10800,295.1; 14400,295.1; 18000,
        295.1; 21600,295.1; 25200,300.1; 28800,300.1; 32400,300.1; 36000,300.1;
        39600,300.1; 43200,300.1; 46800,300.1; 50400,300.1; 54000,300.1; 57600,
        300.1; 61200,300.1; 64800,300.1; 68400,295.1; 72000,295.1; 75600,295.1;
        79200,295.1; 82800,295.1; 86400,295.1])
    annotation (Placement(transformation(extent={{-60,80},{-44,96}})));
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

  connect(setTemp.y[1], hea.TSet) annotation (Line(points={{-33.2,-20},{-32,-20},
          {-32,-36},{-26,-36}},
                           color={0,0,127}));
  connect(THeaOut.port_b, hea1.port_a) annotation (Line(points={{36,-42},{38,-42},
          {38,-72},{2,-72},{-4,-72}}, color={0,127,255}));
  connect(fan.port_a, hea1.port_b) annotation (Line(points={{-74,-42},{-96,-42},
          {-96,-72},{-24,-72}}, color={0,127,255}));
  connect(thermalZoneTwoElements.TIndAir, hea1.TSet) annotation (Line(points={{91,31},
          {100,31},{100,-66},{-2,-66}},            color={0,0,127}));
  connect(heat.port, thermalZoneTwoElements.intGainsConv) annotation (Line(
        points={{68,-34},{68,-34},{96,-34},{96,19.8},{91,19.8}}, color={191,0,0}));
  connect(mFan_flow1.y, fan1.m_flow_in) annotation (Line(points={{-75,84},{
          -66.2,84},{-66.2,74}}, color={0,0,127}));
  connect(fan1.port_b, coo.port_a)
    annotation (Line(points={{-56,62},{-38,62}}, color={0,127,255}));
  connect(coo.port_b, TCooOut.port_a)
    annotation (Line(points={{-18,62},{-12,62}}, color={0,127,255}));
  connect(fan1.port_a, bouCoo.ports[1]) annotation (Line(points={{-76,62},{-98,
          62},{-98,16},{-80,16}}, color={0,127,255}));
  connect(TCooOut.port_b, coo1.port_a) annotation (Line(points={{8,62},{10,62},
          {10,36},{-20,36}}, color={0,127,255}));
  connect(fan1.port_a, coo1.port_b) annotation (Line(points={{-76,62},{-98,62},
          {-98,36},{-40,36}}, color={0,127,255}));
  connect(thermalZoneTwoElements.TIndAir, coo1.TSet) annotation (Line(points={{91,31},
          {100,31},{100,42},{-18,42}},            color={0,0,127}));
  connect(cool.port, thermalZoneTwoElements.intWallIndoorSurface) annotation (
      Line(points={{12,84},{12,84},{16,84},{16,18},{16,18},{4,18},{4,-26},{44,
          -26},{44,-8},{56,-8},{56,-1}}, color={191,0,0}));
  connect(setTemp1.y[1], coo.TSet) annotation (Line(points={{-43.2,88},{-40,88},
          {-40,74},{-44,74},{-44,68},{-40,68}}, color={0,0,127}));
  connect(coo.Q_flow, cool.Q_flow) annotation (Line(points={{-17,68},{-12,68},{
          -12,84},{-8,84}}, color={0,0,127}));
  connect(hea.Q_flow, heat.Q_flow) annotation (Line(points={{-3,-36},{14,-36},{
          14,-28},{44,-28},{44,-34},{48,-34}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<p>Test Case 11 of the VDI 6007 Part 1: Calculation of heat load excited with a given radiative heat source and a setpoint profile for room version S. It is based on Test Case 7, but with a cooling ceiling for cooling purposes instead of a pure convective ideal cooler.</p>
<p>Boundary Condtions:</p>
<ul>
<li>constant outdoor air temperature 22 degC</li>
<li>no solar or short-wave radiation on the exterior wall</li>
<li>no solar or short-wave radiation through the windows</li>
<li>no long-wave radiation exchange between exterior wall, windows and ambient environment</li>
</ul>
<p>This test case is thought to test implementation of cooling ceiling or floor heating.</p>
</html>", revisions="<html>
<ul>
<li>January 11, 2016,&nbsp; by Moritz Lauster:<br>Implemented. </li>
</ul>
</html>"),
    experiment(
      StopTime=5.184e+006,
      Interval=3600,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end TestCase11;
