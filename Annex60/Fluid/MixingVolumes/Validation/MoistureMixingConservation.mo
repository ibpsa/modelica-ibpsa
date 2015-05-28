within Annex60.Fluid.MixingVolumes.Validation;
model MoistureMixingConservation
  "This test checks if mass and energy is conserved when mixing fluid streams"
  extends Modelica.Icons.Example;
  package Medium = Annex60.Media.Air;
  Annex60.Fluid.Sources.MassFlowSource_h sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=2,
    X={mWatFloSol.k,1 - mWatFloSol.k}) "Air source"
    annotation (Placement(transformation(extent={{-100,38},{-80,18}})));
  Annex60.Fluid.Sources.MassFlowSource_h sou2(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=1,
    X={mWatFloSol.k,1 - mWatFloSol.k}) "Air source"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-50}})));
  Annex60.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for adding moisture"
              annotation (Placement(transformation(extent={{-60,28},{-40,48}})));
  Annex60.Fluid.MixingVolumes.MixingVolumeMoistAir vol1(
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for adding moisture"
              annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Annex60.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium,
      nPorts=1) "Air sink"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));
  Annex60.Fluid.MixingVolumes.MixingVolumeMoistAir vol2(
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for removing moisture"
              annotation (Placement(transformation(extent={{-6,0},{14,20}})));
  Modelica.Blocks.Sources.Constant mWatFlo1(k=0.001) "Water mass flow rate 1"
    annotation (Placement(transformation(extent={{-100,50},{-90,60}})));
  Modelica.Blocks.Sources.Constant TWat(k=273.15) "Watter supply temperature"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.Constant mWatFlo3(k=-(mWatFlo1.k + mWatFlo2.k))
    "Withdrawn moisture rate"
    annotation (Placement(transformation(extent={{-40,50},{-30,60}})));
  Modelica.Blocks.Sources.Constant mWatFlo2(k=0.003) "Water mass flow rate 2"
    annotation (Placement(transformation(extent={{-100,-20},{-88,-8}})));
  Annex60.Utilities.Diagnostics.AssertEquality assertEqualityMoisture(threShold=
       1E-10, message="Water vapor mass is not conserved")
    annotation (Placement(transformation(extent={{84,-24},{98,-38}})));
  Annex60.Fluid.Sensors.MassFractionTwoPort senMasFra(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    tau=0,
    allowFlowReversal=false) "Sensor for measuring moisture"
    annotation (Placement(transformation(extent={{70,10},{90,-10}})));
protected
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium) "Fluid port for using fluid stream mixing implementation"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
         // fixme list all public instances prior to protected
public
  Modelica.Blocks.Sources.Constant mWatFloSol(k=0.01)
    "Solution mass fraction water"
    annotation (Placement(transformation(extent={{60,-40},{70,-30}})));
  Annex60.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Medium, allowFlowReversal=false) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{44,10},{64,-10}})));
  Annex60.Utilities.Diagnostics.AssertEquality assertEquality1(threShold=1E-10,
      message="Water vapor mass is not conserved")
    annotation (Placement(transformation(extent={{84,-44},{98,-58}})));
  Modelica.Blocks.Sources.Constant mFloSol(k=sou1.m_flow + sou2.m_flow)
    "Solution mass flow rate"
    annotation (Placement(transformation(extent={{60,-60},{70,-50}})));
  Annex60.Fluid.Sensors.SpecificEnthalpyTwoPort senSpeEnt(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=1,
    tau=0) "Specific enthalpy flow rate sensor"
    annotation (Placement(transformation(extent={{20,10},{40,-10}})));
  Annex60.Utilities.Diagnostics.AssertEquality assertEquality2(message="Water vapor mass is not conserved",
      threShold=1E-5)
    annotation (Placement(transformation(extent={{84,-64},{98,-78}})));
  Modelica.Blocks.Sources.Constant hSol(k=Medium.h_default)
    "Solution mass flow rate"
    annotation (Placement(transformation(extent={{60,-80},{70,-70}})));
equation
  connect(sou1.ports[1], vol.ports[1]) annotation (Line(
      points={{-80,28},{-52,28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou2.ports[1], vol1.ports[1]) annotation (Line(
      points={{-80,-40},{-52,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mWatFlo1.y, vol.mWat_flow) annotation (Line(
      points={{-89.5,55},{-62,55},{-62,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol1.TWat,TWat. y) annotation (Line(
      points={{-62,-25.2},{-68,-25.2},{-68,90},{-79,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol.TWat,TWat. y) annotation (Line(
      points={{-62,42.8},{-66,42.8},{-66,42},{-68,42},{-68,90},{-79,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatFlo3.y, vol2.mWat_flow) annotation (Line(
      points={{-29.5,55},{-8,55},{-8,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol2.TWat,TWat. y) annotation (Line(
      points={{-8,14.8},{-6,14.8},{-6,90},{-79,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatFlo2.y, vol1.mWat_flow) annotation (Line(
      points={{-87.4,-14},{-64,-14},{-64,-22},{-62,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol1.ports[2], port_a) annotation (Line(
      points={{-48,-40},{-20,-40},{-20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], port_a) annotation (Line(
      points={{-48,28},{-20,28},{-20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a, vol2.ports[1]) annotation (Line(
      points={{-20,0},{2,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFra.port_b,sin. ports[1]) annotation (Line(
      points={{90,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mWatFloSol.y, assertEqualityMoisture.u1) annotation (Line(
      points={{70.5,-35},{74,-35},{74,-35.2},{82.6,-35.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMasFlo.port_b, senMasFra.port_a) annotation (Line(
      points={{64,0},{70,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo.m_flow, assertEquality1.u2) annotation (Line(
      points={{54,-11},{54,-46.8},{82.6,-46.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol2.ports[2], senSpeEnt.port_a) annotation (Line(
      points={{6,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senSpeEnt.port_b, senMasFlo.port_a) annotation (Line(
      points={{40,0},{44,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senSpeEnt.h_out, assertEquality2.u2) annotation (Line(
      points={{30,-11},{30,-66.8},{82.6,-66.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hSol.y, assertEquality2.u1) annotation (Line(
      points={{70.5,-75},{74,-75},{74,-75.2},{82.6,-75.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mFloSol.y, assertEquality1.u1) annotation (Line(
      points={{70.5,-55},{76.25,-55},{76.25,-55.2},{82.6,-55.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assertEqualityMoisture.u2, senMasFra.X) annotation (Line(
      points={{82.6,-26.8},{80,-26.8},{80,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (                   Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    experiment(Tolerance=1e-08),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This test checks if water vapor mass is conserved. 
Two air streams with different mass flow rate are humidified 
by a mixing volume with two different vapor mass flow rates. 
These flows are then mixed. 
Afterwards the added moisture is removed. 
The final moisture concentration, mass flow rate and enthalpy 
flow rate should then be equal to the initial values.
</p>
</html>", revisions="<html>
<ul>
<li>
May 22 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoistureMixingConservation;
