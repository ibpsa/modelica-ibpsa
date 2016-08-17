within IDEAS.Fluid.Production.Examples;
model Boiler_validation "Validation model for the boiler"

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

  IDEAS.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    m_flow_nominal=1300/3600,
    tau=30,
    filteredSpeed=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{8,-56},{-12,-36}})));

  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=1300/3600,
    T_start=313.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
    annotation (Placement(transformation(extent={{-10,-2},{10,18}})));
  IDEAS.Fluid.Production.Boiler heater(
    tauHeatLoss=3600,
    mWater=10,
    cDry=10000,
    redeclare package Medium = Medium,
    QNom=20000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=1300/3600)
    annotation (Placement(transformation(extent={{-70,-16},{-50,4}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15)
    annotation (Placement(transformation(extent={{-84,-48},{-70,-34}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
  Modelica.Blocks.Sources.TimeTable pulse(offset=0, table=[0, 0; 5000, 100;
        10000, 400; 15000, 700; 20000, 1000; 25000, 1300; 50000, 1300])
    annotation (Placement(transformation(extent={{-50,72},{-30,92}})));
  //  Real PElLossesInt( start = 0, fixed = true);
  //  Real PElNoLossesInt( start = 0, fixed = true);
  //  Real QUsefulLossesInt( start = 0, fixed = true);
  //  Real QUsefulNoLossesInt( start = 0, fixed = true);
  //  Real SPFLosses( start = 0);
  //  Real SPFNoLosses( start = 0);
  //
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
    annotation (Placement(transformation(extent={{-34,24},{-14,44}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=30,
    freqHz=1/5000,
    offset=273.15 + 50,
    startTime=20000)
    annotation (Placement(transformation(extent={{-76,24},{-56,44}})));
  Sources.Boundary_pT bou(
    nPorts=1,
    redeclare package Medium = Medium,
    p=200000)
    annotation (Placement(transformation(extent={{-12,-32},{-32,-12}})));

  Modelica.Blocks.Math.Gain gain(k=1/3600)
    annotation (Placement(transformation(extent={{-14,72},{6,92}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=273.15 + 60)
    annotation (Placement(transformation(extent={{-92,-4},{-72,16}})));
  Sensors.TemperatureTwoPort senTemBoiler_out(redeclare package Medium = Medium,
      m_flow_nominal=1300/3600)
    annotation (Placement(transformation(extent={{-44,-2},{-24,18}})));
  Sensors.TemperatureTwoPort senTemBoiler_in(redeclare package Medium = Medium,
      m_flow_nominal=1300/3600)
    annotation (Placement(transformation(extent={{-24,-56},{-44,-36}})));
equation
  //heater.TSet = 273.15 + 82;

  //   der(PElLossesInt) = HP.PEl;
  //   der(PElNoLossesInt) = HP_NoLosses.PEl;
  //   der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
  //   der(QUsefulNoLossesInt) = thermalConductor1.port_b.Q_flow;
  //   SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;
  //   SPFNoLosses = if noEvent(PElNoLossesInt > 0) then QUsefulNoLossesInt/PElNoLossesInt else 0;

  connect(heater.heatPort, fixedTemperature.port) annotation (Line(
      points={{-60,-16},{-62,-16},{-62,-41},{-70,-41}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TReturn.port, pipe.heatPort) annotation (Line(
      points={{-14,34},{0,34},{0,18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, TReturn.T) annotation (Line(
      points={{-55,34},{-36,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe.port_b, pump.port_a) annotation (Line(
      points={{10,8},{48,8},{48,-46},{8,-46}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(bou.ports[1], heater.port_a) annotation (Line(
      points={{-32,-22},{-42,-22},{-42,-12},{-50,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pulse.y, gain.u) annotation (Line(
      points={{-29,82},{-16,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, heater.TSet) annotation (Line(
      points={{-71,6},{-66,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heater.port_b, senTemBoiler_out.port_a) annotation (Line(
      points={{-50,0},{-50,8},{-44,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBoiler_out.port_b, pipe.port_a) annotation (Line(
      points={{-24,8},{-10,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, senTemBoiler_in.port_a) annotation (Line(
      points={{-12,-46},{-24,-46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBoiler_in.port_b, heater.port_a) annotation (Line(
      points={{-44,-46},{-50,-46},{-50,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(gain.y, pump.m_flow_in) annotation (Line(points={{7,82},{20,82},{20,
          -34},{-1.8,-34}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=40000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file=
          "Resources/Scripts/Dymola/Fluid/Production/Examples/Boiler_validation.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>Model used to validate the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">IDEAS.Thermal.Components.Production.Boiler</a>. With a fixed set point, the boiler receives different mass flow rates. </p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"));
end Boiler_validation;
