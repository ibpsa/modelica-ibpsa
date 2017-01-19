within IDEAS.Templates.BaseCircuits.Interfaces;
partial model PartialBaseCircuit "Partial for a mixing circuit"
  import IDEAS;

  // Extensions ----------------------------------------------------------------

  extends CircuitInterface;

equation
  if includePipes then
    if not measureReturnT then
      connect(pipeReturn.port_b, port_b2);
    end if;
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{74,100},{80,80},{78,60}},
          color={255,0,0},
          smooth=Smooth.None,
          visible=measureSupplyT),
        Ellipse(
          extent={{76,62},{80,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=measureSupplyT),
        Line(
          points={{-3,20},{3,0},{1,-20}},
          color={255,0,0},
          smooth=Smooth.None,
          origin={-77,-80},
          rotation=180,
          visible=measureReturnT),
        Ellipse(
          extent={{-80,-58},{-76,-62}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=measureReturnT)}));
end PartialBaseCircuit;
