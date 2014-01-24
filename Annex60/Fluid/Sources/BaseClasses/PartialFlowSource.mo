within Annex60.Fluid.Sources.BaseClasses;
partial model PartialFlowSource 
  "Partial component source with one fluid connector"
  import Modelica.Constants;

  parameter Integer nPorts=0 "Number of ports" annotation(Dialog(connectorSizing=true));

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model within the source"
     annotation (choicesAllMatching=true);

  Medium.BaseProperties medium "Medium in the source";

  Annex60.Fluid.Interfaces.FluidPort_b ports[nPorts](
                     redeclare each package Medium = Medium)
    annotation (Placement(transformation(extent={{90,10},{110,-10}})));
equation 
  assert(abs(sum(abs(ports.m_flow)) - max(abs(ports.m_flow))) <= Modelica.Constants.small, "FlowSource only supports one connection with flow");
  // Only one connection allowed to a port to avoid unwanted ideal mixing
  for i in 1:nPorts loop
    assert(cardinality(ports[i]) <= 1,"
each ports[i] of boundary shall at most be connected to one component.
If two or more connections are present, ideal mixing takes
place with these connections, which is usually not the intention
of the modeller. Increase nPorts to add an additional port.
");
     ports[i].p          = medium.p;
     ports[i].T_outflow  = medium.T;
     ports[i].Xi_outflow = medium.Xi;
  end for;

  annotation (defaultComponentName="boundary", Documentation(info="<html>
<p>
Partial component to model the volume interface of a source
component, such as a mass flow source. The essential
features are:
</p>
<ul>
<li> The pressure in the connection port is identical to the
     pressure in the volume.</li>
<li> The outflow temperature and the composition of the
     substances are identical to the respective values in the volume.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
January 22, 2014, by Michael Wetter:<br/>
First implementation based on model in Modelica Standard Library, but
with a different connector.
</li>
</ul>
</html>"));
end PartialFlowSource;
