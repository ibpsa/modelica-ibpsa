within IDEAS.Fluid.BaseCircuits.Interfaces;
partial model PartialBaseCircuit "Partial for a mixing circuit"
  import IDEAS;

  //Extensions
  extends CircuitInterface;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{76,100},{82,80},{80,60}},
          color={255,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{78,62},{82,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end PartialBaseCircuit;
