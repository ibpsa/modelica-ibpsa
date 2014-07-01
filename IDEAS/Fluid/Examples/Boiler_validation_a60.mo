within IDEAS.Fluid.Examples;
model Boiler_validation_a60 "Validation model for the boiler"
  import Buildings;

  extends Modelica.Icons.Example;
  //package Medium = Annex60.Media.Water "Medium model"; Modelica.Media.Water.ConstantPropertyLiquidWater
  package Medium = IDEAS.Media.Water;

  final parameter Medium.ThermodynamicState state_pTX = Medium.setState_pTX(p=Medium.p_default, T=313.15, X=Medium.X_default)
    "Medium state";

  IDEAS.Fluid.FixedResistances.Pipe_Insulated pipe(
    redeclare package Medium = Medium,
    m_flow_nominal=par.mFlowNom,
    dp_nominal=0,
    T_start=313.15,
    m=1,
    UA=1)            annotation (Placement(transformation(extent={{-2,12},{18,-8}})));

  IDEAS.Fluid.Production.Boiler heater(
    redeclare package Medium = Medium,
    QNom=par.QNom,
    tauHeatLoss=par.tau_heatLoss,
    mWater=par.mWater,
    cDry=par.cDry,
    dp_nominal=par.dpFix,
    m_flow_nominal=par.mFlowNom)
               annotation (Placement(transformation(extent={{-70,-16},{-50,4}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
    annotation (Placement(transformation(extent={{50,30},{30,50}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow pump(
    redeclare package Medium = Medium,
    addPowerToMedium=false,
    motorCooledByFluid=false,
    m_flow_nominal=par.mFlowNom,
    T_start=par.TIni,
    m_flow(start=par.mFlowStart),
    m_flow_start=par.mFlowStart,
    tau=50,
    motorEfficiency=
        Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters(
        r_V={1}, eta={1}),
    hydraulicEfficiency=
        Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters(
        r_V={1}, eta={1}),
    dynamicBalance=false,
    filteredSpeed=false)
    annotation (Placement(transformation(extent={{8,-28},{-12,-48}})));
  Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Medium,
      VTot=0.01)
    annotation (Placement(transformation(extent={{48,-32},{68,-12}})));
  boiler_validation par
    annotation (Placement(transformation(extent={{-38,48},{-18,68}})));
  Modelica.Blocks.Sources.SawTooth saw(
    amplitude=par.ampl_saw*par.mFlowNom,
    period=par.period_saw,
    startTime=par.startTime_saw,
    offset=par.offset_saw*par.mFlowNom)
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=par.ampl_sine,
    freqHz=par.freqHz_sine,
    offset=par.offset_sine,
    startTime=par.startTime_sine)
    annotation (Placement(transformation(extent={{100,30},{80,50}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=par.TSet)
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=par.TFix)
    annotation (Placement(transformation(extent={{-88,-48},{-74,-34}})));

  Modelica.SIunits.Temperature TBoiler_in;
  Modelica.SIunits.Temperature TBoiler_out;
equation
  TBoiler_in = heater.Tin.T;
  TBoiler_out = heater.pipe_HeatPort.heatPort.T;

  connect(TReturn.port, pipe.heatPort)                    annotation (Line(
      points={{30,40},{8,40},{8,12}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(heater.port_b, pipe.port_a) annotation (Line(
      points={{-50,-3.27273},{-50,2},{-2,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe.port_b, pump.port_a)  annotation (Line(
      points={{18,2},{24,2},{24,-38},{8,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, heater.port_a)  annotation (Line(
      points={{-12,-38},{-50,-38},{-50,-10.5455}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exp.port_a, pump.port_a) annotation (Line(
      points={{58,-32},{60,-32},{60,-38},{8,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(saw.y, pump.m_flow_in) annotation (Line(
      points={{-9,-80},{-1.8,-80},{-1.8,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, TReturn.T) annotation (Line(
      points={{79,40},{52,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, heater.TSet) annotation (Line(
      points={{-69,20},{-61,20},{-61,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heater.heatPort) annotation (Line(
      points={{-74,-41},{-62,-41},{-62,-16},{-63,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    experiment(StopTime=400000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}})),
    Commands(file="Scripts/Tester_Boiler.mos" "TestModel"),
    Documentation(info="<html>
<p>Model used to validate the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">IDEAS.Thermal.Components.Production.Boiler</a>. With a fixed set point, the boiler receives different mass flow rates. </p>
</html>"));
end Boiler_validation_a60;
