within Annex60.Experimental.Pipe.Examples.UseCaseAachenMSL.Components;
model SupplySource "A simple supply model with source"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Modelica.SIunits.Pressure p_supply
    "Supply pressure for the network";

  Annex60.Fluid.Sources.Boundary_pT source(          redeclare package Medium
      = Medium,
    p=p_supply,
    use_T_in=true,
    nPorts=1) "Flow source with fixed supply pressure for the network"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={6,30})));
  Annex60.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{64,-10},{84,10}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort T_supply(redeclare package Medium =
        Medium, m_flow_nominal=1,
    T_start=333.15)               "Supply flow temperature"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium) "Supply port for the network (named port_b for consistency)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
Modelica.Blocks.Sources.Constant const(k=273.15 + 60)
  annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
equation

  connect(senMasFlo.port_a, T_supply.port_b)
    annotation (Line(points={{64,0},{52,0},{40,0}}, color={0,127,255}));
  connect(source.ports[1], T_supply.port_a)
    annotation (Line(points={{6,20},{6,0},{20,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, port_b)
    annotation (Line(points={{84,0},{100,0}}, color={0,127,255}));
connect(const.y, source.T_in)
  annotation (Line(points={{-19,70},{10,70},{10,42}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-80,80},{-80,-80},{76,0},{-80,80}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  Documentation(revisions="<html>
<ul>
<li>December 12, 2016 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"));
end SupplySource;
