within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Verification.ComparisonCPU;
model singleBoreHoleSer3Wetter
  extends Icons.VerificationModel;

  import DaPModels;
  package Medium = Buildings.Media.ConstantPropertyLiquidWater;

  parameter Data.BorefieldStepResponse.Validation_Spitler_CPU_3bhSer
    bfSteRes
    annotation (Placement(transformation(extent={{68,-66},{88,-46}})));

  Buildings.Fluid.Sources.Boundary_ph sin(redeclare package Medium = Medium,
      nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));

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
    annotation (Placement(transformation(extent={{-72,-12},{-52,8}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pum(
    redeclare package Medium = Medium,
    m_flow_nominal=bfSteRes.genStePar.m_flow,
    m_flow(start=bfSteRes.genStePar.m_flow),
    T_start=bfSteRes.genStePar.T_ini)
    annotation (Placement(transformation(extent={{-20,30},{-40,10}})));

  Modelica.SIunits.Temperature T_sup "water supply temperature";
  Modelica.SIunits.Temperature T_ret "water return temperature";

  Modelica.SIunits.Temperature T_f "average fluid temperature";
  Modelica.SIunits.Temperature T_b "borehole wall temperature";

  Modelica.Blocks.Sources.CombiTimeTable lamarcheProfiel(
    tableOnFile=true,
    tableName="data",
    fileName=
        "E:/work/modelica/VerificationData/Bertagnolio/DataBertagnolio/q30asym_time.txt",
    offset={0},
    columns={2})
    annotation (Placement(transformation(extent={{68,-6},{48,14}})));

  Buildings.Fluid.HeatExchangers.Boreholes.UTube borHol(
    redeclare each package Medium = Medium,
    hBor=bfSteRes.bfGeo.hBor,
    dp_nominal=10000,
    dT_dz=bfSteRes.adv.dT_dz,
    samplePeriod=bfSteRes.adv.samplePeriod,
    m_flow_nominal=bfSteRes.adv.m_flow_nominal,
    redeclare each Buildings.HeatTransfer.Data.Soil.Sandstone matFil(k=bfSteRes.bhFil.k, c=bfSteRes.bhFil.c, d=bfSteRes.bhFil.d),
    redeclare Buildings.HeatTransfer.Data.Soil.Sandstone matSoi(k=bfSteRes.soi.k, c=bfSteRes.soi.c, d=bfSteRes.soi.d),
    T_start=bfSteRes.adv.TExt0_start,
    TExt0_start=bfSteRes.adv.TExt0_start,
    TFil0_start=bfSteRes.adv.TFil0_start,
    rTub=bfSteRes.bfGeo.rTub,
    kTub=bfSteRes.bfGeo.kTub,
    eTub=bfSteRes.bfGeo.eTub,
    nVer=bfSteRes.adv.nVer,
    rBor=bfSteRes.bfGeo.rBor,
    rExt=bfSteRes.adv.rExt,
    nHor=bfSteRes.adv.nHor,
    TFil_start=bfSteRes.adv.TExt_start,
    xC=bfSteRes.bfGeo.xC) "Borehole heat exchanger"
    annotation (Placement(transformation(extent={{-56,-66},{-24,-34}},
                                                                    rotation=0)));
  Buildings.Fluid.HeatExchangers.Boreholes.UTube borHol1(
    redeclare each package Medium = Medium,
    hBor=bfSteRes.bfGeo.hBor,
    dp_nominal=10000,
    dT_dz=bfSteRes.adv.dT_dz,
    samplePeriod=bfSteRes.adv.samplePeriod,
    m_flow_nominal=bfSteRes.adv.m_flow_nominal,
    redeclare each Buildings.HeatTransfer.Data.Soil.Sandstone matFil(k=bfSteRes.bhFil.k, c=bfSteRes.bhFil.c, d=bfSteRes.bhFil.d),
    redeclare Buildings.HeatTransfer.Data.Soil.Sandstone matSoi(k=bfSteRes.soi.k, c=bfSteRes.soi.c, d=bfSteRes.soi.d),
    T_start=bfSteRes.adv.TExt0_start,
    TExt0_start=bfSteRes.adv.TExt0_start,
    TFil0_start=bfSteRes.adv.TFil0_start,
    rTub=bfSteRes.bfGeo.rTub,
    kTub=bfSteRes.bfGeo.kTub,
    eTub=bfSteRes.bfGeo.eTub,
    nVer=bfSteRes.adv.nVer,
    rBor=bfSteRes.bfGeo.rBor,
    rExt=bfSteRes.adv.rExt,
    nHor=bfSteRes.adv.nHor,
    TFil_start=bfSteRes.adv.TExt_start,
    xC=bfSteRes.bfGeo.xC) "Borehole heat exchanger"
    annotation (Placement(transformation(extent={{-16,-66},{16,-34}},
                                                                    rotation=0)));
  Buildings.Fluid.HeatExchangers.Boreholes.UTube borHol2(
    redeclare each package Medium = Medium,
    hBor=bfSteRes.bfGeo.hBor,
    dp_nominal=10000,
    dT_dz=bfSteRes.adv.dT_dz,
    samplePeriod=bfSteRes.adv.samplePeriod,
    m_flow_nominal=bfSteRes.adv.m_flow_nominal,
    redeclare each Buildings.HeatTransfer.Data.Soil.Sandstone matFil(k=bfSteRes.bhFil.k, c=bfSteRes.bhFil.c, d=bfSteRes.bhFil.d),
    redeclare Buildings.HeatTransfer.Data.Soil.Sandstone matSoi(k=bfSteRes.soi.k, c=bfSteRes.soi.c, d=bfSteRes.soi.d),
    T_start=bfSteRes.adv.TExt0_start,
    TExt0_start=bfSteRes.adv.TExt0_start,
    TFil0_start=bfSteRes.adv.TFil0_start,
    rTub=bfSteRes.bfGeo.rTub,
    kTub=bfSteRes.bfGeo.kTub,
    eTub=bfSteRes.bfGeo.eTub,
    nVer=bfSteRes.adv.nVer,
    rBor=bfSteRes.bfGeo.rBor,
    rExt=bfSteRes.adv.rExt,
    nHor=bfSteRes.adv.nHor,
    TFil_start=bfSteRes.adv.TExt_start,
    xC=bfSteRes.bfGeo.xC) "Borehole heat exchanger"
    annotation (Placement(transformation(extent={{24,-66},{56,-34}},rotation=0)));
equation
  T_sup = borHol.sta_a.T;
  T_ret = borHol2.sta_b.T;
  T_f = (T_sup + T_ret)/2;
  T_b = borHol.borHol[1].pipFil.port.T;
  connect(mFlo.y, pum.m_flow_in) annotation (Line(
      points={{-51,-2},{-29.8,-2},{-29.8,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_a, hea.port_b) annotation (Line(
      points={{-20,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hea.port_a, sin.ports[1]) annotation (Line(
      points={{40,20},{74,20},{74,-10},{10,-10}},
      color={0,127,255},
      smooth=Smooth.None));

  lamarcheProfiel.y[1]/430 = hea.u annotation (Line(
      points={{69,40},{48,40},{48,26},{42,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(borHol.port_b, borHol1.port_a) annotation (Line(
      points={{-24,-50},{-20,-50},{-20,-50},{-16,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(borHol1.port_b, borHol2.port_a) annotation (Line(
      points={{16,-50},{24,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(borHol2.port_b, hea.port_a) annotation (Line(
      points={{56,-50},{66,-50},{66,-20},{74,-20},{74,20},{40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pum.port_b, borHol.port_a) annotation (Line(
      points={{-40,20},{-80,20},{-80,-40},{-60,-40},{-60,-50},{-56,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/Examples/UTube.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{
            100,40}}), graphics),
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
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,
            40}}), graphics));
end singleBoreHoleSer3Wetter;
