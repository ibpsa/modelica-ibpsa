within IDEAS.Fluid.Production.Examples;
model HeatPump_BrineWater
  "General example and tester for a modulating water-to-water heat pump"

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

  Fluid.Movers.Pump pump(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-6,14},{-26,34}})));
  inner IDEAS.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Locations.Uccle
      city, redeclare IDEAS.Climate.Meteo.Files.min60 detail)
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
  //  Real PElLossesInt( start = 0, fixed = true);
  //  Real PElNoLossesInt( start = 0, fixed = true);
  //  Real QUsefulLossesInt( start = 0, fixed = true);
  //  Real QUsefulNoLossesInt( start = 0, fixed = true);
  //  Real SPFLosses( start = 0);
  //  Real SPFNoLosses( start = 0);
  //
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/5000,
    startTime=5000,
    amplitude=4,
    offset=273.15 + 30)
    annotation (Placement(transformation(extent={{92,12},{72,32}})));
  Sources.Boundary_pT bou(          redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{58,36},{38,16}})));
  constant SI.MassFlowRate m_flow_nominal=0.2 "Nominal mass flow rate";
  Fluid.Movers.Pump pump1(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-6,-22},{-26,-2}})));
  Sources.Boundary_pT bou1(         redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{58,-10},{38,-30}})));
  Modelica.Blocks.Sources.Sine sine1(
    freqHz=1/5000,
    amplitude=4,
    offset=273.15 + 10,
    startTime=4000)
    annotation (Placement(transformation(extent={{92,-34},{72,-14}})));
  HeatPumpOnOff onOffHeatPump(
    redeclare package MediumBrine = Medium,
    redeclare package MediumFluid = Medium,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA08
      heatPumpData,
    use_onOffSignal=false)
    annotation (Placement(transformation(extent={{-58,18},{-38,38}})));
equation
  //   der(PElLossesInt) = HP.PEl;
  //   der(PElNoLossesInt) = HP_NoLosses.PEl;
  //   der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
  //   der(QUsefulNoLossesInt) = thermalConductor1.port_b.Q_flow;
  //   SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;
  //   SPFNoLosses = if noEvent(PElNoLossesInt > 0) then QUsefulNoLossesInt/PElNoLossesInt else 0;

  connect(pump.port_a, bou.ports[1]) annotation (Line(
      points={{-6,24},{38,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine.y, bou.T_in) annotation (Line(
      points={{71,22},{60,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine1.y, bou1.T_in) annotation (Line(
      points={{71,-24},{60,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou1.ports[1], pump1.port_a) annotation (Line(
      points={{38,-22},{16,-22},{16,-12},{-6,-12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(onOffHeatPump.fluidIn, pump.port_b) annotation (Line(
      points={{-38,24},{-26,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(onOffHeatPump.fluidOut, bou.ports[2]) annotation (Line(
      points={{-38,32},{0,32},{0,28},{38,28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(onOffHeatPump.brineOut, bou1.ports[2]) annotation (Line(
      points={{-58,24},{-58,0},{38,0},{38,-18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(onOffHeatPump.brineIn, pump1.port_b) annotation (Line(
      points={{-58,32},{-74,32},{-74,-12},{-26,-12}},
      color={0,127,255},
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
Initial version
</li>
</ul>
</html>"));
end HeatPump_BrineWater;
