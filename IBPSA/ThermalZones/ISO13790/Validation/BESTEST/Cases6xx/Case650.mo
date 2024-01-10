within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case650 "Case 600, but cooling based on schedule, night venting, and no heating"
  extends Modelica.Icons.Example;
  Modelica.Blocks.Math.Sum sumHeaCoo(nin=2)
    "Sum of heating and cooling heat flow rate"
    annotation (
    Placement(visible = true, transformation(extent={{54,56},{62,64}},      rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaCoo
    "Prescribed heat flow for heating and cooling"
    annotation (Placement(visible=true, transformation(extent={{68,54},{80,66}},
          rotation=0)));
  Modelica.Blocks.Math.Gain gaiHea(k=0) "Gain for heating"
    annotation (Placement(visible=true,
        transformation(
        origin={22,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  IBPSA.Controls.Continuous.LimPID conHeaPID(
    Ti=300,
    k=0.1,
    reverseActing=true,
    strict=true) "Controller for heating"
    annotation (Placement(visible=true, transformation(
        origin={0,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Sources.CombiTimeTable
                                   TSetHea(table=[0.0,273.15 + 20])
                                                          "Set-point for heating"
    annotation (Placement(
        visible=true, transformation(
        origin={-24,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2
    annotation (
    Placement(visible = true, transformation(extent={{38,56},{46,64}},      rotation = 0)));
  Modelica.Blocks.Math.Gain gaiCoo(k=-1E6) "Gain for cooling"
    annotation (Placement(visible=true,
        transformation(
        origin={22,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  IBPSA.Controls.Continuous.LimPID conCooPID(
    Ti=300,
    k=0.1,
    reverseActing=false,
    strict=true) "Controller for cooling"
    annotation (Placement(visible=true, transformation(
        origin={0,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Continuous.Integrator ECoo(
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(unit="W"),
    y(unit="J", displayUnit="J")) "Cooling energy in Joules"
    annotation (Placement(transformation(extent={{54,34},{66,46}})));
  Zone5R1C.ZoneHVAC
                zonHVAC(
    airRat=0.414,
    AWin={0,0,12,0},
    UWin=3.095,
    AWal={21.6,16.2,9.6,16.2},
    ARoo=48,
    UWal=0.534,
    URoo=0.327,
    UFlo=0.0377,
    b=1,
    AFlo=48,
    VRoo=129.6,
    hInt=2.1,
    redeclare replaceable IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Data.Case600Mass buiMas,
    nOrientations=4,
    surTil={1.5707963267949,1.5707963267949,1.5707963267949,1.5707963267949},
    surAzi={3.1415926535898,-1.5707963267949,0,1.5707963267949},
    gFac=0.769,
    coeFac={1,-0.189,0.644,-0.596},
    redeclare package Medium = IBPSA.Media.Air,
    nPorts=3)
    annotation (Placement(transformation(extent={{-14,-14},{14,14}})));

  Modelica.Blocks.Sources.Constant intGai(k=200) "Internal heat gains"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/weatherdata/USA_CO_Denver.Intl.AP.725650_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Continuous.Integrator EHea(
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(unit="W"),
    y(unit="J", displayUnit="J")) "Cooling energy in Joules"
    annotation (Placement(transformation(extent={{54,74},{66,86}})));
  Modelica.Blocks.Math.Gain EHeaMWh(k=1/3600000000) "Gain for heating"
    annotation (Placement(visible=true,
        transformation(
        origin={82,80},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Math.Gain ECooMWh(k=1/3600000000) "Gain for heating"
    annotation (Placement(visible=true, transformation(
        origin={84,40},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage PHea(delta=3600)
    "Hourly averaged heating power"
    annotation (Placement(transformation(extent={{34,84},{42,92}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage PHea1(delta=3600)
    "Hourly averaged heating power"
    annotation (Placement(transformation(extent={{38,22},{46,30}})));
  Modelica.Blocks.Math.Gain PCookW(k=1/1000) "Gain for heating" annotation (
      Placement(visible=true, transformation(
        origin={60,16},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Math.Gain PHeakW(k=1/1000) "Gain for heating" annotation (
      Placement(visible=true, transformation(
        origin={58,98},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Sources.Constant intGaiLat(k=0) "Latent Internal heat gains"
    annotation (Placement(transformation(extent={{-80,-54},{-60,-34}})));
  Modelica.Blocks.Sources.CombiTimeTable
                          vent(table=[0,-1409/3600; 7*3600,-1409/3600; 7*3600,0;
        18*3600,0; 18*3600,-1409/3600; 24*3600,-1409/3600], extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic)
    "Ventilation air flow rate"
    annotation (Placement(transformation(extent={{92,-70},{72,-50}})));
  Fluid.Sources.MassFlowSource_T           sinInf(
    redeclare package Medium = Buildings.Media.Air,
    use_m_flow_in=true,
    nPorts=1) "Sink model for air infiltration"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Modelica.Blocks.Math.Product product1
    "Product to compute infiltration mass flow rate"
    annotation (Placement(transformation(extent={{42,-48},{22,-28}})));
  Fluid.Sources.Outside out(redeclare package Medium = IBPSA.Media.Air, nPorts=1)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Fluid.Sensors.Density senDen(redeclare package Medium = IBPSA.Media.Air,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetCoo(table=[0,273.15 + 100; 7*3600,273.15
         + 100; 7*3600,273.15 + 27; 18*3600,273.15 + 27; 18*3600,273.15 + 100; 24
        *3600,273.15 + 100], extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint"
    annotation (Placement(transformation(extent={{-30,40},{-18,52}})));
equation
  connect(sumHeaCoo.y,preHeaCoo. Q_flow)
    annotation (Line(points={{62.4,60},{68,60}}, color={0,0,127}));
  connect(conHeaPID.y,gaiHea. u)
    annotation (Line(points={{6.6,72},{14.8,72}}, color={0,0,127}));
  connect(multiplex2.y,sumHeaCoo. u) annotation (
    Line(points={{46.4,60},{53.2,60}},      color = {0, 0, 127}));
  connect(conCooPID.y,gaiCoo. u)
    annotation (Line(points={{6.6,46},{14.8,46}}, color={0,0,127}));
  connect(gaiHea.y,multiplex2. u1[1]) annotation (Line(points={{28.6,72},{32,72},
          {32,62},{38,62},{38,62.4},{37.2,62.4}},
                            color={0,0,127}));
  connect(gaiCoo.y,multiplex2. u2[1]) annotation (Line(points={{28.6,46},{32,46},
          {32,58},{38,58},{38,57.6},{37.2,57.6}},
                            color={0,0,127}));
  connect(gaiCoo.u,conCooPID. y)
    annotation (Line(points={{14.8,46},{6.6,46}}, color={0,0,127}));
  connect(ECoo.u, gaiCoo.y) annotation (Line(points={{52.8,40},{44,40},{44,46},
          {28.6,46}}, color={0,0,127}));

  connect(preHeaCoo.port,zonHVAC. heaPorAir) annotation (Line(points={{80,60},{
          90,60},{90,4},{4,4},{4,8}}, color={191,0,0}));
  connect(intGai.y,zonHVAC. intSenGai) annotation (Line(points={{-59,-10},{-30,
          -10},{-30,10},{-16,10}},   color={0,0,127}));
  connect(weaDat.weaBus,zonHVAC. weaBus) annotation (Line(
      points={{-60,20},{10,20},{10,11}},
      color={255,204,51},
      thickness=0.5));
  connect(zonHVAC.TAir, conCooPID.u_m) annotation (Line(points={{15,8},{20,8},{
          20,30},{0,30},{0,38.8}}, color={0,0,127}));
  connect(zonHVAC.TAir, conHeaPID.u_m) annotation (Line(points={{15,8},{20,8},{
          20,30},{-40,30},{-40,60},{0,60},{0,64.8}}, color={0,0,127}));
  connect(EHea.u, gaiHea.y) annotation (Line(points={{52.8,80},{44,80},{44,72},{
          28.6,72}}, color={0,0,127}));
  connect(EHeaMWh.u, EHea.y)
    annotation (Line(points={{74.8,80},{66.6,80}}, color={0,0,127}));
  connect(ECooMWh.u, ECoo.y)
    annotation (Line(points={{76.8,40},{66.6,40}}, color={0,0,127}));
  connect(PHea.u, gaiHea.y)
    annotation (Line(points={{33.2,88},{28.6,88},{28.6,72}}, color={0,0,127}));
  connect(PHea1.u, gaiCoo.y) annotation (Line(points={{37.2,26},{28,26},{28,46},
          {28.6,46}}, color={0,0,127}));
  connect(PCookW.u, PHea1.y)
    annotation (Line(points={{52.8,16},{46.8,16},{46.8,26}}, color={0,0,127}));
  connect(PHea.y, PHeakW.u) annotation (Line(points={{42.8,88},{48,88},{48,94},{
          46,94},{46,98},{50.8,98}}, color={0,0,127}));
  connect(TSetHea.y[1], conHeaPID.u_s)
    annotation (Line(points={{-17.4,72},{-7.2,72}}, color={0,0,127}));
  connect(intGaiLat.y, zonHVAC.intLatGai) annotation (Line(points={{-59,-44},{-26,
          -44},{-26,4},{-16,4}}, color={0,0,127}));
  connect(vent.y[1], product1.u2)
    annotation (Line(points={{71,-60},{44,-60},{44,-44}}, color={0,0,127}));
  connect(product1.y, sinInf.m_flow_in) annotation (Line(points={{21,-38},{14,-38},
          {14,-52},{12,-52}}, color={0,0,127}));
  connect(sinInf.ports[1], zonHVAC.ports[1]) annotation (Line(points={{-10,-60},
          {-22,-60},{-22,-9.5},{-13,-9.5}}, color={0,127,255}));
  connect(out.weaBus, weaDat.weaBus) annotation (Line(
      points={{-80,60.2},{-84,60.2},{-84,60},{-88,60},{-88,42},{-54,42},{-54,20},
          {-60,20}},
      color={255,204,51},
      thickness=0.5));
  connect(out.ports[1], zonHVAC.ports[2]) annotation (Line(points={{-60,60},{-44,
          60},{-44,-8.2},{-13,-8.2}}, color={0,127,255}));
  connect(senDen.port, zonHVAC.ports[3]) annotation (Line(points={{70,-20},{-2,-20},
          {-2,-6.9},{-13,-6.9}}, color={0,127,255}));
  connect(senDen.d, product1.u1) annotation (Line(points={{81,-10},{92,-10},{92,
          -32},{44,-32}}, color={0,0,127}));
  connect(TSetCoo.y[1], conCooPID.u_s)
    annotation (Line(points={{-17.4,46},{-7.2,46}}, color={0,0,127}));
 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Case600.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the basic test case 600 of the BESTEST validation suite. 
Case 600 is a light-weight building with room temperature control set to <i>20</i>&deg;C 
for heating and <i>27</i>&deg;C for cooling. The room has no shade and a window that faces south. 
</p>
</html>", revisions="<html><ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case650;
