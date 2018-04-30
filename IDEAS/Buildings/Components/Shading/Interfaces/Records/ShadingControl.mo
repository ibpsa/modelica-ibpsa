within IDEAS.Buildings.Components.Shading.Interfaces.Records;
record ShadingControl "shading control based on irradiation"
  extends ShadingProperties(shaType=ShadingType.ShadingControl);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ShadingControl;
