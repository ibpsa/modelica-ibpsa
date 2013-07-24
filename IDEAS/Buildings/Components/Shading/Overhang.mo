within IDEAS.Buildings.Components.Shading;
model Overhang "Roof overhangs"
  extends IDEAS.Buildings.Components.Interfaces.StateShading(controled=false);

  parameter Modelica.SIunits.Length H "Window height";
  parameter Modelica.SIunits.Length W "Window width";
  parameter Modelica.SIunits.Length PH
    "Horizontal projection of overhang above window";
  parameter Modelica.SIunits.Length RH
    "Height of horizontal projection above window";
  parameter Modelica.SIunits.Length PV
    "Vertical projections of overhang  besides window";
  parameter Modelica.SIunits.Length RW
    "Width of vertical projections besides window";

  //protected
  Modelica.SIunits.Length SW "Shadow width by the horizontal projections";
  Modelica.SIunits.Length SH "Shadow height by the vertical projections";
  Modelica.SIunits.Area ASL "Sunlit area";
  Modelica.SIunits.Area ASH "Shaded area";
  Real tanSha "Tangent of the shadow angle";

equation
  tanSha = tan(Modelica.Constants.pi - angZen)/cos(angAzi);
  SW = min(PV*abs(tan(angAzi)), W + RW);
  SH = min(PH*abs(tanSha), H + RH);
  ASL = (W - (SW - RW))*(H - (SH - RH));
  ASH = W*H - ASL;

  iSolDir = min(solDir, solDir*ASL/W/H);

  connect(solDif, iSolDif) annotation (Line(
      points={{-60,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angInc, iAngInc) annotation (Line(
      points={{-60,-50},{-14,-50},{-14,-70},{40,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>Overhang.mo</code> model describes the transient behaviour of solar irradiance on a window below a non-fixed horizontal or vertical overhang.</p>
</html>"));
end Overhang;
