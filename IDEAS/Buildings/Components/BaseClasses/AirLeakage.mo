within IDEAS.Buildings.Components.BaseClasses;
model AirLeakage "air leakage due to limied air tightness"

extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Modelica.SIunits.Volume V "zone air volume";
  parameter Real n50(min=0.01)=0.4 "n50-value of airtightness";

  parameter SI.Time tau=30 "Tin time constant at nominal flow rate";

  outer IDEAS.SimInfoManager sim "Simulation information manager"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Fluid.Interfaces.IdealSource       idealSource(
    redeclare package Medium = Medium,
    control_m_flow=true,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Fluid.FixedResistances.Pipe_HeatPort       pipe_HeatPort(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    dynamicBalance=false,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=V/3600*n50/20)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow if  sim.computeConservationOfEnergy
    annotation (Placement(transformation(extent={{-40,50},{-60,70}})));
  Modelica.Blocks.Sources.RealExpression Qgai(y=-prescribedTemperature.port.Q_flow) if sim.computeConservationOfEnergy
    annotation (Placement(transformation(extent={{0,50},{-20,70}})));
equation

  connect(realExpression.y, prescribedTemperature.T) annotation (Line(
      points={{21,70},{38,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, pipe_HeatPort.heatPort) annotation (Line(
      points={{60,70},{70,70},{70,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipe_HeatPort.port_b, port_b) annotation (Line(
      points={{80,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(idealSource.port_b, pipe_HeatPort.port_a) annotation (Line(
      points={{20,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(realExpression1.y, idealSource.m_flow_in) annotation (Line(
      points={{-19,30},{4,30},{4,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a, idealSource.port_a) annotation (Line(
      points={{-100,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, sim.Qgai)
    annotation (Line(points={{-60,60},{-90,60},{-90,80}}, color={191,0,0}));
  connect(Qgai.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-21,60},{-40,60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={Text(
          extent={{-60,60},{60,-60}},
          lineColor={0,128,255},
          textString="ACH")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(revisions="<html>
<ul>
<li>
June 14, 2015, Filip Jorissen:<br/>
Adjusted implementation for computing conservation of energy.
</li>
</ul>
</html>"));
end AirLeakage;
