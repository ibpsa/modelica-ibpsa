within IDEAS.Fluid.FixedResistances.Examples;
model OpenHydraulicSystem "Illustrate the use of the ambient model"
  import IDEAS;

  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  Fluid.FixedResistances.InsulatedPipe heatedPipe(
    m=5,
    UA=10,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=283.15)
           annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    tau=30,
    m_flow_nominal=0.1,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=298.15)
    annotation (Placement(transformation(extent={{-52,-46},{-32,-26}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(nPorts=2, redeclare package Medium =
        Medium,
    p=200000,
    T=283.15)
    annotation (Placement(transformation(extent={{-82,0},{-62,20}})));

equation
  connect(heatedPipe.port_b, pump.port_a) annotation (Line(
      points={{0,10},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(bou.ports[1], heatedPipe.port_a) annotation (Line(
      points={{-62,12},{-42,12},{-42,10},{-20,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heatedPipe.heatPort) annotation (Line(
      points={{-32,-36},{-10,-36},{-10,14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pump.port_b, bou.ports[2]) annotation (Line(
      points={{40,10},{52,10},{52,38},{-62,38},{-62,8}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    Documentation(info="<html>
<p>Simple tester for the IDEAS.Thermal.Components.BaseClasses.Ambient model</p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"),
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(file=
          "modelica://IDEAS/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/OpenHydraulicSystem.mos"
        "Simulate and plot"));
end OpenHydraulicSystem;
