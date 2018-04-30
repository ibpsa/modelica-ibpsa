within IDEAS.Buildings.Components.Shading.Interfaces.Records;
record Shading
  "Model that allows to select any shading option based on record"
  extends ShadingProperties(shaType=ShadingType.Shading);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Shading;
