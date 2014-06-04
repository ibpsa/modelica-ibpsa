within IDEAS.Fluid.HeatExchangers.Examples;
model Radiator_NominalPower
  "Test for checking the nominal working points of a radiator"

  extends Modelica.Icons.Example;

  Fluid.Movers.Pump volumeFlow1(
    m=4,
    redeclare package Medium = Medium,
    T_start=293.15,
    m_flow_nominal=radiator.m_flow_nominal,
    useInput=false)
    annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort boiler(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    T_start=293.15)
    annotation (Placement(transformation(extent={{12,4},{32,-16}})));
  Fluid.HeatExchangers.Radiators.Radiator radiator(
    QNom=3000,
    powerFactor=3.37,
    redeclare package Medium = Medium,
    TInNom=318.15,
    TOutNom=308.15,
    show_T=true) "Hydraulic radiator model"
    annotation (Placement(transformation(extent={{50,-8},{70,12}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature(
      T=293.15) annotation (Placement(transformation(extent={{32,24},{52,44}})));
  Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts=1,
    p=200000)                                                annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,-44})));
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  parameter SI.MassFlowRate m_flow_nominal=0.05 "Nominal mass flow rate";
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=318.15)
    annotation (Placement(transformation(extent={{-22,-50},{-2,-30}})));
equation

  connect(prescribedTemperature.port, radiator.heatPortRad) annotation (Line(
      points={{52,34},{69,34},{69,12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, radiator.heatPortCon) annotation (Line(
      points={{52,34},{65,34},{65,12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(boiler.port_b, radiator.port_a) annotation (Line(
      points={{32,-6},{42,-6},{42,2},{50,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(radiator.port_b, volumeFlow1.port_a) annotation (Line(
      points={{70,2},{88,2},{88,-70},{-80,-70},{-80,-6},{-36,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1], radiator.port_a) annotation (Line(
      points={{42,-34},{46,-34},{46,2},{50,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volumeFlow1.port_b, boiler.port_a) annotation (Line(
      points={{-16,-6},{12,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, boiler.heatPort) annotation (Line(
      points={{-2,-40},{10,-40},{10,-16},{22,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=100000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This model checks the energy balance of the radiator for flow and no-flow situations.</p>
<p>Check IDEAS.Thermal.Components.Emission.Radiator for radiator model use. <br>
Heating power can be estimated with <a href=\"http://www.infotalia.com/nld/wonen/energie/verwarming_berekenen.asp\">online calculator</a> (Last visit: 06/06/2013)</p>
<p>Plot the QBoiler and QRadiator variables over 100k seconds to make sure that in-out energy balance of the radiator is fine. </p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"));
end Radiator_NominalPower;
