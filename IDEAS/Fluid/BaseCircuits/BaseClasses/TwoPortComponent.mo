within IDEAS.Fluid.BaseCircuits.BaseClasses;
partial model TwoPortComponent
  extends IDEAS.Fluid.BaseCircuits.BaseClasses.TwoPort;

  replaceable Interfaces.PartialTwoPortInterface partialTwoPortInterface
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end TwoPortComponent;
