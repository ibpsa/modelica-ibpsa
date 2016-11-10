within IDEAS.Buildings.Components.Shading.Interfaces;
record ShadingProperties
  extends Modelica.Icons.Record;
  parameter Boolean controlled=true
    "if true, shading has a control input"
    annotation(Evaluate=true);
  parameter IDEAS.Buildings.Components.Shading.Interfaces.ShadingType shaType=
      IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.None
    "Window shading type";

  parameter Modelica.SIunits.Length hWin(min=0, start=0) "Window height"
    annotation(Dialog(group="Window properties"));
  parameter Modelica.SIunits.Length wWin(min=0, start=0) "Window width"
    annotation(Dialog(group="Window properties"));

  parameter Modelica.SIunits.Length wLeft(min=0, start=0)
    "Left overhang width measured from the window corner"
    annotation(Dialog(group="Overhang properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Overhang or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.OverhangAndScreen)));
  parameter Modelica.SIunits.Length wRight(min=0, start=0)
    "Right overhang width measured from the window corner"
    annotation(Dialog(group="Overhang properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Overhang or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.OverhangAndScreen)));
  parameter Modelica.SIunits.Length ovDep(min=0, start=0)
    "Overhang depth perpendicular to the wall plane"
    annotation(Dialog(group="Overhang properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Overhang or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.OverhangAndScreen)));
  parameter Modelica.SIunits.Length ovGap(min=0, start=0)
    "Distance between window upper edge and overhang lower edge"
    annotation(Dialog(group="Overhang properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Overhang or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.OverhangAndScreen)));

  parameter Modelica.SIunits.Length hFin(min=0, start=0)
    "Height of side fin above window"
    annotation(Dialog(group="Side fin properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.SideFin or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box)));
  parameter Modelica.SIunits.Length finDep(min=0, start=0)
    "Side fin depth perpendicular to the wall plane"
    annotation(Dialog(group="Side fin properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.SideFin or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box)));
  parameter Modelica.SIunits.Length finGap(min=0, start=0)
    "Vertical distance between side fin and window"
    annotation(Dialog(group="Side fin properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.SideFin or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box)));

  parameter Modelica.SIunits.Length L(min=0, start=0)
    "Horizontal distance to object"
    annotation(Dialog(group="Building shade",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.BuildingShade)));
  parameter Modelica.SIunits.Length dh(min=0, start=0)
    "Height difference between top of object and top of window"
    annotation(Dialog(group="Building shade",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.BuildingShade)));

  parameter Real shaCorr(min=0)=0.24
    "Shortwave transmittance of shortwave radiation"
    annotation(Dialog(group="Screen",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Screen or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.OverhangAndScreen)));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ShadingProperties;
