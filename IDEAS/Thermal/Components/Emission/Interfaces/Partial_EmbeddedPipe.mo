within IDEAS.Thermal.Components.Emission.Interfaces;
model Partial_EmbeddedPipe "Partial for the embedded pipe model"
  import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;
  extends IDEAS.Thermal.Components.Emission.Interfaces.Partial_Emission(final
      emissionType=EmissionType.FloorHeating);

  parameter Modelica.SIunits.MassFlowRate m_flowMin
    "Minimal flowrate when in operation";

  annotation (Icon(graphics={
        Line(
          points={{-60,-70},{-40,-70}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{100,30},{80,30}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-40,-70},{-40,56},{-20,56},{-20,-98},{-2,-98},{-2,56},{20,
              56},{20,-98},{40,-98},{40,56},{62,56},{62,-98},{80,-98},{80,30}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-60,-80},{-60,-60}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{100,20},{100,40}},
          color={0,128,255},
          smooth=Smooth.None)}), Documentation(info="<html>
<p>This model fixes the emissionType (to <code>EmissionType.FloorHeating)</code>and specifies a minimum flow rate.  </p>
<p>And it creates a nice icon for the embedded pipe models :-) </p>
</html>"));
end Partial_EmbeddedPipe;
