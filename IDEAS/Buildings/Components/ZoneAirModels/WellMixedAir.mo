within IDEAS.Buildings.Components.ZoneAirModels;
model WellMixedAir "Zone air model assuming perfectly mixed air"
  extends PartialAirModel(final nSeg=1, mSenFac=5);
  parameter Boolean useAirLeakage = true "Set to false to disable airleakage computations";

protected
  Fluid.MixingVolumes.MixingVolumeMoistAir       vol(
    m_flow_nominal=m_flow_nominal,
    nPorts=5,
    redeclare package Medium = Medium,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    allowFlowReversal=allowFlowReversal,
    V=Vtot,
    mSenFac=mSenFac,
    use_C_flow=true)                           annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,0})));
  IDEAS.Buildings.Components.ZoneAirModels.AirLeakage airLeakage(
    redeclare package Medium = Medium,
    n50=n50,
    show_T=false,
    V=Vtot,
    n50toAch=n50toAch) if useAirLeakage
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));

protected
  constant Modelica.SIunits.SpecificEnthalpy lambdaWater = 2260000
    "Latent heat of evaporation water";
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Modelica.Blocks.Math.Gain gaiLat(k=lambdaWater)
    "Gain for computing latent heat flow rate based on water vapor mass flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={64,58})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloLat(final
      alpha=0)
    "Prescribed heat flow rate for latent heat gain corresponding to water vapor mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={64,22})));
public
  Fluid.Sensors.RelativeHumidity senRelHum(redeclare package Medium = Medium)
    "Relative humidity of the zone air"
    annotation (Placement(transformation(extent={{20,-30},{40,-50}})));
equation
  assert(vol.ports[1].Xi_outflow[1] <= 0.1,
         "The water content of the zone air model is very high. 
         Possibly you are simulating occupants (that generates a latent heat load), 
         but air is not being refreshed (for instance using ventilation or air leakage models)?",
         level=AssertionLevel.warning);
 E=vol.U;
 QGai=preHeaFloLat.Q_flow;
  connect(vol.ports[1], port_a) annotation (Line(points={{3.2,10},{3.2,10},{40,10},
          {40,100}},  color={0,127,255}));
  connect(vol.ports[2], port_b)
    annotation (Line(points={{1.6,10},{-40,10},{-40,100}},
                                                       color={0,127,255}));
  for i in 1:nSurf loop
    connect(vol.heatPort, ports_surf[i]) annotation (Line(points={{10,-1.33227e-15},
            {10,-1.33227e-15},{10,-20},{-46,-20},{-46,0},{-100,0}},
                                               color={191,0,0}));
  end for;
  connect(airLeakage.port_a, vol.ports[3]) annotation (Line(points={{-10,40},{
          -22,40},{-22,38},{-22,10},{1.11022e-15,10}},color={0,127,255}));
  connect(airLeakage.port_b, vol.ports[4]) annotation (Line(points={{10,40},{20,
          40},{20,38},{20,10},{-1.6,10}},      color={0,127,255}));
  for i in 1:nSeg loop
    connect(ports_air[i], vol.heatPort) annotation (Line(points={{100,0},{64,0},
            {64,-20},{10,-20},{10,0}},
                                   color={191,0,0}));
  end for;
  connect(senTem.port, vol.heatPort) annotation (Line(points={{60,-60},{68,-60},
          {10,-60},{10,0}},   color={191,0,0}));
  connect(senTem.T,TAir)
    annotation (Line(points={{80,-60},{80,-60},{108,-60}}, color={0,0,127}));
  connect(vol.mWat_flow, mWat_flow) annotation (Line(points={{12,-8},{30,-8},{30,
          80},{108,80}}, color={0,0,127}));
  connect(vol.C_flow[1:Medium.nC], C_flow[1:Medium.nC]) annotation (Line(points={{12,6},{32,6},{32,40},{108,
          40}}, color={0,0,127}));
  connect(senTem.T, vol.TWat)
    annotation (Line(points={{80,-60},{80,-4.8},{12,-4.8}}, color={0,0,127}));
  connect(gaiLat.y, preHeaFloLat.Q_flow)
    annotation (Line(points={{64,47},{64,32}}, color={0,0,127}));
  connect(gaiLat.u, mWat_flow)
    annotation (Line(points={{64,70},{64,80},{108,80}}, color={0,0,127}));
  connect(preHeaFloLat.port, vol.heatPort) annotation (Line(points={{64,12},{64,
          -20},{10,-20},{10,0}}, color={191,0,0}));
  connect(senRelHum.phi, phi)
    annotation (Line(points={{41,-40},{72,-40},{108,-40}}, color={0,0,127}));
  connect(senRelHum.port, vol.ports[5]) annotation (Line(points={{30,-30},{30,-30},
          {30,-14},{30,10},{-3.2,10}}, color={0,127,255}));
   annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(revisions="<html>
<ul>
<li>
August 26, 2016 by Filip Jorissen:<br/>
Added support for conservation of energy.
</li>
<li>
April 30, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end WellMixedAir;
