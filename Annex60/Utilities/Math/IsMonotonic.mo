within Annex60.Utilities.Math;
block IsMonotonic "Returns true if the argument is a monotonic sequence"

  Modelica.Blocks.Interfaces.RealInput u[:]
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.BooleanOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
 parameter Boolean strict=false "Set to true to test for strict monotonicity";
equation
  y = Annex60.Utilities.Math.Functions.isMonotonic(x=u, strict=strict);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
                             Text(
          extent={{-90,38},{90,-34}},
          lineColor={160,160,164},
          textString="isMonotonic()")}),
    Documentation(info="<html>
<p>This function returns <code>true</code> if its argument is monotonic increasing or decreasing, and <code>false</code> otherwise. If <code>strict=true</code>, then strict monotonicity is tested, otherwise weak monotonicity is tested. </p>
</html>", revisions="<html>
<ul>
<li>
November 29, 2013, by Marcus Fuchs:<br/>
Implementation based on Funtions.isMonotonic.
</li>
</ul>
</html>"));
end IsMonotonic;
