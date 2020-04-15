within IBPSA.BoundaryConditions.WeatherData.BaseClasses;
block SourceSelector
  "Block that selects as its output either a parameter value or its input"
  extends Modelica.Blocks.Interfaces.SO;
  parameter IBPSA.BoundaryConditions.Types.DataSource datSou "Data source"
    annotation(Evaluate=true);
  parameter Real p "Parameter value";
  Modelica.Blocks.Interfaces.RealInput uFil if
      datSou == IBPSA.BoundaryConditions.Types.DataSource.File
   "Input signal from file reader"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-120,-70},{-100,-50}})));
  Modelica.Blocks.Interfaces.RealInput uCon if
     datSou == IBPSA.BoundaryConditions.Types.DataSource.Input
   "Input signal from input connector"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
        iconTransformation(extent={{-120,50},{-100,70}})));
equation
  if datSou == IBPSA.BoundaryConditions.Types.DataSource.Parameter then
    y = p;
  end if;
  connect(uCon, y);
  connect(uFil, y);
  annotation (Documentation(info="<html>
<p>
Block that produces at its output the input value <code>uCon</code>, <code>uFil</code>
or the parameter value <code>p</code> depending on the parameter value
<code>datSou</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SourceSelector;
