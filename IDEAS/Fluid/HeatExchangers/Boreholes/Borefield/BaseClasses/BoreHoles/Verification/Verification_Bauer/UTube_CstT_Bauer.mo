within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.BoreHoles.Verification.Verification_Bauer;
model UTube_CstT_Bauer "Cst T load"
  /* BAD HACK: careful: the power input = q_ste * hBor. The number of borehole is not taken into account.*/
  extends Icons.VerificationModel;

  import DaPModels;
  package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  inner Modelica.Fluid.System system(T_ambient=bfSteRes.adv.T_ambient)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  parameter Data.BorefieldStepResponse.Validation_Bauer bfSteRes
    annotation (Placement(transformation(extent={{-10,78},{10,98}})));
  parameter Modelica.SIunits.Temperature Thigh=273.15 + 80;
  parameter Modelica.SIunits.Temperature Tlow=273.15 + 40;

  BaseClasses.BoreHoleSegmentFourPort borHol[bfSteRes.adv.nVer](
    redeclare each final package Medium = Medium,
    each final matSoi=bfSteRes.soi,
    each final matFil=bfSteRes.bhFil,
    each final bfGeo=bfSteRes.bfGeo,
    each final genStePar=bfSteRes.genStePar,
    each final adv=bfSteRes.adv,
    final dp_nominal={if i == 1 then 0 else 0 for i in 1:bfSteRes.adv.nVer},
    TExt_start=bfSteRes.adv.TExt_start,
    TFil_start=bfSteRes.adv.TExt_start,
    each final homotopyInitialization=true,
    each final show_T=false,
    each final computeFlowResistance=true,
    each final from_dp=false,
    each final linearizeFlowResistance=false,
    each final deltaM=0.1,
    each final energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    each final massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    "Discretized borehole segments"
    annotation (Placement(transformation(extent={{-18,-32},{18,4}})));

  Modelica.Blocks.Sources.Constant mFlo(k=bfSteRes.genStePar.m_flow)
    annotation (Placement(transformation(extent={{-94,36},{-74,56}})));

  Buildings.Fluid.Sources.Boundary_ph sinLow(redeclare package Medium = Medium,
      nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Fluid.Sources.Boundary_ph sinHigh(redeclare package Medium = Medium,
      nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{62,10},{42,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T highT(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=Thigh) "Source"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T lowT(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=Tlow) "Source"
    annotation (Placement(transformation(extent={{62,-50},{42,-30}})));

  Modelica.SIunits.HeatFlowRate Q_fg1Fg2;
  Modelica.SIunits.HeatFlowRate Q_fg1;
  Modelica.SIunits.HeatFlowRate Q_fg2;

equation
  Q_fg1 = borHol[1].intHEX.Rpg1.port_a.Q_flow;
  Q_fg2 = borHol[1].intHEX.Rpg2.port_a.Q_flow;
  Q_fg1Fg2 = Q_fg1 + Q_fg2;

  connect(sinLow.ports[1], borHol[1].port_b2) annotation (Line(
      points={{-40,-40},{-30,-40},{-30,-24.8},{-18,-24.8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinHigh.ports[1], borHol[1].port_b1) annotation (Line(
      points={{42,20},{32,20},{32,-3.2},{18,-3.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(highT.ports[1], borHol[1].port_a1) annotation (Line(
      points={{-40,10},{-32,10},{-32,-3.2},{-18,-3.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mFlo.y, highT.m_flow_in) annotation (Line(
      points={{-73,46},{-68,46},{-68,18},{-60,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lowT.ports[1], borHol[1].port_a2) annotation (Line(
      points={{42,-40},{30,-40},{30,-24.8},{18,-24.8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mFlo.y, lowT.m_flow_in) annotation (Line(
      points={{-73,46},{80,46},{80,-32},{62,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/Examples/UTube.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experimentSetupOutput,
    Diagram,
    Documentation(info="<html>
<p>

</p>
</html>", revisions="<html>
<ul>
</ul>
</html>"),
    experiment(
      StopTime=10800,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end UTube_CstT_Bauer;
