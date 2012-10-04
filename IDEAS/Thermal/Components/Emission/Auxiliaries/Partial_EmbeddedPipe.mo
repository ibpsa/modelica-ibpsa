within IDEAS.Thermal.Components.Emission.Auxiliaries;
model Partial_EmbeddedPipe "Partial for the embedded pipe model"
  import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
  extends Partial_Emission(final emissionType = EmissionType.FloorHeating);

  parameter Modelica.SIunits.MassFlowRate m_flowMin
    "Minimal flowrate when in operation";

  annotation (Icon(graphics={
        Line(
          points={{-100,0},{-60,0}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{100,0},{60,0}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{-60,0},{-60,76},{-40,76},{-40,-78},{-22,-78},{-22,76},{0,76},
              {0,-78},{20,-78},{20,76},{42,76},{42,-78},{60,-78},{60,0}},
          color={0,128,255},
          smooth=Smooth.None)}));
end Partial_EmbeddedPipe;
