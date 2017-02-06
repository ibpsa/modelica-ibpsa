within IDEAS.Buildings.Components.Shading;
model SideFins "Vertical side fins next to windows"
  extends IDEAS.Buildings.Components.Shading.Interfaces.PartialShading(
                                                             final controlled=false);

  // Window properties
  parameter Modelica.SIunits.Length hWin
    "Window height"
    annotation(Dialog(group="Window properties"));
  parameter Modelica.SIunits.Length wWin
    "Window width"
    annotation(Dialog(group="Window properties"));


  // Sidefin properties
  parameter Modelica.SIunits.Length hFin
    "Height of side fin above window"
    annotation(Dialog(group="Side fin properties"));
  parameter Modelica.SIunits.Length dep
    "Side fin depth perpendicular to the wall plane"
    annotation(Dialog(group="Side fin properties"));
  parameter Modelica.SIunits.Length gap
    "Vertical distance between side fin and window"
    annotation(Dialog(group="Side fin properties"));

  Real fraSun(final min=0,final max=1, final unit="1")
    "Fraction of window area exposed to the sun";

protected
  final parameter Modelica.SIunits.Area AWin= hWin*wWin "Window area";
  final parameter Modelica.SIunits.Length tmpH[4] = {hFin+hWin,hFin,hFin+hWin,hFin}
    "Height rectangular sections used for superposition";
  final parameter Modelica.SIunits.Length tmpW[4] = {gap+wWin,gap+wWin,gap,gap}
    "Width rectangular sections used for superposition";

  Modelica.SIunits.Length x1[4]
    "Horizontal distance between side fin and point where shadow line and window lower edge intersects";
  Modelica.SIunits.Length x2
    "Horizontal distance between side fin and shadow corner";
  Modelica.SIunits.Length x3[4] "Window width";
  Modelica.SIunits.Length y1[4] "Window height";
  Modelica.SIunits.Length y2
    "Vertical distance between window upper edge and shadow corner";
  Modelica.SIunits.Length y3[4]
    "Vertical distance between window upper edge and point where shadow line and window side edge intersects";
  Modelica.SIunits.Area area[4]
    "Shaded areas of the sections used in superposition";
  Modelica.SIunits.Area shdArea "Shaded area";
  Modelica.SIunits.Area crShdArea "Final value of shaded area";
  Modelica.SIunits.Area crShdArea1
    "Shaded area, corrected for the sun behind the surface/wall";
  Modelica.SIunits.Area crShdArea2
    "Shaded area, corrected for the sun below horizon";
  Modelica.SIunits.Length minX[4];
  Modelica.SIunits.Length minY[4];
  Modelica.SIunits.Length minX2X3[4];
  Modelica.SIunits.Length minY2Y3[4];
  Real deltaL=1e-6 "Small number to avoid division by zero";
  Modelica.SIunits.Angle alt = (Modelica.Constants.pi/2) - angZen;

  Real verAzi;
  Real lambda;

initial equation

    assert(dep > 0, "The depth of the sidefins must be larger than zero.");

equation
  lambda = tan(alt) / cos(verAzi);
  verAzi = Modelica.Math.acos(cos(angInc)/cos(alt));
  y2*Modelica.Math.cos(verAzi) = dep*Modelica.Math.tan(alt);
  x2 = dep*Modelica.Math.tan(verAzi);

  for i in 1:4 loop
    x1[i] = tmpH[i]/lambda;
    x3[i] = tmpW[i];
    y1[i] = tmpH[i];
    y3[i] = tmpW[i]*lambda;
    minX2X3[i] = IDEAS.Utilities.Math.Functions.smoothMin(x1=x2,x2=x3[i],deltaX=deltaL);
    minX[i] = IDEAS.Utilities.Math.Functions.smoothMin(x1=x1[i],x2=minX2X3[i],deltaX=deltaL);
    minY2Y3[i] = IDEAS.Utilities.Math.Functions.smoothMin(x1=y2,x2=y3[i],deltaX=deltaL);
    minY[i] = IDEAS.Utilities.Math.Functions.smoothMin(x1=y1[i],x2=minY2Y3[i],deltaX=deltaL);
    area[i] = tmpH[i]*minX[i] - minX[i]*minY[i]/2;
  end for;
  shdArea = area[4] - area[3] - area[2] + area[1];
  // correction case: Sun not in front of the wall
  crShdArea1 = Modelica.Media.Air.MoistAir.Utilities.spliceFunction(pos=shdArea,neg=AWin,x=(Modelica.Constants.pi/2)-verAzi,deltax=0.01);
  // correction case: Sun not above horizon
  crShdArea2 = Modelica.Media.Air.MoistAir.Utilities.spliceFunction(pos=shdArea,neg=AWin,x=alt,deltax=0.01);
  crShdArea=IDEAS.Utilities.Math.Functions.smoothMax(x1=crShdArea1,x2=crShdArea2,deltaX=0.01);
  fraSun = IDEAS.Utilities.Math.Functions.smoothMin( x1=IDEAS.Utilities.Math.Functions.smoothMax(x1=1-crShdArea/AWin,x2=0,deltaX=0.01),x2=1.0,deltaX=0.01);

  iSolDir = solDir * fraSun;

  connect(solDif, iSolDif) annotation (Line(
      points={{-60,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(angInc, iAngInc) annotation (Line(
      points={{-60,-50},{-14,-50},{-14,-50},{40,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>Overhang.mo</code> model describes the transient behaviour of solar irradiance on a window below a non-fixed horizontal or vertical overhang.</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2016 by Filip Jorissen:<br/>
Cleaned up implementation and documentation.
</li>
</ul>
</html>"));
end SideFins;
