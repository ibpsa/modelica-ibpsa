within IBPSA.Fluid.Chillers.Examples;
model ReversibleCarnotWithLosses
  "Test model for chiller based on ReversibleCarnotWithLosses model"
  extends Modelica.Icons.Example;
  package MediumCon = IBPSA.Media.Water "Medium model";
  package MediumEva = IBPSA.Media.Water "Medium model";

  IBPSA.Fluid.Chillers.ReversibleCarnotWithLosses revCarWitLosChi(
    redeclare package MediumCon = MediumCon,
    redeclare package MediumEva = MediumEva,
    QUse_flow_nominal=30000,
    y_nominal=1,
    redeclare
      IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.DefaultHeatPumpSafetyControl
      safCtrPar(
      minLocTime=100,
      use_runPerHou=false,
      tabUppHea=[-10,40; 60,40],
      use_TUseOut=true),
    TCon_nominal=313.15,
    dpCon_nominal(displayUnit="Pa") = 6000,
    use_conCap=false,
    CCon=0,
    GConOut=0,
    GConIns=0,
    cpCon=4184,
    TEva_nominal=278.15,
    dTEva_nominal(displayUnit="K") = 10,
    dTCon_nominal(displayUnit="K") = 5,
    dpEva_nominal(displayUnit="Pa") = 6000,
    use_evaCap=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    cpEva=4184,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true) "Chiller instance with reversbile carnot approach"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  IBPSA.Fluid.Sources.MassFlowSource_T souCon(
    nPorts=1,
    redeclare package Medium = MediumCon,
    use_T_in=true,
    m_flow=revCarWitLosChi.mCon_flow_nominal,
    T=298.15) "Condenser source"
    annotation (Placement(transformation(extent={{-60,6},{-40,26}})));
  IBPSA.Fluid.Sources.MassFlowSource_T souEva(
    nPorts=1,
    redeclare package Medium = MediumEva,
    use_T_in=true,
    m_flow=revCarWitLosChi.mEva_flow_nominal,
    T=291.15) "Evaporator source"
    annotation (Placement(transformation(extent={{60,-6},{40,14}})));
  IBPSA.Fluid.Sources.Boundary_pT sinCon(nPorts=1, redeclare package Medium =
        MediumCon) "Condenser sink" annotation (Placement(transformation(extent={{
            10,-10},{-10,10}}, origin={70,40})));
  IBPSA.Fluid.Sources.Boundary_pT sinEva(nPorts=1, redeclare package Medium =
        MediumEva) "Evaporator sink" annotation (Placement(transformation(extent={
            {-10,-10},{10,10}}, origin={-50,-20})));
  Modelica.Blocks.Sources.SawTooth ySet(
    amplitude=-1,
    period=500,
    offset=1,
    startTime=500)  "Compressor control signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Sources.Ramp TConIn(
    height=10,
    duration=60,
    offset=273.15 + 30,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{52,-40},{72,-20}})));
  Modelica.Blocks.Sources.BooleanStep chi(startTime=1800, startValue=true)
    "Chilling mode on"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(souCon.ports[1], revCarWitLosChi.port_a1) annotation (Line(
      points={{-40,16},{-20,16},{-20,15},{-5.55112e-16,15}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souEva.ports[1], revCarWitLosChi.port_a2) annotation (Line(
      points={{40,4},{30,4},{30,5},{20,5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(revCarWitLosChi.port_b1, sinCon.ports[1]) annotation (Line(
      points={{20,15},{30,15},{30,40},{60,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinEva.ports[1], revCarWitLosChi.port_b2) annotation (Line(
      points={{-40,-20},{-10,-20},{-10,5},{-5.55112e-16,5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TConIn.y, souCon.T_in) annotation (Line(
      points={{-69,20},{-62,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn.y, souEva.T_in) annotation (Line(
      points={{73,-30},{80,-30},{80,8},{62,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ySet.y, revCarWitLosChi.ySet) annotation (Line(points={{-39,60},{-16,
          60},{-16,11.6667},{-1.6,11.6667}},
                                         color={0,0,127}));
  connect(chi.y, revCarWitLosChi.coo) annotation (Line(points={{-39,-50},{-22,-50},
          {-22,2.5},{-1.6,2.5}}, color={255,0,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Chillers/Examples/ReversibleCarnotWithLosses.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>", info="<html>
<p>
  Example that simulates a chiller based on the modular reversible approach
  using the 
  <a href=\"modelica://IBPSA.Fluid.Chillers.ReversibleCarnotWithLosses\">
  IBPSA.Fluid.Chillers.ReversibleCarnotWithLosses</a>.
  model directly.
  The chiller control signal is the compressor speed 
  <code>ySet</code> and the mode <code>coo</code>.
</p>
<p>
  As the model contains internal safety controls, the 
  compressor set speed <code>ySet</code> and actually applied
  speed <code>yOut</code> are plotted to show the influence of 
  the safety control.
</p>
</html>"));
end ReversibleCarnotWithLosses;
