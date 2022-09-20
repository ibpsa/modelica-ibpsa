within IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses;
block BoundaryMap
  "Block which returns false if the input parameters are out of the given charasteristic map.
For the boundaries of the y-input value, a dynamic hysteresis is used to ensure a used device will stay off a certain time after shutdown."
  extends IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses.BoundaryMapIcon(
      final iconMin=-70, final iconMax=70);
  parameter Real dx "Delta value used for both upper and lower hysteresis. Used to avoid state events when used as a safety control."
    annotation (Dialog(tab="Safety Control", group="Operational Envelope"));
  Modelica.Blocks.Interfaces.BooleanOutput noErr
    "If an error occurs, this will be false"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput x_in "Current value of x-Axis"
    annotation (Placement(transformation(extent={{-128,46},{-100,74}})));
  Modelica.Blocks.Interfaces.RealInput y_in "Current value on y-Axis"
    annotation (Placement(transformation(extent={{-128,-74},{-100,-46}})));

  Modelica.Blocks.Tables.CombiTable1Ds uppCombiTable1Ds(
    final table=tableUpp_internal,
    final smoothness= Modelica.Blocks.Types.Smoothness.LinearSegments,
    final tableOnFile=false)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.MathBoolean.Nor
                             nor1(
                                 nu=3)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  IBPSA.Utilities.Logical.DynamicHysteresis lessUpp(final pre_y_start=false)
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Logical.Less lessLef
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Logical.Greater greaterRig
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Modelica.Blocks.Sources.Constant conXMin(k=xMin)
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.Constant conXMax(k=xMax)
    annotation (Placement(transformation(extent={{-58,-98},{-40,-80}})));

  Modelica.Blocks.Math.Add addUpp(final k2=-1)
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Constant constDx(final k=dx)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  connect(x_in, uppCombiTable1Ds.u)
    annotation (Line(points={{-114,60},{-70,60},{-70,70},{-62,70}},
                                                  color={0,0,127}));
  connect(nor1.y, noErr)
    annotation (Line(points={{81.5,0},{110,0}}, color={255,0,255}));
  connect(lessUpp.y, nor1.u[1]) annotation (Line(points={{41,70},{50,70},{50,
          -2.33333},{60,-2.33333}},
                      color={255,0,255}));
  connect(lessLef.y, nor1.u[2]) annotation (Line(points={{41,-30},{50,-30},{
          50,0},{60,0}},      color={255,0,255}));
  connect(greaterRig.y, nor1.u[3]) annotation (Line(points={{41,-70},{50,-70},
          {50,2.33333},{60,2.33333}},
                                  color={255,0,255}));
  connect(x_in, lessLef.u1) annotation (Line(points={{-114,60},{-72,60},{-72,
          -30},{18,-30}},
                 color={0,0,127}));
  connect(x_in, greaterRig.u1) annotation (Line(points={{-114,60},{-72,60},{
          -72,-30},{-64,-30},{-64,-70},{18,-70}},
                     color={0,0,127}));
  connect(conXMax.y, greaterRig.u2) annotation (Line(points={{-39.1,-89},{10,
          -89},{10,-78},{18,-78}},
                          color={0,0,127}));
  connect(conXMin.y, lessLef.u2) annotation (Line(points={{-39,-50},{-10,-50},
          {-10,-38},{18,-38}},
                          color={0,0,127}));
  connect(y_in, lessUpp.u) annotation (Line(points={{-114,-60},{-90,-60},{-90,
          94},{12,94},{12,70},{18,70}},
                   color={0,0,127}));
  connect(uppCombiTable1Ds.y[1], lessUpp.uHigh) annotation (Line(points={{-39,70},
          {8,70},{8,52},{33,52},{33,58}}, color={0,0,127}));
  connect(lessUpp.uLow, addUpp.y) annotation (Line(points={{25,58},{24,58},{
          24,50},{1,50}},
                      color={0,0,127}));
  connect(uppCombiTable1Ds.y[1], addUpp.u1) annotation (Line(points={{-39,70},
          {-34,70},{-34,56},{-22,56}},
                                  color={0,0,127}));
  connect(addUpp.u2, constDx.y) annotation (Line(points={{-22,44},{-34,44},{
          -34,30},{-39,30}},
                           color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html><p>
  Given an input of the x and y-Axis, the block returns true if the
  given point is outside of the given envelope.
</p>
<p>
  The maximal and minmal y-value depend on the x-Value and are defined
  by the upper and lower boundaries in form of 1Ds-Tables. The maximal
  and minimal x-values are obtained trough the table and are constant.
</p>
<ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end BoundaryMap;
