within IDEAS.Buildings.Components.Shading;
model OverhangAndScreen "Roof overhangs and screen shading"

  parameter SI.Length hWin "Window height";
  parameter SI.Length wWin "Window width";
  parameter SI.Length wLeft
    "Left overhang width measured from the window corner";
  parameter SI.Length wRight
    "Right overhang width measured from the window corner";
  parameter SI.Length dep "Overhang depth perpendicular to the wall plane";
  parameter SI.Length gap
    "Distance between window upper edge and overhang lower edge";
  parameter Real shaCorr=0.24 "Shortwave transmittance of shortwave radiation";

  extends IDEAS.Buildings.Components.Interfaces.DoubleShading(
      redeclare IDEAS.Buildings.Components.Shading.Screen stateShading1(
        azi=azi,
        shaCorr=shaCorr),
      redeclare IDEAS.Buildings.Components.Shading.Overhang stateShading2(
        azi=azi,
        hWin=hWin,
        wWin=wWin,
        wLeft=wLeft,
        wRight=wRight,
        dep=dep,
        gap=gap));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Documentation(info="<html>
<p>This model describes the transient behaviour of solar irradiance on a window below a non-fixed horizontal or vertical overhang combined with a controllable screen.</p>
</html>", revisions="<html>
<ul>
<li>
July 2015, by Filip Jorissenr:<br/>
Now extending from IDEAS.Buildings.Components.Interfaces.DoubleShading.
</li>
<li>
December 2014, by Filip Jorissenr:<br/>
First implementation.
</li>
</ul>
</html>"));
end OverhangAndScreen;
