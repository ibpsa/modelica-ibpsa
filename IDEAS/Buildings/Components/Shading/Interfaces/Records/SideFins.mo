within IDEAS.Buildings.Components.Shading.Interfaces.Records;
record SideFins "Vertical side fins next to windows"
  extends ShadingProperties(controlled=false, shaType=ShadingType.SideFins);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SideFins;
