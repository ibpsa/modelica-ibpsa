within IDEAS.Buildings.Components.Occupants.BaseClasses;
partial block PartialOccupants "Partial for defining the number of occupants"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealOutput nOcc "Number of occupants"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialOccupants;
