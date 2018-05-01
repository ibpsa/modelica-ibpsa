within IDEAS.Buildings.Components.Shading.Interfaces.Records;
record BuildingShade
  "Component for modeling shade cast by distant objects such as buildings and treelines"
  extends ShadingProperties(controlled=false, shaType=ShadingType.BuildingShade);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BuildingShade;
