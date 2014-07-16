within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.BaseClasses.BoreHoles.Verification.Verification_Spitler_WetterDaP;
model borHol_Spitler "UTube with step input load "
  /* BAD HACK: careful: the power input = q_ste * hBor. The number of borehole is not taken into account.*/
  extends Icons.VerificationModel;

  import DaPModels;
  package Medium = Buildings.Media.ConstantPropertyLiquidWater;
  inner Modelica.Fluid.System system(T_ambient=bfSteRes.adv.T_ambient)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  parameter Data.BorefieldStepResponse.Validation_Spitler_DaPWetter bfSteRes
    annotation (Placement(transformation(extent={{-64,78},{-44,98}})));

  Modelica.Blocks.Sources.Step step(height=1)
    annotation (Placement(transformation(extent={{88,32},{68,52}})));

  SingleBoreHolesInSerie borHolSer(
    redeclare each package Medium = Medium,
    matSoi=bfSteRes.soi,
    matFil=bfSteRes.bhFil,
    bfGeo=bfSteRes.bfGeo,
    adv=bfSteRes.adv,
    dp_nominal=10000,
    m_flow_nominal=bfSteRes.genStePar.m_flow,
    T_start=bfSteRes.genStePar.T_ini) "Borehole heat exchanger" annotation (
      Placement(transformation(extent={{-16,-76},{16,-44}}, rotation=0)));

  Buildings.Fluid.Sources.Boundary_ph sin(redeclare package Medium = Medium,
      nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));

  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hea(
    redeclare package Medium = Medium,
    m_flow_nominal=bfSteRes.genStePar.m_flow,
    dp_nominal=10000,
    Q_flow_nominal=bfSteRes.genStePar.q_ste*bfSteRes.bfGeo.hBor,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    m_flow(start=bfSteRes.genStePar.m_flow),
    T_start=bfSteRes.genStePar.T_ini,
    p_start=100000)
    annotation (Placement(transformation(extent={{40,10},{20,30}})));
  Modelica.Blocks.Sources.Constant mFlo(k=bfSteRes.genStePar.m_flow)
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pum(
    redeclare package Medium = Medium,
    m_flow_nominal=bfSteRes.genStePar.m_flow,
    m_flow(start=bfSteRes.genStePar.m_flow),
    T_start=bfSteRes.genStePar.T_ini)
    annotation (Placement(transformation(extent={{-20,10},{-40,30}})));

  Modelica.SIunits.Temperature T_sup "water supply temperature";
  Modelica.SIunits.Temperature T_ret "water return temperature";
  Modelica.SIunits.Temperature T_b "borehole wall temperature";
  Modelica.SIunits.Temperature T_f "average fluid temperature";
  Modelica.SIunits.TemperatureDifference deltaT_fb
    "temperature difference between T_f and T_b";

equation
  T_sup = borHolSer.sta_a.T;
  T_ret = borHolSer.sta_b.T;
  T_b = borHolSer.borHol[1].borHolSeg[1].intHEX.port.T;
  T_f = (T_sup + T_ret)/2;
  deltaT_fb = T_f - T_b;
  connect(mFlo.y, pum.m_flow_in) annotation (Line(
      points={{-69,50},{-29.8,50},{-29.8,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_b, borHolSer.port_a) annotation (Line(
      points={{-40,20},{-60,20},{-60,-60},{-16,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_a, hea.port_b) annotation (Line(
      points={{-20,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, borHolSer.port_b) annotation (Line(
      points={{40,20},{60,20},{60,-60},{16,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, sin.ports[1]) annotation (Line(
      points={{40,20},{60,20},{60,-20},{70,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, hea.u) annotation (Line(
      points={{67,42},{60,42},{60,26},{42,26}},
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
      StopTime=186350,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end borHol_Spitler;
