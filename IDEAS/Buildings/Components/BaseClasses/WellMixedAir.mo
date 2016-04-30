within IDEAS.Buildings.Components.BaseClasses;
model WellMixedAir "Zone air model assuming perfectly mixed air"
  extends PartialAirModel(final nSeg=1);
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal in medium, false restricts to design direction (ports[1] -> ports[2]). Used only if model has two ports.";
  parameter Real n50=0.4 "n50-value of airtightness";
  parameter Real n50toAch = 20 "Conversion fractor from n50 to Air Change Rate";
  Modelica.SIunits.Energy E = vol.U "Internal energy";
protected
  Fluid.MixingVolumes.MixingVolume         vol(
    m_flow_nominal=m_flow_nominal,
    nPorts=4,
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
    mSenFac=mSenFac)                           annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={0,0})));
  AirLeakage                                        airLeakage(
    redeclare package Medium = Medium,
    n50=n50,
    show_T=false,
    V=Vtot,
    n50toAch=n50toAch)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
equation
  connect(vol.ports[1], port_a) annotation (Line(points={{-3,10},{-3,10},{40,10},
          {40,100}},  color={0,127,255}));
  connect(vol.ports[2], port_b)
    annotation (Line(points={{-1,10},{-40,10},{-40,100}},
                                                       color={0,127,255}));
  for i in 1:nSurf loop
    connect(vol.heatPort, ports_surf[i]) annotation (Line(points={{-10,1.33227e-15},
          {-50,1.33227e-15},{-50,0},{-100,0}}, color={191,0,0}));
  end for;
  connect(airLeakage.port_a, vol.ports[3]) annotation (Line(points={{-10,40},{-22,
          40},{-22,38},{-22,10},{1,10}},              color={0,127,255}));
  connect(airLeakage.port_b, vol.ports[4]) annotation (Line(points={{10,40},{20,
          40},{20,38},{20,10},{3,10}},         color={0,127,255}));
  for i in 1:nSeg loop
    connect(ports_air[i], vol.heatPort) annotation (Line(points={{100,0},{40,0},{40,
          -20},{-10,-20},{-10,0}}, color={191,0,0}));
  end for;
   annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(revisions="<html>
<ul>
<li>
April 30, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end WellMixedAir;
