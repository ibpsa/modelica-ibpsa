within IDEAS.Buildings.Components.Shading;
model Screen "Exterior screen"
  extends IDEAS.Buildings.Components.Shading.Interfaces.PartialShading(
                                                             final controlled=true);

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
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},{50,100}})),
    Diagram(graphics),
    Documentation(info="<html>
<p>Shading model of a controllable screen. The transmitted direct solar irradiance varies linearly between [0, 1] with the control input. A fraction shaCorr is converted into diffuse light that enters the building.</p>
</html>", revisions="<html>
<ul>
<li>
July 18, 2016 by Filip Jorissen:<br/>
Cleaned up implementation and documentation.
</li>
</ul>
</html>"));
end Screen;
