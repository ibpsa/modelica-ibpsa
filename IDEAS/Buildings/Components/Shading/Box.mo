within IDEAS.Buildings.Components.Shading;
model Box "Both side fins and overhang"
  extends IDEAS.Buildings.Components.Interfaces.StateShading(final controlled=false);

  // Window properties
  parameter Modelica.SIunits.Length hWin "Window height";
  parameter Modelica.SIunits.Length wWin "Window width";
  final parameter Modelica.SIunits.Area aWin = hWin*wWin "Window area";

  // Overhang properties
  parameter Modelica.SIunits.Length wLeft
    "Left overhang width measured from the window corner";
  parameter Modelica.SIunits.Length wRight
    "Right overhang width measured from the window corner";
  parameter Modelica.SIunits.Length ovDep
    "Overhang depth perpendicular to the wall plane";
  parameter Modelica.SIunits.Length ovGap
    "Distance between window upper edge and overhang lower edge";

  // Sidefin properties
  parameter Modelica.SIunits.Length hFin "Height of side fin above window";
  parameter Modelica.SIunits.Length finDep
    "Overhang depth perpendicular to the wall plane";
  parameter Modelica.SIunits.Length finGap
    "Distance between window upper edge and overhang lower edge";

  Real fraSun(final min=0,final max=1, final unit="1")
    "Fraction of window area exposed to the sun";

  Overhang overhang(azi=azi,hWin=hWin,wWin=wWin,wLeft=wLeft,wRight=wRight,dep=ovDep,gap=ovGap)
    annotation (Placement(transformation(extent={{-2,60},{8,80}})));
  SideFins sideFins(azi=azi,hWin=hWin,wWin=wWin,hFin=hFin,dep=finDep,gap=finGap)
    annotation (Placement(transformation(extent={{-18,20},{-8,40}})));
equation

  fraSun = 1-(1-overhang.fraSun)-(1-sideFins.fraSun);
  iSolDir = solDir * fraSun;

  connect(solDif, iSolDif) annotation (Line(
      points={{-60,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angInc, iAngInc) annotation (Line(
      points={{-60,-50},{-16,-50},{-16,-70},{40,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDir, overhang.solDir) annotation (Line(
      points={{-60,50},{-39,50},{-39,76},{-2,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDir, sideFins.solDir) annotation (Line(
      points={{-60,50},{-40,50},{-40,36},{-18,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDif, overhang.solDif) annotation (Line(
      points={{-60,10},{-60,41},{-2,41},{-2,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDif, sideFins.solDif) annotation (Line(
      points={{-60,10},{-39,10},{-39,32},{-18,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.angZen, angZen) annotation (Line(
      points={{-2,64},{-26,64},{-26,0},{-60,0},{-60,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sideFins.angInc, angInc) annotation (Line(
      points={{-18,26},{-26,26},{-26,24},{-60,24},{-60,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sideFins.angZen, angZen) annotation (Line(
      points={{-18,24},{-34,24},{-34,-70},{-60,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sideFins.angAzi, angAzi) annotation (Line(
      points={{-18,22},{-34,22},{-34,-90},{-60,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.angAzi, angAzi) annotation (Line(
      points={{-2,62},{-34,62},{-34,-90},{-60,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.angInc, angInc) annotation (Line(
      points={{-2,66},{-26,66},{-26,-50},{-60,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics));
end Box;
