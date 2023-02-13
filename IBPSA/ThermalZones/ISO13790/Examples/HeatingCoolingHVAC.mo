within IBPSA.ThermalZones.ISO13790.Examples;
model HeatingCoolingHVAC "Illustrates the use of the 5R1C HVAC thermal zone connected to a ventilation system"
  extends FreeFloatingHVAC(zonHVAC(nPorts=2));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaCoo
    "Prescribed heat flow for heating and cooling"
    annotation (Placement(visible=true, transformation(extent={{42,64},{58,80}},
          rotation=0)));
  Modelica.Blocks.Math.Gain gaiHea(k=1E6) "Gain for heating"
    annotation (Placement(visible=true,
        transformation(
        origin={12,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Controls.Continuous.LimPID conHeaPID(
    Ti=300,
    k=0.1,
    reverseActing=true,
    strict=true) "Controller for heating"
    annotation (Placement(visible=true, transformation(
        origin={-10,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Sources.Constant TSetHea(k=273.15 + 20) "Set-point for heating"
    annotation (Placement(
        visible=true, transformation(
        origin={-34,72},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRooAir "Room air temperature"
    annotation (
    Placement(visible = true, transformation(extent={{72,2},{88,18}},       rotation = 0)));
  Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = IBPSA.Media.Air,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.03) "fan"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = IBPSA.Media.Air,
    T=280.15,
    nPorts=1) "source of air"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Constant TSetCoo(k=273.15 + 27)
    "Set-point for cooling"
    annotation (Placement(
        visible=true, transformation(
        origin={-34,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Controls.Continuous.LimPID conCooPID(
    Ti=300,
    k=0.1,
    yMax=0.07,
    reverseActing=false,
    strict=true) "Controller for cooling"
    annotation (Placement(visible=true, transformation(
        origin={-10,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Modelica.Blocks.Math.Gain gaiCoo(k=1) "Gain for cooling"
    annotation (Placement(visible=true,
        transformation(
        origin={12,46},
        extent={{-6,-6},{6,6}},
        rotation=0)));
  Fluid.Sources.Boundary_pT sin(redeclare package Medium = IBPSA.Media.Air,
      nPorts=1) "sink"
    annotation (Placement(transformation(extent={{90,-80},{70,-60}})));
equation
  connect(conHeaPID.y,gaiHea. u)
    annotation (Line(points={{-3.4,72},{4.8,72}}, color={0,0,127}));
  connect(TSetHea.y,conHeaPID. u_s)
    annotation (Line(points={{-27.4,72},{-17.2,72}}, color={0,0,127}));
  connect(conHeaPID.y,gaiHea. u)
    annotation (Line(points={{-3.4,72},{4.8,72}}, color={0,0,127}));
  connect(gaiHea.y, preHeaCoo.Q_flow) annotation (Line(points={{18.6,72},{42,72}},
                            color={0,0,127}));
  connect(sou.ports[1], fan.port_a)
    annotation (Line(points={{-20,-70},{0,-70}},color={0,127,255}));
  connect(conCooPID.u_s,TSetCoo. y)
    annotation (Line(points={{-17.2,46},{-27.4,46}}, color={0,0,127}));
  connect(gaiCoo.u,conCooPID. y)
    annotation (Line(points={{4.8,46},{-3.4,46}}, color={0,0,127}));
  connect(TRooAir.T, conCooPID.u_m) annotation (Line(points={{88.8,10},{96,10},
          {96,32},{-10,32},{-10,38.8}},
                                    color={0,0,127}));
  connect(conHeaPID.u_m, TRooAir.T) annotation (Line(points={{-10,64.8},{-10,56},
          {96,56},{96,10},{88.8,10}},              color={0,0,127}));
  connect(gaiCoo.y, fan.m_flow_in) annotation (Line(points={{18.6,46},{22,46},{
          22,6},{10,6},{10,-58}},                  color={0,0,127}));
  connect(fan.port_b, zonHVAC.ports_b[1]) annotation (Line(points={{20,-70},{62,
          -70},{62,12.05},{52.95,12.05}}, color={0,127,255}));
  connect(sin.ports[1], zonHVAC.ports_b[2]) annotation (Line(points={{70,-70},{
          64,-70},{64,10},{54,10},{54,12.05},{52.95,12.05}},
                                             color={0,127,255}));
  connect(TRooAir.port, zonHVAC.TAir) annotation (Line(points={{72,10},{44,10}},
                           color={191,0,0}));
  connect(preHeaCoo.port, zonHVAC.TAir) annotation (Line(points={{58,72},{68,72},
          {68,10},{44,10}}, color={191,0,0}));
  annotation (experiment(Tolerance=1e-6, StopTime=3.1536e+007),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ISO13790/Examples/HeatingCoolingHVAC.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model illustrates the use of <a href=\"modelica://IBPSA.ThermalZones.ISO13790.Zone5R1C.ZoneHVAC\">
IBPSA.ThermalZones.ISO13790.Zone5R1C.ZoneHVAC</a> with heating and cooling. Cooling is delivered by
a ventilation system with supply air temperature of <i>7</i>&deg;C.
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
