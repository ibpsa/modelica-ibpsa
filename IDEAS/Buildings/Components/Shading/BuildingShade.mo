within IDEAS.Buildings.Components.Shading;
model BuildingShade
  "Component for modeling shade cast by distant objects such as buildings and treelines"
  extends IDEAS.Buildings.Components.Shading.Interfaces.PartialShading(
                                                             final controlled=false);
  parameter Modelica.SIunits.Length L "Horizontal distance to object";
  parameter Modelica.SIunits.Length dh
    "Height difference between top of object and top of window";
  parameter Modelica.SIunits.Length hWin = 1 "Window height";

  Real tanZen = tan(min(angZen, Modelica.Constants.pi/2.01));

equation
  if noEvent(tanZen > L/dh) then
    iSolDir=0;
  elseif noEvent(tanZen > L/(dh+hWin)) then
    iSolDir=solDir * (L/tanZen-dh)/hWin;
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
<p><img src=\"modelica://IDEAS/Images/BuildingShade.png\"/></p>
<h4>Limitations</h4>
<p>
This model assumes that the obstructing object is very wide 
compared to the window. 
This model is not accurate when this is not the case.
This is mostly a problem for south oriented windows.
</p>
</html>", revisions="<html>
<ul>
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
