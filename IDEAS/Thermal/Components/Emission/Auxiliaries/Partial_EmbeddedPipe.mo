within IDEAS.Thermal.Components.Emission.Auxiliaries;
model Partial_EmbeddedPipe "Partial for the embedded pipe model"
  import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
  extends Partial_Emission(final emissionType = EmissionType.FloorHeating);

  parameter Modelica.SIunits.MassFlowRate m_flowMin
    "Minimal flowrate when in operation";

end Partial_EmbeddedPipe;
