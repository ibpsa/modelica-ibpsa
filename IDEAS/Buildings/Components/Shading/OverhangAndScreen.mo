within IDEAS.Buildings.Components.Shading;
model OverhangAndScreen "Roof overhangs and screen shading"
  extends IDEAS.Buildings.Components.Interfaces.StateShading(final controled=true);

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

  IDEAS.Buildings.Components.Shading.Screen screen(
  azi=azi,
  shaCorr=shaCorr)
    annotation (Placement(transformation(extent={{-16,-20},{-4,2}})));
  IDEAS.Buildings.Components.Shading.Overhang overhang(
    azi=azi,
    hWin=hWin,
    wWin=wWin,
    wLeft=wLeft,
    wRight=wRight,
    dep=dep,
    gap=gap) annotation (Placement(transformation(extent={{-34,-20},{-24,2}})));

equation
  connect(overhang.solDir, solDir) annotation (Line(
      points={{-34,-2.4},{-34,50},{-60,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.solDif, solDif) annotation (Line(
      points={{-34,-6.8},{-36,-6.8},{-36,10},{-60,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.angInc, angInc) annotation (Line(
      points={{-34,-13.4},{-40,-13.4},{-40,-50},{-60,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.angZen, angZen) annotation (Line(
      points={{-34,-15.6},{-38,-15.6},{-38,-70},{-60,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.angAzi, angAzi) annotation (Line(
      points={{-34,-17.8},{-36,-17.8},{-36,-90},{-60,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.solDir, overhang.iSolDir) annotation (Line(
      points={{-16,-2.4},{-24,-2.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.iSolDif, screen.solDif) annotation (Line(
      points={{-24,-6.8},{-16,-6.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.angZen, angZen) annotation (Line(
      points={{-16,-15.6},{-16,-16},{-20,-16},{-20,-70},{-60,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.angAzi, angAzi) annotation (Line(
      points={{-16,-17.8},{-16,-90},{-60,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.iSolDir, iSolDir) annotation (Line(
      points={{-4,-2.4},{12,-2.4},{12,50},{40,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.iSolDif, iSolDif) annotation (Line(
      points={{-4,-6.8},{16,-6.8},{16,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.iAngInc, iAngInc) annotation (Line(
      points={{-4,-15.6},{12,-15.6},{12,-70},{40,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Ctrl, screen.Ctrl) annotation (Line(
      points={{-10,-110},{-10,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.iAngInc, screen.angInc) annotation (Line(
      points={{-24,-15.6},{-24,-16},{-22,-16},{-22,-13.4},{-16,-13.4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Documentation(info="<html>
<p>This model describes the transient behaviour of solar irradiance on a window below a non-fixed horizontal or vertical overhang combined with a controllable screen.</p>
</html>", revisions="<html>
<ul>
<li>
December 2014, by Filip Jorissenr:<br/>
First implementation.
</li>
</ul>
</html>"));
end OverhangAndScreen;
