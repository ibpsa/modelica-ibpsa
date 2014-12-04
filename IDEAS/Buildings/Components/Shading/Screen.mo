within IDEAS.Buildings.Components.Shading;
model Screen "Exterior screen"
  extends IDEAS.Buildings.Components.Interfaces.StateShading(final controlled=true);

  parameter Real shaCorr=0.24 "Shortwave transmittance of shortwave radiation";

protected
  Modelica.Blocks.Nonlinear.Limiter limiter(
    uMax=1,
    uMin=0,
    limitsAtInit=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-60})));

equation
  iSolDir = solDir*(1 - limiter.y);
  iSolDif = solDif*(1 - limiter.y) + solDif*limiter.y*shaCorr + solDir*limiter.y
    *shaCorr;
  angInc = iAngInc;

  connect(limiter.u, Ctrl) annotation (Line(
      points={{-10,-72},{-10,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},{50,100}}),
        graphics),
    Diagram(graphics),
    Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>Screen.mo</code> model describes the transient behaviour of solar irradiance on a window behind a solar screen parallel to the window.</p>
</html>"));
end Screen;
