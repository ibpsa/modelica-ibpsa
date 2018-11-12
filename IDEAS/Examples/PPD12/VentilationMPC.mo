within IDEAS.Examples.PPD12;
model VentilationMPC
  "PPD12 model using off-line computed model predictive controller results"
  extends BaseClasses.VentilationNoControl(pump(inputType=IDEAS.Fluid.Types.InputType.Constant));
  Modelica.Blocks.Sources.CombiTimeTable MPCResults(
    tableOnFile=true,
    tableName="csv",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://IDEAS/Resources/Data/PPD12_MPC.csv"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    columns={2,3,4,5,6,7,8,9}) "Table reader for off-line computed mpc results"
    annotation (Placement(transformation(extent={{-100,180},{-60,220}})));

  Modelica.SIunits.Energy EGas "Total gas energy use";
  Modelica.Blocks.Continuous.Integrator EHea(k=1/3600000) "Heater energy"
    annotation (Placement(transformation(extent={{360,-60},{380,-40}})));
initial equation
  EGas=0;
equation
  der(EGas)=QGas/3600000;

  connect(MPCResults.y[1], hea.TSet) annotation (Line(points={{-58,200},{372,
          200},{372,-102}}, color={0,0,127}));
  connect(MPCResults.y[2], fanRet.m_flow_in) annotation (Line(points={{-58,200},
          {22,200},{22,224},{350,224},{350,202}}, color={0,0,127}));
  connect(MPCResults.y[3], fanSup.m_flow_in) annotation (Line(points={{-58,200},
          {24,200},{24,222},{350,222},{350,140}}, color={0,0,127}));
  connect(MPCResults.y[4], bypassRet.ctrl) annotation (Line(points={{-58,200},{
          38,200},{38,200.8},{310,200.8}}, color={0,0,127}));
  connect(bypassSup.ctrl, bypassRet.ctrl) annotation (Line(points={{310,119.2},
          {310,116},{320,116},{320,200.8},{310,200.8}}, color={0,0,127}));
  connect(EHea.u, hea.Q_flow) annotation (Line(points={{358,-50},{349,-50},{349,
          -102}}, color={0,0,127}));
  annotation (experiment(
      StopTime=31500000,
      __Dymola_NumberOfIntervals=15000,
      __Dymola_fixedstepsize=15,
      __Dymola_Algorithm="Euler"));
end VentilationMPC;
