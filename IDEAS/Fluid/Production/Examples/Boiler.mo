within IDEAS.Fluid.Production.Examples;
model Boiler
  "General example and tester for a modulating air-to-water heat pump"
  import IDEAS;

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

  IDEAS.Fluid.Movers.Pump pump(
    m=1,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    useInput=true,
    filteredMassFlowRate=true,
    riseTime=10)
    annotation (Placement(transformation(extent={{-14,-24},{-34,-4}})));
  IDEAS.Fluid.FixedResistances.Pipe_Insulated pipe(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    UA=100)
    annotation (Placement(transformation(extent={{32,-24},{12,-4}})));
  IDEAS.Fluid.Production.Boiler heater(
    tauHeatLoss=3600,
    cDry=10000,
    mWater=4,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    QNom=5000)
    annotation (Placement(transformation(extent={{-74,14},{-56,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15)
    annotation (Placement(transformation(extent={{-94,-20},{-80,-6}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
  //  Real PElLossesInt( start = 0, fixed = true);
  //  Real PElNoLossesInt( start = 0, fixed = true);
  //  Real QUsefulLossesInt( start = 0, fixed = true);
  //  Real QUsefulNoLossesInt( start = 0, fixed = true);
  //  Real SPFLosses( start = 0);
  //  Real SPFNoLosses( start = 0);
  //
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
    annotation (Placement(transformation(extent={{-40,-62},{-20,-42}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/5000,
    startTime=5000,
    amplitude=4,
    offset=273.15 + 15)
    annotation (Placement(transformation(extent={{-82,-62},{-62,-42}})));
  Sources.Boundary_pT bou(nPorts=1, redeclare package Medium = Medium,
    p=200000)
    annotation (Placement(transformation(extent={{-8,8},{-28,28}})));
  constant SI.MassFlowRate m_flow_nominal=0.15 "Nominal mass flow rate";
  Modelica.Blocks.Sources.RealExpression realExpression(y=273.15 + 50)
    annotation (Placement(transformation(extent={{-94,28},{-74,48}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTemBoiler_out(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-50,26},{-30,46}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTemBoiler_in(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-38,-22},{-54,-6}})));
  Modelica.Blocks.Sources.Pulse sine1(
    startTime=2000,
    amplitude=-1,
    period=500,
    offset=1)
    annotation (Placement(transformation(extent={{20,-80},{0,-60}})));
equation
  //   der(PElLossesInt) = HP.PEl;
  //   der(PElNoLossesInt) = HP_NoLosses.PEl;
  //   der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
  //   der(QUsefulNoLossesInt) = thermalConductor1.port_b.Q_flow;
  //   SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;
  //   SPFNoLosses = if noEvent(PElNoLossesInt > 0) then QUsefulNoLossesInt/PElNoLossesInt else 0;

  connect(heater.heatPort, fixedTemperature.port) annotation (Line(
      points={{-67.7,14},{-70,14},{-70,-12},{-76,-12},{-76,-13},{-80,-13}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TReturn.port, pipe.heatPort) annotation (Line(
      points={{-20,-52},{22,-52},{22,-24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, TReturn.T) annotation (Line(
      points={{-61,-52},{-42,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe.port_b, pump.port_a) annotation (Line(
      points={{12,-14},{-14,-14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bou.ports[1], heater.port_a) annotation (Line(
      points={{-28,18},{-42,18},{-42,18},{-56,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(realExpression.y, heater.TSet) annotation (Line(
      points={{-73,38},{-68.6,38},{-68.6,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heater.port_b, senTemBoiler_out.port_a) annotation (Line(
      points={{-56,30},{-56,36},{-50,36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBoiler_out.port_b, pipe.port_a) annotation (Line(
      points={{-30,36},{48,36},{48,-14},{32,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, senTemBoiler_in.port_a) annotation (Line(
      points={{-34,-14},{-38,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBoiler_in.port_b, heater.port_a) annotation (Line(
      points={{-54,-14},{-56,-14},{-56,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine1.y, pump.m_flowSet) annotation (Line(
      points={{-1,-70},{-10,-70},{-10,0},{-24,0},{-24,-3.6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file="Scripts/Tester_Boiler.mos" "TestModel"),
    Documentation(info="<html>
<p>This example shows the modulation behaviour of an inverter controlled air-to-water heat pump when the inlet water temperature is changed. </p>
<p>The modulation level can be seen from heater.heatSource.modulation.</p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"));
end Boiler;
