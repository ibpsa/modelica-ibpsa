within IDEAS.Buildings.Components.Shading;
model Box "Both side fins and overhang"
  extends IDEAS.Buildings.Components.Shading.Interfaces.PartialShading(
                                                             final controlled=false);

  parameter Modelica.SIunits.Length hWin(min=0) "Window height"
    annotation(Dialog(group="Window properties"));
  parameter Modelica.SIunits.Length wWin(min=0) "Window width"
    annotation(Dialog(group="Window properties"));

  parameter Modelica.SIunits.Length wLeft(min=0)
    "Left overhang width measured from the window corner"
    annotation(Dialog(group="Overhang properties"));
  parameter Modelica.SIunits.Length wRight(min=0)
    "Right overhang width measured from the window corner"
    annotation(Dialog(group="Overhang properties"));
  parameter Modelica.SIunits.Length ovDep(min=0)
    "Overhang depth perpendicular to the wall plane"
    annotation(Dialog(group="Overhang properties"));
  parameter Modelica.SIunits.Length ovGap(min=0)
    "Distance between window upper edge and overhang lower edge"
    annotation(Dialog(group="Overhang properties"));

  parameter Modelica.SIunits.Length hFin(min=0)
    "Height of side fin above window"
    annotation(Dialog(group="Side fin properties"));
  parameter Modelica.SIunits.Length finDep(min=0)
    "Side fin depth perpendicular to the wall plane"
    annotation(Dialog(group="Side fin properties"));
  parameter Modelica.SIunits.Length finGap(min=0)
    "Vertical distance between side fin and window"
    annotation(Dialog(group="Side fin properties"));

  Real fraSun(
    final min=0,
    final max=1,
    final unit="1")
    "Fraction of window area exposed to the sun";

  IDEAS.Buildings.Components.Shading.Overhang overhang(
    final azi=azi,
    final hWin=hWin,
    final wWin=wWin,
    final wLeft=wLeft,
    final wRight=wRight,
    final dep=ovDep,
    final gap=ovGap)
    annotation (Placement(transformation(extent={{-2,60},{8,80}})));
  IDEAS.Buildings.Components.Shading.SideFins sideFins(
    final azi=azi,
    final hWin=hWin,
    final wWin=wWin,
    final hFin=hFin,
    final dep=finDep,
    final gap=finGap)
    annotation (Placement(transformation(extent={{-4,20},{6,40}})));
protected
    final parameter Modelica.SIunits.Area aWin = hWin*wWin "Window area";
initial equation

    assert(ovDep > 0, "The depth of the overhang must be larger than zero. If this is not the case, just use Shading.SideFins");
    assert(finDep > 0, "The depth of the side fins must be larger than zero. If this is not the case, just use Shading.Overhang");

equation
  fraSun = max(0,1-(1-overhang.fraSun)-(1-sideFins.fraSun));
  iSolDir = solDir * fraSun;

  connect(solDif, iSolDif) annotation (Line(
      points={{-60,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angInc, iAngInc) annotation (Line(
      points={{-60,-50},{-16,-50},{-16,-50},{40,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDir, overhang.solDir) annotation (Line(
      points={{-60,50},{-39,50},{-39,76},{-2,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDir, sideFins.solDir) annotation (Line(
      points={{-60,50},{-40,50},{-40,36},{-4,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDif, overhang.solDif) annotation (Line(
      points={{-60,10},{-60,10},{-36,10},{-36,72},{-2,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDif, sideFins.solDif) annotation (Line(
      points={{-60,10},{-36,10},{-36,32},{-4,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.angZen, angZen) annotation (Line(
      points={{-2,64},{-30,64},{-30,-70},{-60,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sideFins.angInc, angInc) annotation (Line(
      points={{-4,26},{-32,26},{-32,-50},{-60,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sideFins.angZen, angZen) annotation (Line(
      points={{-4,24},{-30,24},{-30,-70},{-60,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sideFins.angAzi, angAzi) annotation (Line(
      points={{-4,22},{-28,22},{-28,-90},{-60,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.angAzi, angAzi) annotation (Line(
      points={{-2,62},{-28,62},{-28,-90},{-60,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.angInc, angInc) annotation (Line(
      points={{-2,66},{-32,66},{-32,-50},{-60,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Documentation(info="<html>
<p>Shading model that simulates a combination of both side fins and a overhang. The implementation is simply a combination of both IDEAS.Buildings.Components.Shading.Overhang and IDEAS.Buildings.Components.Shading.SideFins.</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2016 by Filip Jorissen:<br/>
Cleaned up implementation and documentation.
</li>
</ul>
</html>"));
end Box;
