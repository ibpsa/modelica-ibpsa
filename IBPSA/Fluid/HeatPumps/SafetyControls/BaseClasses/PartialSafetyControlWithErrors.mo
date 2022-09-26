within IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses;
partial block PartialSafetyControlWithErrors "Safety control which adds an error counter to the I/O"
  extends PartialSafetyControl;

  Modelica.Blocks.Logical.Switch       swiErr
    "If an error occurs, the value of the conZero block will be used(0)"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.Blocks.Sources.Constant conZer(final k=0)
    "If an error occurs, the compressor speed is set to zero"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Blocks.MathInteger.TriggeredAdd disErr(
    y_start=0,
    use_reset=false,
    use_set=false) "Used to show if the error was triggered"
                                                         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-100})));
  Modelica.Blocks.Interfaces.IntegerOutput ERR
    "Integer for displaying number off Errors during simulation"
                                               annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-130})));
  Modelica.Blocks.Logical.Not not1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-100})));
  Modelica.Blocks.Sources.IntegerConstant intConOne(final k=1)
    "Used for display of current error"
    annotation (Placement(transformation(extent={{60,-110},{40,-90}})));
  Modelica.Blocks.Routing.BooleanPassThrough booleanPassThrough
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(conZer.y,swiErr. u3) annotation (Line(points={{61,-30},{70,-30},{70,
          -8},{78,-8}},     color={0,0,127}));
  connect(disErr.y, ERR) annotation (Line(points={{-2.22045e-15,-112},{
          -2.22045e-15,-119},{0,-119},{0,-130}}, color={255,127,0}));
  connect(not1.y, disErr.trigger) annotation (Line(points={{-19,-100},{-12,
          -100},{-12,-94}},     color={255,0,255}));
  connect(intConOne.y, disErr.u) annotation (Line(points={{39,-100},{20,-100},
          {20,-78},{0,-78},{0,-86}},
                   color={255,127,0}));
  connect(booleanPassThrough.y, swiErr.u2)
    annotation (Line(points={{61,0},{78,0}}, color={255,0,255}));
  connect(booleanPassThrough.y, not1.u) annotation (Line(points={{61,0},{66,0},{
          66,-74},{-48,-74},{-48,-100},{-42,-100}}, color={255,0,255}));
  connect(swiErr.y, yOut) annotation (Line(points={{101,0},{110,0},{110,20},{
          130,20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})),      Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Partial block for a safety control. Based on the signals in the
  sigBusHP either the input signals are equal to the output signals or,
  if an error occurs, set to 0.
</p>
<p>
  The Output ERR informs about the number of errors in the specific
  safety block.
</p>
</html>"));
end PartialSafetyControlWithErrors;
