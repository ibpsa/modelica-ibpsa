within IBPSA.Experimental.Pipe.Examples.UseCaseAachen.Components;
model DemandSink "Simple demand model"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean useTempDesign = true
    "Use static dT for true, dynamic dT for false";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate, used for regularization near zero flow"
    annotation(Dialog(group = "Nominal condition"));

  IBPSA.Fluid.Sources.MassFlowSource_T sink(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Flow demand of the substation" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-18,20})));
  Modelica.Blocks.Sources.CombiTimeTable InputTable(
    tableName="Demand",
    tableOnFile=false,
    table=flowRateGeneric.data,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
                  "Table input for prescribed flow" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,90})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    "Switch to negative m_flow value for inflow" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,62})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort senT_supply(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=1,
    T_start=333.15)
           "Incoming supply temperature from DH network"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Data.FlowRateGeneric flowRateGeneric
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
equation

  connect(gain.y, sink.m_flow_in)
    annotation (Line(points={{-10,51},{-10,30}}, color={0,0,127}));
  connect(senT_supply.port_a, port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(senT_supply.port_b, sink.ports[1])
    annotation (Line(points={{-60,0},{-18,0},{-18,10}}, color={0,127,255}));
  connect(InputTable.y[1], gain.u)
    annotation (Line(points={{39,90},{-10,90},{-10,74}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    Documentation(info="<html>
<p>The simplest demand model for hydraulic calculations (no thermal modeling included).</p>
<p>Uses only a mass flow source as ideal sink. Specify a negative mass flow rate <code>m_flow &lt; 0</code> to prescribe a flow into the demand sink.</p>
</html>",
        revisions="<html>
<ul>
<li>December 12, 2016 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Rectangle(
          extent={{-90,92},{90,-92}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-60,80},{-60,-78},{82,0},{-60,80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}));
end DemandSink;
