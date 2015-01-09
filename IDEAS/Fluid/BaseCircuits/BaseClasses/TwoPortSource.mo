within IDEAS.Fluid.BaseCircuits.BaseClasses;
partial model TwoPortSource
  "Component where the outlet of the component is considered to be the supply side"
  extends TwoPortComponent(inletPortA=false);
  annotation (Documentation(revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>"));
end TwoPortSource;
