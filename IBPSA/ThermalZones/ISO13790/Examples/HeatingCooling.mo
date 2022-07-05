within IBPSA.ThermalZones.ISO13790.Examples;
model HeatingCooling "Illustrates the use of the 5R1C thermal zone with heating and cooling"
  extends FreeFloating(zon5R1C(
      nVe=0.5,
      Awin={0,0,3,0},
      Uwin=1.8,
      Awal={12,12,9,12},
      Aroo=16,
      Uwal=1.3,
      Uroo=1.3,
      Af=16,
      Vroo=16*3,
      f_ms=2.5,
      redeclare IBPSA.ThermalZones.ISO13790.Data.Light buiMas,
      gFactor=0.5), weaDat(filNam=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")));

  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));


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
  connect(zon5R1C.weaBus, weaDat.weaBus) annotation (Line(
      points={{30.6,13},{-50.7,13},{-50.7,70},{-60,70}},
      color={255,204,51},
      thickness=0.5));
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
  connect(TRooAir.port, zon5R1C.TAir) annotation (Line(points={{0,24},{-10,24},
          {-10,10},{44,10}}, color={191,0,0}));
  connect(preHeaCoo.port, zon5R1C.TAir) annotation (Line(points={{70,60},{76,60},
          {76,10},{44,10}}, color={191,0,0}));
  annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Dassl"),
  Documentation(info="<html>
<p>
This model illustrates the use of <a href=\"modelica://IBPSA.ThermalZones.ISO13790.Zone5R1C.Zone\">
IBPSA.ThermalZones.ISO13790.Zone5R1C.Zone</a> with heating and cooling.
</p>
</html>",
revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>
Mass data for heavy building
</p>
</html>"));
end HeatingCooling;
