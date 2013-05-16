within IDEAS.Buildings.Components.Shading;
model ScreenOverhang "Roof overhangs with exterior screen"
  extends IDEAS.Buildings.Components.Interfaces.StateShading(controled=true);

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

  parameter Real shaCorr=0.24 "Shortwave transmittance of shortwave radiation";

protected
  Overhang overhang(
    H=H,
    W=W,
    PH=PH,
    RH=RH,
    PV=PV,
    RW=RW) annotation (Placement(transformation(extent={{-42,-24},{-32,-4}})));
  Screen screen(shaCorr=shaCorr)
    annotation (Placement(transformation(extent={{-14,-24},{-4,-4}})));
equation

  connect(overhang.iAngInc, screen.angInc) annotation (Line(
      points={{-32,-20},{-26,-20},{-26,-18},{-14,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.iSolDif, screen.solDif) annotation (Line(
      points={{-32,-12},{-14,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(overhang.iSolDir, screen.solDir) annotation (Line(
      points={{-32,-8},{-14,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.Ctrl, Ctrl) annotation (Line(
      points={{-9,-24},{-10,-24},{-10,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.iAngInc, iAngInc) annotation (Line(
      points={{-4,-20},{12,-20},{12,-70},{40,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDif, overhang.solDif) annotation (Line(
      points={{-60,10},{-60,10},{-54,10},{-54,-12},{-42,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDir, overhang.solDir) annotation (Line(
      points={{-60,50},{-52,50},{-52,-8},{-42,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angInc, overhang.angInc) annotation (Line(
      points={{-60,-50},{-50,-50},{-50,-18},{-42,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angZen, overhang.angZen) annotation (Line(
      points={{-60,-70},{-48,-70},{-48,-20},{-42,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angAzi, overhang.angAzi) annotation (Line(
      points={{-60,-90},{-46,-90},{-46,-22},{-42,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.iSolDir, iSolDir) annotation (Line(
      points={{-4,-8},{8,-8},{8,50},{40,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(screen.iSolDif, iSolDif) annotation (Line(
      points={{-4,-12},{12,-12},{12,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angZen, screen.angZen) annotation (Line(
      points={{-60,-70},{-24,-70},{-24,-20},{-14,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angAzi, screen.angAzi) annotation (Line(
      points={{-60,-90},{-22,-90},{-22,-22},{-14,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h4>Goal</h4></p>
<p>The <code>ScreenOverhang.mo</code> model describes the transient behaviour of solar irradiance on a window behind a solar screen parallel to the window below a non-fixed horizontal or vertical overhang.</p>
</html>"));
end ScreenOverhang;
