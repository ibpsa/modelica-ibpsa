within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Verification;
model singleBoreHoleSer3DaPWithHP
  /* BAD HACK: careful: the power input = q_ste * hBor. The number of borehole is not taken into account.*/
  extends Icons.VerificationModel;

  import DaPModels;
  parameter IDEAS.Thermal.Data.Media.WaterBuildingsLib medium;

  parameter Data.BorefieldStepResponse.Validation_bertagnolio_MB_A2x1
    bfSteRes
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  parameter Integer lenSim=3600*24*50;

  Modelica.Blocks.Sources.Constant mFlo(k=1)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

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
    annotation (Placement(transformation(extent={{52,-12},{32,8}})));

  Borefield.MultipleBoreHoles_IDEAS mulBor(lenSim=lenSim, bfSteRes=
        bfSteRes,final medium = medium) annotation (Placement(transformation(
        extent={{-19,18},{19,-18}},
        rotation=180,
        origin={1,-28})));
  IDEAS.Thermal.Components.BaseClasses.Pump pump(
    useInput=true,
    medium=medium,
    TInitial=bfSteRes.genStePar.T_ini,
    m_flowNom=bfSteRes.genStePar.m_flow,
    dpFix=0,
    etaTot=1,
    m_flowSet(start=bfSteRes.genStePar.m_flow),
    m=0.1)
    annotation (Placement(transformation(extent={{-16,38},{-36,18}})));

protected
    Modelica.SIunits.HeatFlowRate heatLoadHPVal "Heat load of the HP";
public
  IDEAS.Thermal.Components.BaseClasses.Pump pump1(
    medium=medium,
    TInitial=bfSteRes.genStePar.T_ini,
    dpFix=0,
    etaTot=1,
    m_flowSet(start=bfSteRes.genStePar.m_flow),
    useInput=false,
    m=0.001,
    m_flowNom=0.01)
    annotation (Placement(transformation(extent={{-22,86},{-42,66}})));
  Modelica.Blocks.Sources.RealExpression T_HP_set(y=303.15)
    annotation (Placement(transformation(extent={{74,48},{60,62}})));
  IDEAS.Thermal.Components.BaseClasses.Ambient ambient(medium=medium,
      constantAmbientPressure=100000)
    annotation (Placement(transformation(extent={{-66,38},{-86,58}})));
  Extended_IDEAS.HeatPump_BrineWater heatPump_BrineWater(
    give_Q_flow=true,
    mediumCond=medium,
    mediumEvap=medium,
    mMedEva=10,
    mMedCond=10)
    annotation (Placement(transformation(extent={{16,28},{-4,48}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort pipe_HeatPort(m=2, medium=
        medium)
    annotation (Placement(transformation(extent={{10,86},{-10,66}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{54,82},{40,96}})));
  Modelica.Blocks.Sources.RealExpression QFlowHP1(y=283.15)
    annotation (Placement(transformation(extent={{74,82},{60,96}})));
  IDEAS.Thermal.Components.BaseClasses.MixingVolume stor_emi(
    medium=medium,
    m=100,
    TInitial=293.15) "storage tank at emission side"
    annotation (Placement(transformation(extent={{-64,76},{-44,96}})));
  IDEAS.Thermal.Components.BaseClasses.MixingVolume sto_pro(
    medium=medium,
    m=1000,
    TInitial=283.15) "storage tank at production side" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-68,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor(R=
        100) annotation (Placement(transformation(extent={{30,82},{16,96}})));
equation
  T_sup = mulBor.T_hcf_in;
  T_ret = mulBor.T_hcf_out;
  T_f = mulBor.T_fts;

  lamarcheProfiel.y[1]/10*bfSteRes.bfGeo.hBor*bfSteRes.bfGeo.nbBh = heatLoadHPVal
    "nominal heater power";

  connect(mFlo.y, pump.m_flowSet) annotation (Line(
      points={{-29,0},{-26,0},{-26,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatPump_BrineWater.flowPort_b1, pump.flowPort_a) annotation (Line(
      points={{0,28.2},{-8,28.2},{-8,28},{-16,28}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heatPump_BrineWater.flowPort_a1, mulBor.flowPort_b) annotation (Line(
      points={{12,28},{60,28},{60,-28},{20,-28}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(ambient.flowPort, heatPump_BrineWater.flowPort_b) annotation (Line(
      points={{-66,48},{0,48}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heatPump_BrineWater.Q_flow_borefield, mulBor.Q_flow) annotation (Line(
      points={{6,27.6},{6,6},{1,6},{1,-16.9429}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe_HeatPort.flowPort_b, pump1.flowPort_a) annotation (Line(
      points={{-10,76},{-22,76}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort.flowPort_a, heatPump_BrineWater.flowPort_a) annotation (
     Line(
      points={{10,76},{26,76},{26,48},{12,48}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(QFlowHP1.y, prescribedTemperature.T) annotation (Line(
      points={{59.3,89},{55.4,89}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_HP_set.y, heatPump_BrineWater.T_eva_out_set) annotation (Line(
      points={{59.3,55},{6,55},{6,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump1.flowPort_b, stor_emi.flowPorts[1]) annotation (Line(
      points={{-42,76},{-48,76},{-48,75.5},{-54,75.5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(stor_emi.flowPorts[2], heatPump_BrineWater.flowPort_b) annotation (
      Line(
      points={{-54,76.5},{-54,48},{0,48}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump.flowPort_b, sto_pro.flowPorts[1]) annotation (Line(
      points={{-36,28},{-57.5,28},{-57.5,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sto_pro.flowPorts[2], mulBor.flowPort_a) annotation (Line(
      points={{-58.5,0},{-58.5,-30},{-18,-30},{-18,-28}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(thermalResistor.port_a, prescribedTemperature.port) annotation (Line(
      points={{30,89},{40,89}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalResistor.port_b, pipe_HeatPort.heatPort) annotation (Line(
      points={{16,89},{8,89},{8,90},{0,90},{0,86}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Boreholes/Examples/UTube.mos"
        "Simulate and plot", file="../Scripts/PlotCPUTest_WetterDaP.mos"
        "PlotCPUTest_WetterDaP"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
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
      StopTime=4.32e+006,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-005,
      __Dymola_Algorithm="Dassl"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics));
end singleBoreHoleSer3DaPWithHP;
