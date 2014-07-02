within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Verification.ComparisonCPU;
model singleBoreHoleDaP
  /* BAD HACK: careful: the power input = q_ste * hBor. The number of borehole is not taken into account.*/
  extends Icons.VerificationModel;

  import DaPModels;
  package Medium = Buildings.Media.ConstantPropertyLiquidWater;

  parameter Data.BorefieldStepResponse.Validation_Spitler_CPU bfSteRes
    annotation (Placement(transformation(extent={{-64,78},{-44,98}})));
  parameter Integer lenSim=3600*24*365*20;

  Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed hea(
    redeclare package Medium = Medium,
    m_flow_nominal=bfSteRes.genStePar.m_flow,
    dp_nominal=10000,
    Q_flow_nominal=430/10*bfSteRes.bfGeo.hBor*bfSteRes.bfGeo.nbBh,
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

  Modelica.SIunits.Temperature T_f "average fluid temperature";

  Modelica.Blocks.Sources.CombiTimeTable lamarcheProfiel(
    tableOnFile=true,
    tableName="data",
    fileName=
        "E:/work/modelica/VerificationData/Bertagnolio/DataBertagnolio/q30asym_time.txt",
    offset={0},
    columns={2})
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Borefield.MultipleBoreHoles_Buildings multipleBoreholes(lenSim=
        lenSim, bfSteRes=bfSteRes) annotation (Placement(transformation(
        extent={{-22,22},{22,-22}},
        rotation=180,
        origin={0,-68})));
equation
  T_sup = multipleBoreholes.T_hcf_in;
  T_ret = multipleBoreholes.T_hcf_out;
  T_f = multipleBoreholes.T_fts;
  connect(mFlo.y, pum.m_flow_in) annotation (Line(
      points={{-69,50},{-29.8,50},{-29.8,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_a, hea.port_b) annotation (Line(
      points={{-20,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));

  lamarcheProfiel.y[1]/430 = hea.u;
  lamarcheProfiel.y[1]/10*bfSteRes.bfGeo.hBor*bfSteRes.bfGeo.nbBh = -
    multipleBoreholes.Q_flow;

  connect(multipleBoreholes.flowPort_b, hea.port_a) annotation (Line(
      points={{22,-68},{80,-68},{80,20},{40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_b, multipleBoreholes.flowPort_a) annotation (Line(
      points={{-40,20},{-80,20},{-80,-68},{-22,-68}},
      color={0,127,255},
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
</html>",
        revisions="<html>
<ul>
</ul>
</html>"),
    experiment(
      StopTime=6.307e+008,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end singleBoreHoleDaP;
