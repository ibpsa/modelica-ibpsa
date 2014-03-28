within IDEAS.Thermal.Components.Interfaces.Partials;
partial model PumpTwoPort
  extends PartialTwoPort(vol(nPorts=2));
  BaseClasses.IdealSource idealSource(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
equation
  connect(idealSource.port_a, vol.ports[2]) annotation (Line(
      points={{8,0},{-54,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(idealSource.port_b, port_b) annotation (Line(
      points={{28,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end PumpTwoPort;
