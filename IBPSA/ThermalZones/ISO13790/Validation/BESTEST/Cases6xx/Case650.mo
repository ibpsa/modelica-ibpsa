within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case650
  extends IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(zonHVAC(
        nPorts=3), gaiHea(k=0))
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  Fluid.Sensors.Density senDen(redeclare package Medium = Media.Air,
      warnAboutOnePortConnection=false)
    annotation (Placement(transformation(extent={{50,-20},{70,0}})));
  Modelica.Blocks.Math.Product product1
    "Product to compute infiltration mass flow rate"
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
  Modelica.Blocks.Sources.CombiTimeTable
                          vent(table=[0,-1409/3600; 7*3600,-1409/3600; 7*3600,0;
        18*3600,0; 18*3600,-1409/3600; 24*3600,-1409/3600], extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic)
    "Ventilation air flow rate"
    annotation (Placement(transformation(extent={{90,-70},{70,-50}})));
  Fluid.Sources.MassFlowSource_T           sinInf(
    redeclare package Medium = Media.Air,
    use_m_flow_in=true,
    nPorts=1) "Sink model for air infiltration"
    annotation (Placement(transformation(extent={{8,-70},{-12,-50}})));
  Fluid.Sources.Outside out(redeclare package Medium = Media.Air, nPorts=1)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(senDen.d,product1. u1) annotation (Line(points={{71,-10},{84,-10},{84,
          -34},{52,-34}}, color={0,0,127}));
  connect(product1.y,sinInf. m_flow_in) annotation (Line(points={{29,-40},{10,-40},
          {10,-52}},          color={0,0,127}));
  connect(out.weaBus, zonHVAC.weaBus) annotation (Line(
      points={{-80,60.2},{-84,60.2},{-84,60},{-90,60},{-90,40},{-50,40},{-50,20},
          {10,20},{10,11}},
      color={255,204,51},
      thickness=0.5));
  connect(vent.y[1], product1.u2) annotation (Line(points={{69,-60},{62,-60},{62,
          -46},{52,-46}}, color={0,0,127}));
  connect(zonHVAC.ports[1], senDen.port) annotation (Line(points={{-13,-8.2},{-6,
          -8.2},{-6,-20},{60,-20}}, color={0,127,255}));
  connect(zonHVAC.ports[2], out.ports[1]) annotation (Line(points={{-13,-8.2},{-44,
          -8.2},{-44,60},{-60,60}}, color={0,127,255}));
  connect(sinInf.ports[1], zonHVAC.ports[3]) annotation (Line(points={{-12,-60},
          {-18,-60},{-18,-8.2},{-13,-8.2}}, color={0,127,255}));
 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case650.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the basic test case 640 of the BESTEST validation suite.
Case640 is the same as Case600, but with the following modifications:
</p>
<ul>
<li>
From 2300 hours to 0700 hours, heat = on if zone temperature is below 10&deg;C
</li>
<li>
From 0700 hours to 0800 hours, the thermostat set point shall vary linearly with
time from 10 &deg;C to 20 &deg;C.
If the zone temperature is less than the thermostat set point for a subhourly
time step, heat shall be added to the zone such that the zone temperature at the
end of each subhourly time step shall correspond to the thermostat set point that
occurs at the end of each subhourly time step.
</li>
<li>
From 0800 hours to 2300 hours, heat = on if zone temperature is below 20&deg;C
</li>
<li>
All hours, cool = on if zone temperature above 27&deg;C
</li>
<li>
Otherwise, mechanical equipment is off.
</li>
</ul>
</html>", revisions="<html><ul>
<li>
Mar 2, 2024, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case650;
