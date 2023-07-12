within IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses;
partial model PartialSafetyWithErrors
   "Safety control which adds an error counter to the I/O"
  extends PartialSafety;

  Modelica.Blocks.Logical.Switch swiErr
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
        rotation=0,
        origin={90,-100})));
  Modelica.Blocks.Interfaces.IntegerOutput err
    "Integer for displaying number off Errors during simulation"
                                               annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, rotation=0,
        origin={130,-100})));
  Modelica.Blocks.Logical.Not notVal "=true indicates a error"
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-110})));
  Modelica.Blocks.Sources.IntegerConstant intConOne(final k=1)
    "Used for display of current error"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=180,
        origin={50,-100})));
  Modelica.Blocks.Routing.BooleanPassThrough booPasThr
    "Used to keep the connection to the counter"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(conZer.y,swiErr. u3) annotation (Line(points={{61,-30},{70,-30},{70,
          -8},{78,-8}},     color={0,0,127}));
  connect(disErr.y,err)  annotation (Line(points={{102,-100},{130,-100}},
                                                 color={255,127,0}));
  connect(notVal.y, disErr.trigger) annotation (Line(points={{21,-110},{36,-110},
          {36,-118},{84,-118},{84,-112}},
                                  color={255,0,255}));
  connect(intConOne.y, disErr.u) annotation (Line(points={{61,-100},{76,-100}},
                   color={255,127,0}));
  connect(booPasThr.y, swiErr.u2)
    annotation (Line(points={{61,0},{78,0}}, color={255,0,255}));
  connect(booPasThr.y, notVal.u) annotation (Line(points={{61,0},{68,0},{68,-12},
          {-8,-12},{-8,-110},{-2,-110}},    color={255,0,255}));
  connect(swiErr.y, yOut) annotation (Line(points={{101,0},{110,0},{110,20},{
          130,20}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Adds the output <code>err</code>, which informs about the 
  number of errors in the specific safety block.
  Required as not all safety controls will inform about the error
  but most.
</p>
</html>"));
end PartialSafetyWithErrors;
