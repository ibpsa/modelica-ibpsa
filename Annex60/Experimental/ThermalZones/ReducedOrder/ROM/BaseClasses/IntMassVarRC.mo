within Annex60.Experimental.ThermalZones.ReducedOrder.ROM.BaseClasses;
model IntMassVarRC "Interior wall consisting of variable number of RC elements"
  parameter Integer n(min = 1) "Number of RC-elements";
  parameter Modelica.SIunits.ThermalResistance RInt[n](each min=Modelica.Constants.small)
    "Vector of resistors, from port to capacitor"                                       annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.HeatCapacity CInt[n](each min=Modelica.Constants.small)
    "Vector of heat capacitors, from port to center"                                           annotation(Dialog(group="Thermal mass"));
  parameter Modelica.SIunits.Temperature T_start
    "Initial temperature of capacitances"                                              annotation(Dialog(group="Thermal mass"));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermResInt[n](R=RInt)
    "vector of resistors connecting port and capacitors"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor thermCapInt[n](C=CInt, each T(start=
          T_start)) "vector of capacitors"
    annotation (Placement(transformation(extent={{-10,-12},{10,-32}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a "interior port"
    annotation (Placement(transformation(extent={{-102,-10},{-82,10}})));
equation
  // Connecting inner elements thermResInt[i]--thermCapInt[i] to n groups
  for i in 1:n loop
    connect(thermResInt[i].port_b,thermCapInt[i].port);
  end for;
  // Connecting groups between each other thermCapInt[i] -- thermResInt[i+1]
  for i in 1:n-1 loop
    connect(thermCapInt[i].port,thermResInt[i+1].port_a);
  end for;
  // Connecting first RC element to port_a port_a--thermResInt[1]
  connect(port_a,thermResInt[1].port_a);
  annotation(defaultComponentName="intWallRC",Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-100,
            -100},{100,120}}),                                                                           graphics), Documentation(info="<html>
<p><code>IntMassVarRC</code><span style=\"font-family: MS Shell Dlg 2;\"> represents heat storage within walls. It links a variable number </span><code>n</code><span style=\"font-family: MS Shell Dlg 2;\"> of thermal resistances and capacities to a series connection. </span><code>n</code><span style=\"font-family: MS Shell Dlg 2;\"> thus defines the spatial discretization of thermal effects within the wall. All effects are considered as one-dimensional normal to the wall&apos;s surface. This model is thought for interior wall elements that only serve as heat storage elements. The RC-chain is defined via a vector of capacities </span><code>CInt[n]</code><span style=\"font-family: MS Shell Dlg 2;\"> and a vector of resistances </span><code>RInt[n]</code><span style=\"font-family: MS Shell Dlg 2;\">. Resistances and capacities are connected alternately, starting with the first resistance </span><code>RInt[1]</code><span style=\"font-family: MS Shell Dlg 2;\">, from heat </span><code>port_a</code><span style=\"font-family: MS Shell Dlg 2;\"> into the wall.</span></p>
<p align=\"center\"><img src=\"modelica://Annex60/Resources/Images/Experimental/ThermalZones/ReducedOrder/ROM/BaseClasses/IntMassVarRC/IntMassVarRC.png\" alt=\"image\"/> </p>
</html>",  revisions="<html>
<ul>
<li>April 17, 2015,&nbsp; by Moritz Lauster:<br>Implemented. </li>
</ul>
</html>"),  Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 120}}), graphics={  Rectangle(extent = {{-86, 60}, {-34, 26}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent = {{-28, 60}, {26, 26}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent = {{32, 60}, {86, 26}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent = {{0, 20}, {54, -14}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent = {{-60, 20}, {-6, -14}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent = {{-86, -20}, {-34, -54}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent = {{-28, -20}, {26, -54}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent = {{32, -20}, {86, -54}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent = {{-60, -60}, {-6, -94}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent = {{0, -60}, {54, -94}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent = {{-60, 100}, {-6, 66}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent = {{0, 100}, {54, 66}}, fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent={{
              60,-60},{86,-94}},                                                                                                    fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent={{
              60,20},{86,-14}},                                                                                                    fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent={{
              60,100},{86,66}},                                                                                                    fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent={{
              -86,-60},{-66,-94}},                                                                                                    fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent={{
              -86,20},{-66,-14}},                                                                                                    fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(extent={{
              -86,100},{-66,66}},                                                                                                    fillColor = {255, 213, 170},
            fillPattern =                                                                                                   FillPattern.Solid, lineColor = {175, 175, 175}),Line(points={{
              -90,0},{-2,0}},                                                                                                   color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None), Rectangle(extent={{
              -66,12},{-18,-10}},                                                                                                  lineColor = {0, 0, 0},
            lineThickness =                                                                                                   0.5, fillColor = {255, 255, 255},
            fillPattern =                                                                                                   FillPattern.Solid), Line(points = {{-2, 0}, {-2, -32}}, color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None),
                                                                                                  Line(points = {{-19, -32}, {15, -32}}, pattern = LinePattern.None, thickness = 0.5, smooth = Smooth.None), Line(points = {{-19, -44}, {15, -44}}, pattern = LinePattern.None, thickness = 0.5, smooth = Smooth.None), Text(extent = {{-90, 142}, {90, 104}}, lineColor = {0, 0, 255}, textString = "%name"),
                                                                                                  Line(points={{
              18,-32},{-20,-32}},                                                                                                    color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None),
                                                                                                  Line(points={{
              14,-44},{-15,-44}},                                                                                                    color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None)}));
end IntMassVarRC;
