within IDEAS.Buildings.Components.Shading.Interfaces.Records;
record Screen "Exterior screen"
  extends ShadingProperties(controlled=true, shaType=ShadingType.Screen);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Screen;
