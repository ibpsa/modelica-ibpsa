within IDEAS.LIDEAS.Components.BaseClasses;
model LinearAirModel
  extends IDEAS.Buildings.Components.ZoneAirModels.BaseClasses.PartialAirModel(
    TAir(stateSelect=if sim.linearise then StateSelect.prefer else StateSelect.default),
    useFluPor=not linearise and useFluPor2);
  parameter Boolean useFluPor2 = true "Set to false to remove fluid ports, overwritten by sim.linearise";
  parameter Boolean linearise = sim.linearise "Linearise model equations";

  replaceable
  IDEAS.Buildings.Components.ZoneAirModels.WellMixedAir nonLinear(
    redeclare package Medium = Medium,
    nSurf=nSurf,
    Vtot=Vtot,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    n50=n50,
    n50toAch=n50toAch,
    useFluPor=useFluPor,
    energyDynamics=energyDynamics,
    mSenFac=mSenFac,
    useAirLeakage=useAirLeakage) if                                  not linearise
    constrainedby
    IDEAS.Buildings.Components.ZoneAirModels.BaseClasses.PartialAirModel
    "Air model when not linearising"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  IDEAS.Buildings.Components.ZoneAirModels.Thermal linear(
    redeclare final package Medium = Medium,
    nSurf=nSurf,
    nSeg=nSeg,
    Vtot=Vtot,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    n50=n50,
    n50toAch=n50toAch,
    useFluPor=false,
    energyDynamics=energyDynamics,
    mSenFac=mSenFac) if                                       linearise
    "Air model when linearising"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  parameter Boolean useAirLeakage=true
    "Set to false to disable airleakage computations";
equation
  connect(E,linear.E);
  connect(E,nonLinear.E);
  connect(QGai, linear.QGai);
  connect(QGai, nonLinear.QGai);
  connect(nonLinear.port_b, port_b) annotation (Line(points={{-14,40},{-14,60},
          {-40,60},{-40,100}}, color={0,127,255}));
  connect(nonLinear.port_a, port_a) annotation (Line(points={{-6,40},{-6,60},
          {40,60},{40,100}}, color={0,127,255}));
  connect(nonLinear.inc, inc) annotation (Line(points={{-20.8,38},{-20.8,38},{-76,
          38},{-76,80},{-108,80}}, color={0,0,127}));
  connect(nonLinear.azi, azi) annotation (Line(points={{-20.8,34},{-20.8,34},{-80,
          34},{-80,40},{-108,40}}, color={0,0,127}));
  connect(linear.inc, inc) annotation (Line(points={{-20.8,-2},{-38,-2},{-76,-2},
          {-76,80},{-108,80}}, color={0,0,127}));
  connect(linear.azi, azi) annotation (Line(points={{-20.8,-6},{-34,-6},{-80,-6},
          {-80,40},{-108,40}}, color={0,0,127}));
  connect(nonLinear.A, A) annotation (Line(points={{-20.6,24},{-54,24},{-84,24},
          {-84,-60},{-106,-60}}, color={0,0,127}));
  connect(linear.A, A) annotation (Line(points={{-20.6,-16},{-84,-16},{-84,-60},
          {-106,-60}}, color={0,0,127}));
  connect(nonLinear.mWat_flow, mWat_flow) annotation (Line(points={{0.8,38},{14,
          38},{60,38},{60,80},{108,80}}, color={0,0,127}));
  connect(nonLinear.C_flow, C_flow) annotation (Line(points={{0.8,34},{34,34},{72,
          34},{72,40},{108,40}}, color={0,0,127}));
  connect(linear.mWat_flow, mWat_flow) annotation (Line(points={{0.8,-2},{62,-2},
          {62,80},{108,80}}, color={0,0,127}));
  connect(linear.C_flow, C_flow) annotation (Line(points={{0.8,-6},{72,-6},{72,40},
          {108,40}}, color={0,0,127}));
  connect(nonLinear.ports_surf, ports_surf) annotation (Line(points={{-20,30},{-90,
          30},{-90,0},{-100,0}}, color={191,0,0}));
  connect(nonLinear.ports_air, ports_air)
    annotation (Line(points={{0,30},{22,30},{22,0},{100,0}}, color={191,0,0}));
  connect(linear.ports_surf, ports_surf) annotation (Line(points={{-20,-10},{-90,
          -10},{-90,0},{-100,0}}, color={191,0,0}));
  connect(linear.ports_air, ports_air) annotation (Line(points={{0,-10},{22,-10},
          {22,0},{100,0}}, color={191,0,0}));
  connect(linear.TAir, TAir) annotation (Line(points={{0.8,-16},{12,-16},{12,-60},
          {108,-60}}, color={0,0,127}));
  connect(linear.phi, phi) annotation (Line(points={{0.8,-14},{20,-14},{20,-40},
          {108,-40}}, color={0,0,127}));
  connect(nonLinear.TAir, TAir) annotation (Line(points={{0.8,24},{12,24},{12,-60},
          {108,-60}}, color={0,0,127}));
  connect(nonLinear.phi, phi) annotation (Line(points={{0.8,26},{20,26},{20,-40},
          {108,-40}}, color={0,0,127}));
end LinearAirModel;
