within IDEAS.Fluid.BaseCircuits.BaseClasses;
partial model TwoPortComponent
  extends IDEAS.Fluid.BaseCircuits.BaseClasses.TwoPort;

  replaceable Interfaces.PartialTwoPortInterface partialTwoPortInterface
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Boolean inletPortA
    "Set to true to use port A as the fluid inlet port"
    annotation(Dialog(tab="Advanced"));
equation
  if inletPortA then
    connect(partialTwoPortInterface.port_a, fluidTwoPort_a.port_b) annotation (
      Line(
      points={{-10,0},{-40,0},{-40,100},{0,100}},
      color={0,127,255},
      smooth=Smooth.None));
    connect(partialTwoPortInterface.port_b, fluidTwoPort_a.port_a) annotation (
      Line(
      points={{10,0},{40,0},{40,100},{0,100}},
      color={0,127,255},
      smooth=Smooth.None));
  else
    connect(partialTwoPortInterface.port_a, fluidTwoPort_a.port_a) annotation (
      Line(
      points={{-10,0},{-40,0},{-40,100},{0,100}},
      color={0,127,255},
      smooth=Smooth.None));
    connect(partialTwoPortInterface.port_b, fluidTwoPort_a.port_b) annotation (
      Line(
      points={{10,0},{40,0},{40,100},{0,100}},
      color={0,127,255},
      smooth=Smooth.None));
  end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>"));
end TwoPortComponent;
