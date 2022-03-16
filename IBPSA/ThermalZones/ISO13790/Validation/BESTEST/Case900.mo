within IBPSA.ThermalZones.ISO13790.Validation.BESTEST;
model Case900
  extends Modelica.Icons.Example;
  Zone5R1C.Zone          zone(
    Uwin=2.984,
    Awal={21.6,16.2,9.6,16.2},
    Uwal=0.51,
    Uroo=0.32,
    Vroo=129.6,
    f_ms=2.7,
    redeclare ISO13790.Data.BESTEST900 buiMas,
    gFactor=0.789)
    annotation (Placement(transformation(extent={{-14,-14},{14,14}})));
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/DRYCOLD.mos"))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Constant intGains(k=200)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Math.Sum sumHeaCoo(nin=2)   annotation (
    Placement(visible = true, transformation(extent={{54,56},{62,64}},      rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaCoo
    annotation (Placement(visible=true, transformation(extent={{68,54},{80,66}},
          rotation=0)));
  Modelica.Blocks.Math.Gain gaiHea(k=1E6) annotation (Placement(visible=true,
        transformation(
        origin={22,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  IBPSA.Controls.Continuous.LimPID conHeaPID(
    Ti=300,
    k=0.1,
    reverseActing=true,
    strict=true) annotation (Placement(visible=true, transformation(
        origin={0,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Sources.Constant TSetHea(k=273.15 + 20) annotation (Placement(
        visible=true, transformation(
        origin={-24,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Sources.Constant TSetCoo(k=273.15 + 27) annotation (Placement(
        visible=true, transformation(
        origin={-24,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2 annotation (
    Placement(visible = true, transformation(extent={{38,56},{46,64}},      rotation = 0)));
  Modelica.Blocks.Math.Gain gaiCoo(k=-1E6) annotation (Placement(visible=true,
        transformation(
        origin={22,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  IBPSA.Controls.Continuous.LimPID conCooPID(
    Ti=300,
    k=0.1,
    reverseActing=false,
    strict=true) annotation (Placement(visible=true, transformation(
        origin={0,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Continuous.Integrator ECoo(
    k=1/3600000000,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(unit="W"),
    y(unit="J")) "Cooling energy in Joules"
    annotation (Placement(transformation(extent={{54,34},{66,46}})));
  Modelica.Blocks.Continuous.Integrator EHea(
    k=1/3600000000,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0,
    u(unit="W"),
    y(unit="J")) "Heating energy in Joules"
    annotation (Placement(transformation(extent={{54,74},{66,86}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRooAir annotation (
    Placement(visible = true, transformation(extent={{12,20},{20,28}},      rotation = 0)));
equation
  connect(weaDat.weaBus, zone.weaBus) annotation (Line(
      points={{-60,70},{-38,70},{-38,11},{-9.4,11}},
      color={255,204,51},
      thickness=0.5));
  connect(intGains.y, zone.intGains) annotation (Line(points={{-39,-30},{-30,
          -30},{-30,-12},{-16,-12}}, color={0,0,127}));
  connect(sumHeaCoo.y,preHeaCoo. Q_flow)
    annotation (Line(points={{62.4,60},{68,60}}, color={0,0,127}));
  connect(conHeaPID.y,gaiHea. u)
    annotation (Line(points={{6.6,72},{14.8,72}}, color={0,0,127}));
  connect(TSetHea.y,conHeaPID. u_s)
    annotation (Line(points={{-17.4,72},{-7.2,72}},  color={0,0,127}));
  connect(gaiHea.y,multiplex2. u1[1]) annotation (Line(points={{28.6,72},{37.2,
          72},{37.2,62.4}}, color={0,0,127}));
  connect(multiplex2.y,sumHeaCoo. u) annotation (
    Line(points={{46.4,60},{53.2,60}},      color = {0, 0, 127}));
  connect(gaiCoo.y,multiplex2. u2[1]) annotation (Line(points={{28.6,46},{37.2,
          46},{37.2,57.6}}, color={0,0,127}));
  connect(conCooPID.u_s,TSetCoo. y)
    annotation (Line(points={{-7.2,46},{-17.4,46}},  color={0,0,127}));
  connect(conCooPID.y,gaiCoo. u)
    annotation (Line(points={{6.6,46},{14.8,46}}, color={0,0,127}));
  connect(conHeaPID.y,gaiHea. u)
    annotation (Line(points={{6.6,72},{14.8,72}}, color={0,0,127}));
  connect(gaiHea.y,multiplex2. u1[1]) annotation (Line(points={{28.6,72},{37.2,
          72},{37.2,62.4}}, color={0,0,127}));
  connect(gaiCoo.y,multiplex2. u2[1]) annotation (Line(points={{28.6,46},{37.2,
          46},{37.2,57.6}}, color={0,0,127}));
  connect(gaiCoo.u,conCooPID. y)
    annotation (Line(points={{14.8,46},{6.6,46}}, color={0,0,127}));
  connect(EHea.u, gaiHea.y) annotation (Line(points={{52.8,80},{44,80},{44,72},
          {28.6,72}}, color={0,0,127}));
  connect(ECoo.u, gaiCoo.y) annotation (Line(points={{52.8,40},{44,40},{44,46},
          {28.6,46}}, color={0,0,127}));
  connect(conCooPID.u_m, TRooAir.T) annotation (Line(points={{0,38.8},{0,34},{
          24,34},{24,24},{20.4,24}}, color={0,0,127}));
  connect(TRooAir.port, zone.Tair)
    annotation (Line(points={{12,24},{4,24},{4,8}}, color={191,0,0}));
  connect(preHeaCoo.port, zone.Tair)
    annotation (Line(points={{80,60},{84,60},{84,8},{4,8}}, color={191,0,0}));
  connect(conHeaPID.u_m, TRooAir.T) annotation (Line(points={{0,64.8},{0,60},{
          10,60},{10,34},{24,34},{24,24},{20.4,24}}, color={0,0,127}));
end Case900;
