within IDEAS.Fluid.BaseCircuits.BaseClasses;
partial model TwoPortSink
  "Component where the inlet of the component is considered to be the supply side"
  extends TwoPortComponent(inletPortA=true);
  annotation (Documentation(revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>"));
end TwoPortSink;
