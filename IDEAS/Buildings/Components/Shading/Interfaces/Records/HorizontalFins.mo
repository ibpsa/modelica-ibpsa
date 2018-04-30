within IDEAS.Buildings.Components.Shading.Interfaces.Records;
record HorizontalFins "Horizontal fins shading"
  extends ShadingProperties(controlled=false, shaType=ShadingType.HorizontalFins);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HorizontalFins;
