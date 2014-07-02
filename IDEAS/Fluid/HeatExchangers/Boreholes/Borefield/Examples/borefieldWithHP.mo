within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Examples;
model borefieldWithHP
  extends Modelica.Icons.Example;

  parameter Integer lenSim=3600*24*365*20
    "Simulation length ([s]). By default = 100 days";

  Extras.GroundCoupledHeatPump groundCoupledHeatPump(lenSim=lenSim, redeclare
      Borefield.Data.BorefieldData.example bfData)
    annotation (Placement(transformation(extent={{-26,-44},{26,4}})));
  Modelica.Blocks.Sources.Sine Q_flow_bui(
    amplitude=10000,
    freqHz=3.17E-8,
    offset=8000)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Pulse T_sup_bui(
    amplitude=-10,
    period=3E+7,
    startTime=1.5E+7,
    offset=303.15)
    annotation (Placement(transformation(extent={{80,20},{60,40}})));

equation
  connect(Q_flow_bui.y, groundCoupledHeatPump.Q_flow_bui) annotation (Line(
      points={{-59,30},{-15.6,30},{-15.6,5.44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_sup_bui.y, groundCoupledHeatPump.T_sup_bui) annotation (Line(
      points={{59,30},{15.6,30},{15.6,5.44}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=6.3e+008, __Dymola_NumberOfIntervals=10000),
    __Dymola_experimentSetupOutput(events=false));
end borefieldWithHP;
