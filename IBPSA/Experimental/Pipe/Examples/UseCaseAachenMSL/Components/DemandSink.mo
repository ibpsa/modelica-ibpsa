within IBPSA.Experimental.Pipe.Examples.UseCaseAachenMSL.Components;
model DemandSink "Simple demand model"

   extends UseCaseAachen.Components.DemandSink;
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
