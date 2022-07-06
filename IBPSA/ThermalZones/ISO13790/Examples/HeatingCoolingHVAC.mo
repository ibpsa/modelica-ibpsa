within IBPSA.ThermalZones.ISO13790.Examples;
model HeatingCoolingHVAC "Illustrates the use of the 5R1C HVAC thermal zone connected to a ventilation system"
  extends FreeFloatingHVAC(zonHVAC(nPorts=2));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaCoo
    annotation (Placement(visible=true, transformation(extent={{58,54},{70,66}},
          rotation=0)));
  Modelica.Blocks.Math.Gain gaiHea(k=1E6) annotation (Placement(visible=true,
        transformation(
        origin={12,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Controls.Continuous.LimPID       conHeaPID(
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
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRooAir annotation (
    Placement(visible = true, transformation(extent={{0,20},{8,28}},        rotation = 0)));
  Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = IBPSA.Media.Air,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.03)
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = IBPSA.Media.Air,
    T=280.15,
    nPorts=1) annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Sources.Constant TSetCoo(k=273.15 + 27) annotation (Placement(
        visible=true, transformation(
        origin={-34,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Controls.Continuous.LimPID       conCooPID(
    Ti=300,
    k=0.1,
    yMax=0.07,
    reverseActing=false,
    strict=true) annotation (Placement(visible=true, transformation(
        origin={-10,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Math.Gain gaiCoo(k=1)    annotation (Placement(visible=true,
        transformation(
        origin={12,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Fluid.Sources.Boundary_pT bou1(redeclare package Medium = IBPSA.Media.Air,
      nPorts=1)
    annotation (Placement(transformation(extent={{90,-80},{70,-60}})));
equation
  connect(conHeaPID.y,gaiHea. u)
    annotation (Line(points={{-3.4,72},{4.8,72}}, color={0,0,127}));
  connect(TSetHea.y,conHeaPID. u_s)
    annotation (Line(points={{-27.4,72},{-17.2,72}}, color={0,0,127}));
  connect(conHeaPID.y,gaiHea. u)
    annotation (Line(points={{-3.4,72},{4.8,72}}, color={0,0,127}));
  connect(gaiHea.y, preHeaCoo.Q_flow) annotation (Line(points={{18.6,72},{40,72},
          {40,60},{58,60}}, color={0,0,127}));
  connect(bou.ports[1], fan.port_a)
    annotation (Line(points={{0,-70},{20,-70}}, color={0,127,255}));
  connect(conCooPID.u_s,TSetCoo. y)
    annotation (Line(points={{-17.2,46},{-27.4,46}}, color={0,0,127}));
  connect(gaiCoo.u,conCooPID. y)
    annotation (Line(points={{4.8,46},{-3.4,46}}, color={0,0,127}));
  connect(TRooAir.T, conCooPID.u_m) annotation (Line(points={{8.4,24},{14,24},{14,
          32},{-10,32},{-10,38.8}}, color={0,0,127}));
  connect(conHeaPID.u_m, TRooAir.T) annotation (Line(points={{-10,64.8},{-10,58},
          {0,58},{0,32},{14,32},{14,24},{8.4,24}}, color={0,0,127}));
  connect(gaiCoo.y, fan.m_flow_in) annotation (Line(points={{18.6,46},{30,46},{30,
          24},{16,24},{16,-42},{30,-42},{30,-58}}, color={0,0,127}));
  connect(fan.port_b, zonHVAC.ports_b[1]) annotation (Line(points={{40,-70},{48,
          -70},{48,12.05},{52.95,12.05}}, color={0,127,255}));
  connect(bou1.ports[1], zonHVAC.ports_b[2]) annotation (Line(points={{70,-70},{
          66,-70},{66,12.05},{52.95,12.05}}, color={0,127,255}));
  connect(TRooAir.port, zonHVAC.TAir) annotation (Line(points={{0,24},{-4,24},{
          -4,10},{44,10}}, color={191,0,0}));
  connect(preHeaCoo.port, zonHVAC.TAir) annotation (Line(points={{70,60},{74,60},
          {74,10},{44,10}}, color={191,0,0}));
  annotation (experiment(Tolerance=1e-6, StopTime=3.1536e+007),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ISO13790/Examples/HeatingCoolingHVAC.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model illustrates the use of <a href=\"modelica://IBPSA.ThermalZones.ISO13790.Zone5R1C.ZoneHVAC\">
IBPSA.ThermalZones.ISO13790.Zone5R1C.ZoneHVAC</a> with heating and cooling. Cooling is delivered by
a ventilation system with supply air temperature of 7°C.
</p>
</html>",
revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatingCoolingHVAC;
