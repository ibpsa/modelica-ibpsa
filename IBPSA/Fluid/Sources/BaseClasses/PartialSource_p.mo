within IBPSA.Fluid.Sources.BaseClasses;
model PartialSource_p "Partial source with prescribed pressure"
  extends IBPSA.Fluid.Sources.BaseClasses.PartialSource;
  parameter Boolean use_p_in = false
    "Get the pressure from the input connector"
    annotation(Evaluate=true, HideResult=true, Dialog(group="Conditional inputs"));
  parameter Medium.AbsolutePressure p = Medium.p_default
    "Fixed value of pressure"
    annotation (Dialog(enable = not use_p_in, group="Fixed inputs"));
  Modelica.Blocks.Interfaces.RealInput p_in(final unit="Pa") if use_p_in
    "Prescribed boundary pressure"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

equation
  connect(p_in, p_in_internal);
  if not use_p_in then
    p_in_internal = p;
  end if;
  for i in 1:nPorts loop
    ports[i].p          = p_in_internal;
  end for;

  annotation (Documentation(revisions="<html>
<ul>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Initial version for refactoring inputs of sources.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
</ul>
</html>"));
end PartialSource_p;
