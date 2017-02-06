within IDEAS.Airflow.VentilationUnit.Examples;
model AdsolairDatasheetValidationSummer
  extends
    IDEAS.Airflow.VentilationUnit.Examples.PartialAdsolairValidation(
      menergaAdsolairValidationModel(use_onOffSignal=false, adCrFlHe(volBot(
            energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial),
          mFloAdiBot(y=(IDEAS.Utilities.Psychrometrics.Functions.X_pSatpphi(
              pSat=IDEAS.Media.Air.saturationPressure(Tbot.T),
              p=menergaAdsolairValidationModel.adCrFlHe.port_a2.p,
              phi=0.75) - menergaAdsolairValidationModel.adCrFlHe.Xw_in_bot)*
              menergaAdsolairValidationModel.adCrFlHe.port_a2.m_flow))),
      sinkAir);
  Modelica.Blocks.Sources.Constant T_room(k=273.15 + 26.4)
    annotation (Placement(transformation(extent={{-114,20},{-100,34}})));
  Modelica.Blocks.Sources.Constant RH_room(k=0.54)
    annotation (Placement(transformation(extent={{-114,0},{-100,14}})));
  Modelica.Blocks.Sources.Constant V_flow_room(k=14200/3600)
    annotation (Placement(transformation(extent={{-114,42},{-100,56}})));
  Solarwind.Utilities.Psychrometrics.X_pTphi
                                   XiEnv1(
                                         use_p_in=false)
    annotation (Placement(transformation(extent={{68,-2},{56,10}})));
  Modelica.Blocks.Sources.Constant RH_env(k=0.4)
    annotation (Placement(transformation(extent={{94,0},{80,14}})));
  Modelica.Blocks.Sources.Constant T_env(k=273.15 + 32)
    annotation (Placement(transformation(extent={{94,20},{80,34}})));
  Modelica.Blocks.Sources.Constant V_flow_env(k=14493/3600)
    annotation (Placement(transformation(extent={{94,40},{80,54}})));
  Modelica.Blocks.Sources.Constant dp_set(k=270)
    annotation (Placement(transformation(extent={{-40,60},{-26,74}})));
  Modelica.Blocks.Sources.Constant T_set(k=273.15 + 16.7)
    annotation (Placement(transformation(extent={{-40,80},{-26,94}})));
  Modelica.Blocks.Sources.Constant RH_evap(k=0.87)
    annotation (Placement(transformation(extent={{-78,-76},{-64,-62}})));
  Modelica.Blocks.Sources.Constant Q_evap(k=40040)
    annotation (Placement(transformation(extent={{-78,-98},{-64,-84}})));
  Modelica.Blocks.Sources.Constant T_cond(k=273.15 + 35.2)
    annotation (Placement(transformation(extent={{-40,-76},{-26,-62}})));
  Modelica.Blocks.Sources.Constant Q_cond(k=46700)
    annotation (Placement(transformation(extent={{-40,-98},{-26,-84}})));
  IDEAS.Utilities.Psychrometrics.Phi_pTX phi_evap
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=
        menergaAdsolairValidationModel.evaporator.T)
    annotation (Placement(transformation(extent={{-8,-70},{58,-54}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=
        menergaAdsolairValidationModel.evaporator.Xi[1])
    annotation (Placement(transformation(extent={{-8,-78},{58,-62}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=101300)
    annotation (Placement(transformation(extent={{-8,-86},{58,-70}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Tbot(T=273.15 + 21.4)
    annotation (Placement(transformation(extent={{-70,48},{-50,68}})));
  Real relHumIn= IDEAS.Utilities.Psychrometrics.Functions.phi_pTX(
    p=menergaAdsolairValidationModel.adCrFlHe.volBot.ports[1].p,
    T=menergaAdsolairValidationModel.adCrFlHe.volBot.heatPort.T,
    X_w=menergaAdsolairValidationModel.adCrFlHe.volBot.ports[1].Xi_outflow[1]);
equation
  connect(Tbot.port,menergaAdsolairValidationModel.adCrFlHe.volBot.heatPort);
  connect(RH_room.y, XiEnv.phi) annotation (Line(points={{-99.3,7},{-94,7},{-94,
          4.4},{-87.2,4.4}}, color={0,0,127}));
  connect(T_room.y, XiEnv.T) annotation (Line(points={{-99.3,27},{-94,27},{-94,
          8},{-87.2,8}}, color={0,0,127}));
  connect(V_flow_room.y, mflow_VflowTop2.V_flow) annotation (Line(points={{
          -99.3,49},{-88,49},{-88,25},{-84.2,25}}, color={0,0,127}));
  connect(environment.T_in, mflow_VflowBot2.T)
    annotation (Line(points={{40,12},{66.3,12},{66.3,17}}, color={0,0,127}));
  connect(XiEnv1.X, environment.X_in)
    annotation (Line(points={{55.4,4},{40,4},{40,4}}, color={0,0,127}));
  connect(XiEnv1.T, mflow_VflowBot2.T) annotation (Line(points={{69.2,4},{70,4},
          {70,14},{70,17},{66.3,17}}, color={0,0,127}));
  connect(T_env.y, mflow_VflowBot2.T) annotation (Line(points={{79.3,27},{74,27},
          {74,17},{66.3,17}}, color={0,0,127}));
  connect(XiEnv1.phi, RH_env.y) annotation (Line(points={{69.2,0.4},{76,0.4},{
          76,7},{79.3,7}}, color={0,0,127}));
  connect(V_flow_env.y, mflow_VflowBot2.V_flow)
    annotation (Line(points={{79.3,47},{66.2,47},{66.2,21}}, color={0,0,127}));
  connect(dp_set.y, menergaAdsolairValidationModel.dpSet[1]) annotation (Line(
        points={{-25.3,67},{-6,67},{-6,20.9}},     color={0,0,127}));
  connect(dp_set.y, menergaAdsolairValidationModel.dpSet[2]) annotation (Line(
        points={{-25.3,67},{-6,67},{-6,19.5}},     color={0,0,127}));
  connect(T_set.y, menergaAdsolairValidationModel.Tset) annotation (Line(points={{-25.3,
          87},{-2,87},{-2,20.2}},            color={0,0,127}));
  connect(phi_evap.T, realExpression.y)
    annotation (Line(points={{79,-62},{61.3,-62}}, color={0,0,127}));
  connect(phi_evap.X_w, realExpression1.y)
    annotation (Line(points={{79,-70},{61.3,-70}}, color={0,0,127}));
  connect(realExpression2.y, phi_evap.p)
    annotation (Line(points={{61.3,-78},{79,-78}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(
      StopTime=3000,
      Tolerance=0.001,
      __Dymola_Algorithm="Lsodar"),
    __Dymola_experimentSetupOutput(events=false),
    __Dymola_Commands(executeCall(ensureSimulated=true) = {createPlot(
        id=1,
        position={0,0,2267,1092},
        y={"T_cond.y","menergaAdsolairValidationModel.condensor.T"},
        range={0.0,3000.0,290.0,310.0},
        grid=true,
        legends={"Datasheet condensor temperature",
          "Simulation condensor temperature"},
        colors={{28,108,200},{238,46,47}}),createPlot(
        id=1,
        position={0,0,2267,268},
        y={"menergaAdsolairValidationModel.condensor.heatPort.Q_flow",
          "Q_cond.y"},
        range={0.0,3000.0,0.0,50000.0},
        grid=true,
        legends={"Simulation condensor heat flow rate [W]",
          "Datasheet condensor heat flow rate [W]"},
        subPlot=2,
        colors={{238,46,47},{28,108,200}}),createPlot(
        id=1,
        position={0,0,2267,269},
        y={"Q_evap.y",
          "menergaAdsolairValidationModel.simpleCompressor.port_a.Q_flow"},
        range={0.0,3000.0,0.0,50000.0},
        grid=true,
        legends={"Datasheet evaporator heat flow rate [W]",
          "Simulation evaporator heat flow rate [W]"},
        subPlot=3,
        colors={{28,108,200},{238,46,47}}),createPlot(
        id=1,
        position={0,0,2267,268},
        y={"RH_evap.y","phi_evap.phi"},
        range={0.0,3000.0,0.65,0.9500000000000001},
        grid=true,
        legends={"Datasheet evaporator RH","Simulation evaporator RH"},
        subPlot=4,
        colors={{28,108,200},{238,46,47}})} "Validation"),
    Documentation(info="<html>
<p>Note that the inlet conditions of the evaporator are overwritten by custom equations!</p>
</html>", revisions="<html>
<ul>
<li>
October 11, 2016, by Filip Jorissen:<br/>
Added first implementation.
</li>
</ul>
</html>"));
end AdsolairDatasheetValidationSummer;
