within Annex60.Experimental.ThermalZones.ROM;
model AggWindow "Aggregates radiation through multiple windows to one window"
  parameter Integer n "number of inputs and weightfactors";
  parameter Real weightfactors[n]
    "Weightfactors with which the inputs are to be weighted";
  Modelica.Blocks.Interfaces.RealInput solarRadWinTrans[n](
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "transmitted solar radiation through windows" annotation (
      Placement(transformation(extent={{-100,0},{-80,20}}), iconTransformation(
          extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Interfaces.RealOutput solarRadWinAgg(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "transmitted solar radiation through aggregated window" annotation (Placement(
        transformation(extent={{80,0},{100,20}}), iconTransformation(extent={{80,
            -10},{100,10}})));
equation
  solarRadWinAgg = solarRadWinTrans * weightfactors/sum(weightfactors);
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-100,
            -100},{100,100}})),                                                                                     Icon(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),                                                                                                    graphics={                                                                                                    Line(points={{
              -74,-20},{60,-20}},                                                                                                    color={0,0,
              255}),                                                                                                    Line(points={{
              -74,20},{60,20}},                                                                                                    color={0,0,
              255}),                                                                                                    Line(points={{
              60,20},{80,0}},                                                                                                    color={0,0,
              255}),                                                                                                    Line(points={{
              60,-20},{80,0}},                                                                                                    color={0,0,
              255}),
        Rectangle(
          extent={{-80,24},{-74,-24}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,30},{0,10},{20,20},{0,30}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-74,66},{72,30}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={236,99,92},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Polygon(
          points={{0,-10},{0,-30},{20,-20},{0,-10}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),                                                                                                    Documentation(info="<html>
<p>This component weights the n-vectorial radiant input with n weightfactors and has a scalar output.</p>
<p><br>The partial class contains following components:</p>
<ul>
<li>2 solar radiation ports</li>
</ul>
<h4>Main equations</h4>
<p> input(n)*weightfactors(n)/sum(weightfactors). </p>
<h4>Assumption and limitations</h4>
<p>If the weightfactors are all zero, Dymola tries to divide through zero. You will get a warning and the output is set to zero. </p>
<h4>Typical use and important parameters</h4>
<p>You can use this component to weight a radiant input and sum it up to one scalar output, e.g. weight the radiance of the sun of n directions with the areas of windows in n directions and sum it up to one scalar radiance on a non-directional window </p>
</html>",  revisions = "<html>
 <ul>
 <li><i>January 2012,&nbsp;</i> by Moritz Lauster:<br/>Implemented.</li>
 </ul>
 </html>"));
end AggWindow;
