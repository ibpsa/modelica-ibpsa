within IDEAS.Buildings.Components.Shading.Interfaces;
model DoubleShading "Two shading components in series"
  extends PartialShading(
    final controlled=stateShading1.controlled or
        stateShading2.controlled);
  replaceable PartialShading stateShading1 constrainedby PartialShading(azi=azi)
    "First shading device"
    annotation (Placement(transformation(extent={{-28,-18},{-18,2}})));
  replaceable PartialShading stateShading2 constrainedby PartialShading(azi=azi)
    "Second shading device"
    annotation (Placement(transformation(extent={{-4,-18},{6,2}})));

equation
  connect(stateShading1.solDir, solDir) annotation (Line(points={{-28,-2},{-32,-2},
          {-32,50},{-60,50}}, color={0,0,127}));
  connect(stateShading1.solDif, solDif) annotation (Line(points={{-28,-6},{-34,-6},
          {-34,10},{-60,10}}, color={0,0,127}));
  connect(stateShading1.angInc, angInc) annotation (Line(points={{-28,-12},{-34,
          -12},{-34,-50},{-60,-50}}, color={0,0,127}));
  connect(stateShading1.angAzi, angAzi) annotation (Line(points={{-28,-16},{-30,
          -16},{-30,-90},{-60,-90}}, color={0,0,127}));
  connect(stateShading1.angZen, angZen) annotation (Line(points={{-28,-14},{-32,
          -14},{-32,-16},{-32,-70},{-60,-70}}, color={0,0,127}));
  connect(Ctrl, stateShading1.Ctrl) annotation (Line(points={{-10,-110},{-10,-80},
          {-23,-80},{-23,-18}}, color={0,0,127}));
  connect(Ctrl,stateShading2. Ctrl) annotation (Line(points={{-10,-110},{-10,-80},
          {1,-80},{1,-18}}, color={0,0,127}));
  connect(stateShading1.angAzi, stateShading2.angAzi)
    annotation (Line(points={{-28,-16},{-4,-16}}, color={0,0,127}));
  connect(stateShading1.angZen, stateShading2.angZen)
    annotation (Line(points={{-28,-14},{-16,-14},{-4,-14}}, color={0,0,127}));
  connect(stateShading1.iAngInc, stateShading2.angInc)
    annotation (Line(points={{-18,-12},{-11,-12},{-4,-12}}, color={0,0,127}));
  connect(stateShading2.iAngInc, iAngInc) annotation (Line(points={{6,-12},{14,-12},
          {14,-50},{40,-50}}, color={0,0,127}));
  connect(stateShading2.iSolDif, iSolDif) annotation (Line(points={{6,-6},{14,-6},
          {14,10},{40,10}}, color={0,0,127}));
  connect(stateShading2.iSolDir, iSolDir) annotation (Line(points={{6,-2},{12,-2},
          {12,50},{40,50}}, color={0,0,127}));
  connect(stateShading1.iSolDif, stateShading2.solDif)
    annotation (Line(points={{-18,-6},{-12,-6},{-4,-6}}, color={0,0,127}));
  connect(stateShading1.iSolDir, stateShading2.solDir)
    annotation (Line(points={{-18,-2},{-11,-2},{-4,-2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(revisions="<html>
<ul>
<li>
July 18, 2016 by Filip Jorissen:<br/>
Cleaned up implementation and documentation.
</li>
<li>
December 2014, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This model can be extended or used if two shading models need to be combined.</p>
</html>"));
end DoubleShading;
