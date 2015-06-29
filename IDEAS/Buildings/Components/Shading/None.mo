within IDEAS.Buildings.Components.Shading;
model None "No solar shadeing"
  extends IDEAS.Buildings.Components.Interfaces.StateShading(final controlled=false);

equation
  connect(solDir, iSolDir) annotation (Line(
      points={{-60,50},{40,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solDif, iSolDif) annotation (Line(
      points={{-60,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(angInc, iAngInc) annotation (Line(
      points={{-60,-50},{-16,-50},{-16,-50},{40,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end None;
