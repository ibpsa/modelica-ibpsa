within Annex60.Utilities.Math.Examples;
model RegNonZeroPower "Test model for regNonZeroPower function "
  import Annex60;
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp x1(duration=1)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}},rotation=0)));
  Annex60.Utilities.Math.RegNonZeroPower regNonZeroPower(n=0.5)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(x1.y, regNonZeroPower.u) annotation (Line(
      points={{-39,0},{-12,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Utilities/Math/Examples/RegNonZeroPower.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of 
<a href=\"modelica://Annex60.Utilities.Math.RegNonZeroPower\">
Annex60.Utilities.Math.RegNonZeroPower</a>.
</p>
</html>", revisions="<html>
<p>
<ul>
<li>
November 28, 2013, by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</p>
</html>"));
end RegNonZeroPower;
