within IBPSA.ThermalZones.ISO13790.Examples;
model HeatingCooling
  extends Modelica.Icons.Example;

  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/DRYCOLD.mos"))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));


  Zone5R1C.Zone zone(redeclare Data.Medium buiMas)
    annotation (Placement(transformation(extent={{26,-12},{54,16}})));
  Modelica.Blocks.Sources.Constant intGains(k=10)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Math.Sum sumHeaCoo(nin=2)   annotation (
    Placement(visible = true, transformation(extent={{44,56},{52,64}},      rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaCoo
    annotation (Placement(visible=true, transformation(extent={{58,54},{70,66}},
          rotation=0)));
  Modelica.Blocks.Math.Gain gaiHea(k=1E6) annotation (Placement(visible=true,
        transformation(
        origin={12,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  IBPSA.Controls.Continuous.LimPID conHeaPID(
    Ti=300,
    k=0.1,
    reverseActing=true,
    strict=true) annotation (Placement(visible=true, transformation(
        origin={-10,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Sources.Constant TSetHea(k=273.15 + 20) annotation (Placement(
        visible=true, transformation(
        origin={-34,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Sources.Constant TSetCoo(k=273.15 + 27) annotation (Placement(
        visible=true, transformation(
        origin={-34,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Routing.Multiplex2 multiplex2 annotation (
    Placement(visible = true, transformation(extent={{28,56},{36,64}},      rotation = 0)));
  Modelica.Blocks.Math.Gain gaiCoo(k=-1E6) annotation (Placement(visible=true,
        transformation(
        origin={12,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  IBPSA.Controls.Continuous.LimPID conCooPID(
    Ti=300,
    k=0.1,
    reverseActing=false,
    strict=true) annotation (Placement(visible=true, transformation(
        origin={-10,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRooAir annotation (
    Placement(visible = true, transformation(extent={{0,20},{8,28}},        rotation = 0)));
equation
  connect(zone.weaBus, weaDat.weaBus) annotation (Line(
      points={{30.6,13},{-50.7,13},{-50.7,70},{-60,70}},
      color={255,204,51},
      thickness=0.5));
  connect(intGains.y, zone.intGains) annotation (Line(points={{-59,-70},{-50,
          -70},{-50,-10},{24,-10}}, color={0,0,127}));
  connect(sumHeaCoo.y, preHeaCoo.Q_flow)
    annotation (Line(points={{52.4,60},{58,60}}, color={0,0,127}));
  connect(conHeaPID.y, gaiHea.u)
    annotation (Line(points={{-3.4,72},{4.8,72}}, color={0,0,127}));
  connect(conHeaPID.u_m, TRooAir.T) annotation (Line(points={{-10,64.8},{-10,56},
          {0,56},{0,32},{18,32},{18,24},{8.4,24}},
                                                 color={0,0,127}));
  connect(TSetHea.y, conHeaPID.u_s)
    annotation (Line(points={{-27.4,72},{-17.2,72}}, color={0,0,127}));
  connect(gaiHea.y, multiplex2.u1[1]) annotation (Line(points={{18.6,72},{27.2,
          72},{27.2,62.4}}, color={0,0,127}));
  connect(multiplex2.y,sumHeaCoo. u) annotation (
    Line(points={{36.4,60},{43.2,60}},      color = {0, 0, 127}));
  connect(gaiCoo.y, multiplex2.u2[1]) annotation (Line(points={{18.6,46},{27.2,
          46},{27.2,57.6}}, color={0,0,127}));
  connect(conCooPID.u_s, TSetCoo.y)
    annotation (Line(points={{-17.2,46},{-27.4,46}}, color={0,0,127}));
  connect(conCooPID.y, gaiCoo.u)
    annotation (Line(points={{-3.4,46},{4.8,46}}, color={0,0,127}));
  connect(conHeaPID.y, gaiHea.u)
    annotation (Line(points={{-3.4,72},{4.8,72}}, color={0,0,127}));
  connect(gaiHea.y, multiplex2.u1[1]) annotation (Line(points={{18.6,72},{27.2,
          72},{27.2,62.4}}, color={0,0,127}));
  connect(gaiCoo.y, multiplex2.u2[1]) annotation (Line(points={{18.6,46},{27.2,
          46},{27.2,57.6}}, color={0,0,127}));
  connect(gaiCoo.u, conCooPID.y)
    annotation (Line(points={{4.8,46},{-3.4,46}}, color={0,0,127}));
  connect(TRooAir.T, conCooPID.u_m) annotation (Line(points={{8.4,24},{18,24},{
          18,32},{-10,32},{-10,38.8}},
                                    color={0,0,127}));
  connect(TRooAir.port, zone.Tair) annotation (Line(points={{0,24},{-8,24},{-8,
          10},{44,10}}, color={191,0,0}));
  connect(preHeaCoo.port, zone.Tair) annotation (Line(points={{70,60},{80,60},{
          80,10},{44,10}}, color={191,0,0}));
  annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Dassl"));
end HeatingCooling;
