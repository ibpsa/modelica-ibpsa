within IDEAS.Buildings.Components.Shading;
model BuildingShade
  "Component for modeling shade cast by distant objects such as buildings and treelines"
  extends IDEAS.Buildings.Components.Shading.Interfaces.PartialShading(
    final controlled=false);

  parameter Modelica.SIunits.Length L "Distance to object perpendicular to window";
  parameter Modelica.SIunits.Length dh
    "Height difference between top of object and top of window";
  parameter Modelica.SIunits.Length hWin = 1 "Window height";
  final parameter Real fraSunDifSky(final min=0,final max=1, final unit="1") = 1-vieAngObj/(Modelica.Constants.pi/2)
    "Fraction of window area exposed to diffuse sun light";

  Real fraSunDir(final min=0,final max=1, final unit="1")
    "Fraction of window area exposed to direct sun light";

protected
  parameter Modelica.SIunits.Angle vieAngObj = atan(hWin/L) + atan(dh/L) "Viewing angle of opposite object";
  final parameter Modelica.SIunits.Angle rot = 0
    "Rotation angle of opposite building. Zero when parallel, positive when rotated clockwise"
    annotation(Evaluate=true);
  Real tanZen = tan(min(angZen, Modelica.Constants.pi/2.01));
  Modelica.SIunits.Length L1 "Horizontal distance to object when following vertical plane through sun ray";
  Modelica.SIunits.Length L2 "Distance to object, taking into account sun position";
  Modelica.SIunits.Angle alt = (Modelica.Constants.pi/2) - angZen;
  Modelica.SIunits.Angle verAzi
    "Angle between downward projection of sun's rays and normal to vertical surface";

equation
  verAzi = Modelica.Math.acos(cos(angInc)/cos(alt));

  L1 = max(0,L/cos(verAzi));
//   if abs(rot)<1e-4 then
    //L2=L/cosAzi;
  L2 = L1*tan(alt);
//   else
//     //implementation for rot not equal to zero has not been completed nor validated!
//     if angAzi-azi>rot then
//       L2=L/cosAzi*(1+sin(abs(angAzi-azi))*sin(abs(rot))/sin(Modelica.Constants.pi-abs(angAzi-azi)-Modelica.Constants.pi/2-abs(rot)));
//     else
//       L2=L*(cosAzi+sin(abs(angAzi-azi))*tan(abs(angAzi-azi)-abs(rot)));
//     end if;
//   end if;
  if noEvent(L2<dh) then
    fraSunDir=0;
  elseif noEvent(L2<dh+hWin) then
    fraSunDir=(L2-dh)/hWin;
  else
    fraSunDir=1;
  end if;

  HShaDirTil=fraSunDir*HDirTil;
  HShaSkyDifTil = fraSunDifSky*HSkyDifTil;
  connect(angInc, iAngInc) annotation (Line(points={{-60,-50},{-14,-50},{-14,-50},
          {40,-50}}, color={0,0,127}));

  connect(HGroDifTil, HShaGroDifTil)
    annotation (Line(points={{-60,10},{40,10},{40,10}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},{50,100}}),
        graphics),
    Documentation(info="<html>
<p>
This model computes the shading cast by a building (or other object) at 
distance <code>L</code> and relative height <code>dh</code> 
on a window with height <code>hWin</code>.
Diffuse sky solar radiation is reduced
by computing a simplified view factor of the building,
which blocks the sky view.
Diffuse ground solar radiation is unaffected by this model. 
</p>
<p><img alt=\"illustration\" src=\"modelica://IDEAS/Resources/Images/Buildings/Components/Shading/BuildingShade.png\"/></p>
<h4>Assumption and limitations</h4>
<p>
This model assumes that the obstructing object is very wide 
compared to the window
and that it is parallel to the window. 
This model is inaccurate when this is not the case.
</p>
<p>
We assume that the opposite building is shaded or that its reflectivity is zero,
such that it does not reflect diffuse solar irradiation towards
the window.
</p>
</html>", revisions="<html>
<ul>
<li>
May 26, 2017 by Filip Jorissen:<br/>
Added computation of diffuse solar shading.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/735\">
#735</a>.
</li>
<li>
May 25, 2017, by Filip Jorissen:<br/>
Fixed implementation for non-south oriented windows.
</li>
<li>
December 9, 2016, by Filip Jorissen:<br/>
Fixed implementation for non-circular type building.
</li>
<li>
July 14, 2015, by Filip Jorissen:<br/>
Added documentation.
</li>
<li>
June 12, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingShade;
