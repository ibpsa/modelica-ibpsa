within IDEAS.Buildings.Components.Shading.Interfaces.Records;
record Overhang "Roof overhangs"
  extends ShadingProperties(controlled=false, shaType=ShadingType.Overhang);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Overhang;
