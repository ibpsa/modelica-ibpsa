within IDEAS.Buildings.Components.Shading.Interfaces.Records;
record None "No solar shading"
  extends ShadingProperties(controlled=false, shaType=ShadingType.None);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;
