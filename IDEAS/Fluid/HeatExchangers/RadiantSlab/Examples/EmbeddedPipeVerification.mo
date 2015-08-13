within IDEAS.Fluid.HeatExchangers.RadiantSlab.Examples;
model EmbeddedPipeVerification
  "Verification of embedded pipe model for large flow rates"
  extends Modelica.Icons.Example;
  package Medium = IDEAS.Media.Water;

  parameter Modelica.SIunits.TemperatureDifference dT = 10;

  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe(
    redeclare package Medium = Medium,
    redeclare
      IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.FH_ValidationEmpa4_6
      RadSlaCha,
    m_flow_nominal=1,
    computeFlowResistance=true,
    m_flowMin=0.2,
    nDiscr=2,
    A_floor=1,
    nParCir=5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    R_c=1e7)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Sources.MassFlowSource_T boundary(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=100,
    T=fixTem.T + dT)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTem(T=273.15 + 10)
    "Fixed temperature boundary"
    annotation (Placement(transformation(extent={{-36,62},{-16,82}})));

  Sources.Boundary_pT bou(          redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor theRes1(R=1e7)
    "Thermal resistor 1" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,44})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor theRes2(R=1e7)
    "Thermal resistor 2" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={26,44})));
equation

    assert( abs(embeddedPipe.heatPortEmb[1].Q_flow+dT/theRes1.R)<100000*Modelica.Constants.eps, "Solution for large mass flow rates is unexpected!");
    assert( abs(embeddedPipe.heatPortEmb[2].Q_flow+dT/theRes1.R)<100000*Modelica.Constants.eps, "Solution for large mass flow rates is unexpected!");
  connect(boundary.ports[1], embeddedPipe.port_a) annotation (Line(
      points={{-40,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fixTem.port, theRes1.port_b) annotation (Line(
      points={{-16,72},{0,72},{0,54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theRes1.port_a, embeddedPipe.heatPortEmb[1]) annotation (Line(
      points={{0,34},{0,9.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theRes2.port_a, embeddedPipe.heatPortEmb[2])
    annotation (Line(points={{26,34},{26,10.5},{0,10.5}}, color={191,0,0}));
  connect(theRes2.port_b, fixTem.port) annotation (Line(points={{26,54},{28,54},
          {28,60},{28,72},{-16,72}}, color={191,0,0}));
  connect(embeddedPipe.port_b, bou.ports[1])
    annotation (Line(points={{10,0},{35,0},{60,0}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment,
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(file=
          "modelica://IDEAS/Resources/Scripts/Dymola/Fluid/HeatExchangers/RadiantSlab/Examples/EmbeddedPipeExample.mos"
        "Simulate and plot"));
end EmbeddedPipeVerification;
