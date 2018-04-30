within IDEAS.Buildings.Components.Shading.Interfaces.Records;
record OverhangAndScreen "Roof overhangs and screen shading"
  extends ShadingProperties(shaType=ShadingType.OverhangAndScreen);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OverhangAndScreen;
