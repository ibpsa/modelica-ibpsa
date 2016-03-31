within IDEAS.Buildings.Components.Interfaces;
record ThermalBridge "Record data for thermal bridges"

  parameter Real G = psi*lin "Effective thermal loss";
  parameter Boolean present = true;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThermalBridge;
