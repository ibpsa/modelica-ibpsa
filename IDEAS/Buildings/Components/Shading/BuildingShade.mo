within IDEAS.Buildings.Components.Shading;
model BuildingShade
  "Component for modeling shade cast by distant objects such as buildings and treelines"
  extends IDEAS.Buildings.Components.Shading.Interfaces.PartialShading(
                                                             final controlled=false);
  parameter Modelica.SIunits.Length L "Distance to object perpendicular to window";
  parameter Modelica.SIunits.Length dh
    "Height difference between top of object and top of window";
  parameter Modelica.SIunits.Length hWin = 1 "Window height";


protected
  final parameter Modelica.SIunits.Angle rot = 0
    "Rotation angle of opposite building. Zero when parallel, positive when rotated clockwise"
    annotation(Evaluate=true);
  Real tanZen = tan(min(angZen, Modelica.Constants.pi/2.01));
  Modelica.SIunits.Length L1 "Horizontal distance to object when following vertical plane through sun ray";
  Modelica.SIunits.Length L2 "Distance to object, taking into account sun position";
  Modelica.SIunits.Angle alt = (Modelica.Constants.pi/2) - angZen;
  Modelica.SIunits.Angle verAzi
    "Angle between projection of sun's rays and normal to vertical surface";

equation
  verAzi = Modelica.Math.acos(cos(angInc)/cos(alt));

  L1 = L/cos(verAzi);
//   if abs(rot)<1e-4 then
    //L2=L/cosAzi;
  L2 = L1/cos(alt);
//   else
//     //implementation for rot not equal to zero has not been completed nor validated!
//     if angAzi-azi>rot then
//       L2=L/cosAzi*(1+sin(abs(angAzi-azi))*sin(abs(rot))/sin(Modelica.Constants.pi-abs(angAzi-azi)-Modelica.Constants.pi/2-abs(rot)));
//     else
//       L2=L*(cosAzi+sin(abs(angAzi-azi))*tan(abs(angAzi-azi)-abs(rot)));
//     end if;
//   end if;
  if noEvent(tanZen > L2/dh) then
    iSolDir=0;
  elseif noEvent(tanZen > L2/(dh+hWin)) then
    iSolDir=solDir * (L2/tanZen-dh)/hWin;
  else
    iSolDir=solDir;
  end if;

  iSolDif = solDif;
  angInc = iAngInc;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},{50,100}}),
        graphics),
    Diagram(graphics),
    Documentation(info="<html>
<p>
This model computes the shading cast by a building at 
distance L and height dh on a window with height hWin.
Diffuse solar radiation is unaffected by this model. 
</p>
<p><img src=\"modelica://IDEAS/Resources/Images/Buildings/Components/Shading/BuildingShade.png\"/></p>
<h4>Limitations</h4>
<p>
This model assumes that the obstructing object is very wide 
compared to the window
and that it is parallel to the window. 
This model is inaccurate when this is not the case.
</p>
</html>", revisions="<html>
<ul>
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
