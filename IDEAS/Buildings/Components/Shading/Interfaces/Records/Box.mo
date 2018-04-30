within IDEAS.Buildings.Components.Shading.Interfaces.Records;
record Box "Both side fins and overhangs"
  extends ShadingProperties(controlled=false, shaType=ShadingType.Box);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Box;
