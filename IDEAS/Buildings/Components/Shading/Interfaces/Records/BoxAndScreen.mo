within IDEAS.Buildings.Components.Shading.Interfaces.Records;
record BoxAndScreen "Box and screen shading"
  extends ShadingProperties(shaType=ShadingType.BoxAndScreen);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BoxAndScreen;
