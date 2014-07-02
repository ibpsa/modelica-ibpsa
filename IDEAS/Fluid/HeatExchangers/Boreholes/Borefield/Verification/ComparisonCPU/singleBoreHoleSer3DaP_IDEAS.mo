within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Verification.ComparisonCPU;
model singleBoreHoleSer3DaP_IDEAS
  /* BAD HACK: careful: the power input = q_ste * hBor. The number of borehole is not taken into account.*/
  extends Icons.VerificationModel;

  import DaPModels;
  package MediumBuildings = Buildings.Media.ConstantPropertyLiquidWater;
  parameter IDEAS.Thermal.Data.Media.WaterBuildingsLib mediumIDEAS;

  parameter Data.BorefieldStepResponse.Validation_Spitler_CPU_3bhSer
    bfSteRes
    annotation (Placement(transformation(extent={{38,-98},{58,-78}})));
  parameter Integer lenSim=3600*24*50;

  Modelica.Blocks.Sources.Constant mFlo(k=1)
    annotation (Placement(transformation(extent={{-52,-58},{-32,-38}})));

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

  Borefield.MultipleBoreHoles_IDEAS mulBor(lenSim=lenSim, bfSteRes=
        bfSteRes,final medium = mediumIDEAS) annotation (Placement(transformation(
        extent={{-19,18},{19,-18}},
        rotation=180,
        origin={-1,-76})));
  IDEAS.Thermal.Components.BaseClasses.Pump pump(
    useInput=true,
    medium=mediumIDEAS,
    m=0.1,
    TInitial=bfSteRes.genStePar.T_ini,
    m_flowNom=bfSteRes.genStePar.m_flow,
    dpFix=0,
    etaTot=1,
    m_flowSet(start=bfSteRes.genStePar.m_flow))
    annotation (Placement(transformation(extent={{-18,-10},{-38,-30}})));
  IDEAS.Thermal.Components.Production.IdealHeater idealHeater(medium=mediumIDEAS)
    annotation (Placement(transformation(
        extent={{-10,11},{10,-11}},
        rotation=-90,
        origin={0,-11})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{36,-18},{16,2}})));
  Modelica.Blocks.Sources.RealExpression heatLossHea(y = 0)
    annotation (Placement(transformation(extent={{60,-16},{46,-2}})));
  Modelica.Blocks.Sources.RealExpression QFlowHP( y = heatLoadHPVal)
    annotation (Placement(transformation(extent={{18,-36},{4,-22}})));

protected
    Modelica.SIunits.HeatFlowRate heatLoadHPVal "Heat load of the HP";
public
  Modelica.Blocks.Math.Product product annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-2,-48})));
  Modelica.Blocks.Sources.RealExpression inv(y=-1)
    annotation (Placement(transformation(extent={{18,-44},{4,-30}})));
equation
  T_sup = mulBor.T_hcf_in;
  T_ret = mulBor.T_hcf_out;
  T_f = mulBor.T_fts;

  lamarcheProfiel.y[1]/10*bfSteRes.bfGeo.hBor*bfSteRes.bfGeo.nbBh = heatLoadHPVal
    "nominal heater power";

  connect(pump.flowPort_b, mulBor.flowPort_a) annotation (Line(
      points={{-38,-20},{-60,-20},{-60,-76},{-20,-76}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(idealHeater.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{-2,-20},{-18,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(idealHeater.flowPort_a, mulBor.flowPort_b) annotation (Line(
      points={{3.8,-20},{56,-20},{56,-76},{18,-76}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(idealHeater.heatPort, prescribedHeatFlow.port) annotation (Line(
      points={{10,-7},{14,-7},{14,-8},{16,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatLossHea.y, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{45.3,-9},{40.65,-9},{40.65,-8},{36,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QFlowHP.y, idealHeater.TSet) annotation (Line(
      points={{3.3,-29},{-14,-29},{-14,-9},{-12,-9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mFlo.y, pump.m_flowSet) annotation (Line(
      points={{-31,-48},{-28,-48},{-28,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, mulBor.Q_flow) annotation (Line(
      points={{-2,-54.6},{-2,-60},{-2,-64.9429},{-1,-64.9429}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QFlowHP.y, product.u2) annotation (Line(
      points={{3.3,-29},{-5.6,-29},{-5.6,-40.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(inv.y, product.u1) annotation (Line(
      points={{3.3,-37},{1.6,-37},{1.6,-40.8}},
      color={0,0,127},
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
end singleBoreHoleSer3DaP_IDEAS;
