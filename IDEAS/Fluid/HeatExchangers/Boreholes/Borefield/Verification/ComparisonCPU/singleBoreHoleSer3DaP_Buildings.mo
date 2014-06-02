within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Verification.ComparisonCPU;
model singleBoreHoleSer3DaP_Buildings
  /* BAD HACK: careful: the power input = q_ste * hBor. The number of borehole is not taken into account.*/
  extends Icons.VerificationModel;

  import DaPModels;
  package Medium = Buildings.Media.ConstantPropertyLiquidWater;

  parameter Data.BorefieldStepResponse.Validation_Spitler_CPU_3bhSer
    bfSteRes
    annotation (Placement(transformation(extent={{38,-98},{58,-78}})));
  parameter Integer lenSim=3600*24*50;

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
    annotation (Placement(transformation(extent={{30,-32},{10,-12}})));
  Modelica.Blocks.Sources.Constant mFlo(k=bfSteRes.genStePar.m_flow)
    annotation (Placement(transformation(extent={{-52,-58},{-32,-38}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pum(
    redeclare package Medium = Medium,
    m_flow_nominal=bfSteRes.genStePar.m_flow,
    m_flow(start=bfSteRes.genStePar.m_flow),
    T_start=bfSteRes.genStePar.T_ini)
    annotation (Placement(transformation(extent={{-10,-12},{-30,-32}})));

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
    annotation (Placement(transformation(extent={{50,-60},{30,-40}})));

  Borefield.MultipleBoreHoles_Buildings mulBor(lenSim=lenSim, bfSteRes=
        bfSteRes, redeclare final package Medium = Medium)  annotation (Placement(transformation(
        extent={{-19,18},{19,-18}},
        rotation=180,
        origin={-1,-76})));
equation
  T_sup = mulBor.T_hcf_in;
  T_ret = mulBor.T_hcf_out;
  T_f = mulBor.T_fts;
  connect(mFlo.y, pum.m_flow_in) annotation (Line(
      points={{-31,-48},{-19.8,-48},{-19.8,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_a, hea.port_b) annotation (Line(
      points={{-10,-22},{10,-22}},
      color={0,127,255},
      smooth=Smooth.None));

  lamarcheProfiel.y[1]/430 = hea.u "nominal heater power";
  lamarcheProfiel.y[1]/10*bfSteRes.bfGeo.hBor*bfSteRes.bfGeo.nbBh = -mulBor.Q_flow;

  connect(pum.port_b, mulBor.flowPort_a) annotation (Line(
      points={{-30,-22},{-58,-22},{-58,-76},{-20,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, mulBor.flowPort_b) annotation (Line(
      points={{30,-22},{58,-22},{58,-76},{18,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/Examples/UTube.mos"
        "Simulate and plot", file="../Scripts/PlotCPUTest_WetterDaP.mos"
        "PlotCPUTest_WetterDaP"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                     graphics),
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
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics));
end singleBoreHoleSer3DaP_Buildings;
