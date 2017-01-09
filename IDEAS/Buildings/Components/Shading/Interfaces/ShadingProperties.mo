within IDEAS.Buildings.Components.Shading.Interfaces;
record ShadingProperties
  "Default: no shading"
  extends Modelica.Icons.Record;
  parameter Boolean controlled=false
    "if true, shading has a control input"
    annotation(Evaluate=true);
  parameter IDEAS.Buildings.Components.Shading.Interfaces.ShadingType shaType=
      IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.None
    "Window shading type";

  parameter Modelica.SIunits.Length hWin(min=0, start=0)=0.01 "Window height"
    annotation(Dialog(group="Window properties"));
  parameter Modelica.SIunits.Length wWin(min=0, start=0)=0.01 "Window width"
    annotation(Dialog(group="Window properties"));

  parameter Modelica.SIunits.Length wLeft(min=0, start=0)=0.01
    "Left overhang width measured from the window corner"
    annotation(Dialog(group="Overhang properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Overhang or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.OverhangAndScreen)));
  parameter Modelica.SIunits.Length wRight(min=0, start=0)=0.01
    "Right overhang width measured from the window corner"
    annotation(Dialog(group="Overhang properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Overhang or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.OverhangAndScreen)));
  parameter Modelica.SIunits.Length ovDep(min=0, start=0)=0.01
    "Overhang depth perpendicular to the wall plane"
    annotation(Dialog(group="Overhang properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Overhang or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.OverhangAndScreen)));
  parameter Modelica.SIunits.Length ovGap(min=0, start=0)=0.01
    "Distance between window upper edge and overhang lower edge"
    annotation(Dialog(group="Overhang properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Overhang or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.OverhangAndScreen)));

  parameter Modelica.SIunits.Length hFin(min=0, start=0)=0.01
    "Height of side fin above window"
    annotation(Dialog(group="Side fin properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.SideFin or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box)));
  parameter Modelica.SIunits.Length finDep(min=0, start=0)=0.01
    "Side fin depth perpendicular to the wall plane"
    annotation(Dialog(group="Side fin properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.SideFin or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box)));
  parameter Modelica.SIunits.Length finGap(min=0, start=0)=0.01
    "Vertical distance between side fin and window"
    annotation(Dialog(group="Side fin properties",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.SideFin or
                               shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.Box)));

  parameter Modelica.SIunits.Length L(min=0, start=0)=0.01
    "Horizontal distance to object"
    annotation(Dialog(group="Building shade",
                      enable= (shaType==IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.BuildingShade)));
  parameter Modelica.SIunits.Length dh(min=0, start=0)=0.01
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
