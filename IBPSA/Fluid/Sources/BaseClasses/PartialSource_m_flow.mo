within IBPSA.Fluid.Sources.BaseClasses;
model PartialSource_m_flow "Partial source with prescribed flow rate"
  extends IBPSA.Fluid.Sources.BaseClasses.PartialSource;
  parameter Boolean use_m_flow_in = false
    "Get the mass flow rate from the input connector"
    annotation(Evaluate=true, HideResult=true);
  parameter Modelica.SIunits.MassFlowRate m_flow = 0
    "Fixed mass flow rate going out of the fluid port"
    annotation (Dialog(enable = not use_m_flow_in));
  Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s") if use_m_flow_in
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),iconTransformation(extent={{-140,60},
            {-100,100}})));
protected
  Modelica.Blocks.Interfaces.RealInput m_flow_in_internal(final unit="kg/s")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput p_internal(final unit="Pa")
    "Needed to connect to conditional connector";
equation
  connect(m_flow_in, m_flow_in_internal);
  if not use_m_flow_in then
    m_flow_in_internal = m_flow;
  end if;
  sum(ports.m_flow) = -m_flow_in_internal;
  for i in 1:nPorts loop
    ports[i].p = p_internal;
  end for;
  connect(medium.p, p_internal);
  annotation (Documentation(revisions="<html>
<ul>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Initial version for refactoring inputs of sources.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
</ul>
</html>"));
end PartialSource_m_flow;
