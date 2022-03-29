within IBPSA.Fluid.HeatPumps.Controls;
package BaseClasses
  "Package with base classes for IBPSA.Controls.HeatPump.SafetyControls"

  block BoundaryMap
    "Block which returns false if the input parameters are out of the given charasteristic map.
For the boundaries of the y-input value, a dynamic hysteresis is used to ensure a used device will stay off a certain time after shutdown."
    extends IBPSA.Fluid.HeatPumps.Controls.BaseClasses.BoundaryMapIcon(final
        iconMin=-70, final iconMax=70);
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
      annotation (Placement(transformation(extent={{-48,68},{-28,88}})));
    Modelica.Blocks.MathBoolean.Nor
                               nor1(
                                   nu=3)
      annotation (Placement(transformation(extent={{72,-10},{92,10}})));
    IBPSA.Utilities.Logical.DynamicHysteresis lessUpp(final pre_y_start=false)
      annotation (Placement(transformation(extent={{30,68},{50,88}})));
    Modelica.Blocks.Logical.Less lessLef
      annotation (Placement(transformation(extent={{26,-40},{46,-20}})));
    Modelica.Blocks.Logical.Greater greaterRig
      annotation (Placement(transformation(extent={{26,-70},{46,-50}})));
    Modelica.Blocks.Sources.Constant conXMin(k=xMin)
      annotation (Placement(transformation(extent={{-50,-46},{-38,-34}})));
    Modelica.Blocks.Sources.Constant conXMax(k=xMax)
      annotation (Placement(transformation(extent={{-50,-76},{-38,-64}})));

    Modelica.Blocks.Math.Add addUpp(final k2=-1)
      annotation (Placement(transformation(extent={{-18,56},{-8,66}})));
    Modelica.Blocks.Sources.Constant constDx(final k=dx)
      annotation (Placement(transformation(extent={{-50,46},{-36,60}})));

  equation
    connect(x_in, uppCombiTable1Ds.u)
      annotation (Line(points={{-114,60},{-84,60},{-84,78},{-50,78}},
                                                    color={0,0,127}));
    connect(nor1.y, noErr)
      annotation (Line(points={{93.5,0},{110,0}}, color={255,0,255}));
    connect(lessUpp.y, nor1.u[1]) annotation (Line(points={{51,78},{64,78},{64,4.66667},
            {72,4.66667}},
                        color={255,0,255}));
    connect(lessLef.y, nor1.u[2]) annotation (Line(points={{47,-30},{64,-30},{64,2.22045e-16},
            {72,2.22045e-16}},  color={255,0,255}));
    connect(greaterRig.y, nor1.u[3]) annotation (Line(points={{47,-60},{64,-60},{64,
            -4.66667},{72,-4.66667}},
                                    color={255,0,255}));
    connect(x_in, lessLef.u1) annotation (Line(points={{-114,60},{-72,60},{-72,-30},
            {24,-30}},
                   color={0,0,127}));
    connect(x_in, greaterRig.u1) annotation (Line(points={{-114,60},{-72,60},{-72,
            -60},{24,-60}},
                       color={0,0,127}));
    connect(conXMax.y, greaterRig.u2) annotation (Line(points={{-37.4,-70},{-22,-70},
            {-22,-68},{24,-68}},
                            color={0,0,127}));
    connect(conXMin.y, lessLef.u2) annotation (Line(points={{-37.4,-40},{-24,-40},
            {-24,-38},{24,-38}},
                            color={0,0,127}));
    connect(y_in, lessUpp.u) annotation (Line(points={{-114,-60},{-114,-60},{-94,-60},
            {-94,-60},{-90,-60},{-90,100},{16,100},{16,78},{16,78},{16,78},{28,78},
            {28,78}},color={0,0,127}));
    connect(uppCombiTable1Ds.y[1], lessUpp.uHigh) annotation (Line(points={{-27,78},
            {6,78},{6,60},{43,60},{43,66}}, color={0,0,127}));
    connect(lessUpp.uLow, addUpp.y) annotation (Line(points={{35,66},{32,66},{32,61},
            {-7.5,61}}, color={0,0,127}));
    connect(uppCombiTable1Ds.y[1], addUpp.u1) annotation (Line(points={{-27,78},{-24,
            78},{-24,64},{-19,64}}, color={0,0,127}));
    connect(addUpp.u2, constDx.y) annotation (Line(points={{-19,58},{-26,58},{-26,
            53},{-35.3,53}}, color={0,0,127}));
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
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"),
        uses(AixLib(version="0.7.3"), Modelica(version="3.2.2")));
  end BoundaryMap;

  partial block BoundaryMapIcon "PartialModel for the icon of a boundary map"

    parameter Boolean use_opeEnvFroRec=true
      "Use a the operational envelope given in the datasheet" annotation(Dialog(tab="Safety Control", group="Operational Envelope"),choices(checkBox=true));
    parameter IBPSA.Fluid.HeatPumps.BlackBoxData.HeatPumpBaseDataDefinition
      dataTable "Data Table of HP" annotation (choicesAllMatching=true, Dialog(
        tab="Safety Control",
        group="Operational Envelope",
        enable=use_opeEnvFroRec));
    parameter Real tableUpp[:,2] "Table matrix (grid = first column; e.g., table=[0,2])"
      annotation (Dialog(tab="Safety Control", group="Operational Envelope", enable=not use_opeEnvFroRec));
    parameter Real iconMin=-70
      "Used to set the frame where the icon should appear"
      annotation (Dialog(tab="Dynamic Icon"));
    parameter Real iconMax = 70
      "Used to set the frame where the icon should appear"
      annotation (Dialog(tab="Dynamic Icon"));
  protected
    parameter Real tableUpp_internal[:,2] = if use_opeEnvFroRec then dataTable.tableUppBou else tableUpp;
    parameter Real xMax=tableUpp_internal[end, 1]
      "Maximal value of lower and upper table data";
    parameter Real xMin=tableUpp_internal[1, 1]
      "Minimal value of lower and upper table data";
    parameter Real yMax=max(tableUpp_internal[:, 2])
      "Maximal value of lower and upper table data";
    parameter Real yMin=0
      "Minimal value of lower and upper table data";
    final Real[size(scaledX, 1), 2] points=transpose({unScaledX,unScaledY}) annotation(Hide=false);
    Real tableMerge[:,2] = tableUpp_internal;
    input Real scaledX[:] = tableMerge[:,1];
    input Real scaledY[:] = tableMerge[:,2];
    Real unScaledX[size(scaledX, 1)](min=-100, max=100) = (scaledX - fill(xMin, size(scaledX, 1)))*(iconMax-iconMin)/(xMax - xMin) + fill(iconMin, size(scaledX,1));
    Real unScaledY[size(scaledX, 1)](min=-100, max=100) = (scaledY - fill(yMin, size(scaledY, 1)))*(iconMax-iconMin)/(yMax - yMin) + fill(iconMin, size(scaledY,1));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}),                                        graphics={
          Rectangle(
            extent={{iconMin-25,iconMax+25},{iconMax+25,iconMin-25}},
            lineColor={28,108,200},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Line(points=DynamicSelect({{-66,-66},{-66,50},{-44,66},
                {68,66},{68,-66},{-66,-66}},points),                          color={238,46,47},
            thickness=0.5),
          Polygon(
            points={{iconMin-20,iconMax},{iconMin-20,iconMax},{iconMin-10,iconMax},{iconMin-15,iconMax+20}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{iconMax+20,iconMin-10},{iconMax,iconMin-4},{iconMax,iconMin-16},{iconMax+20,iconMin-10}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Line(points={{iconMin-15,iconMax},{iconMin-15,iconMin-15}}, color={95,95,95}),
          Line(points={{iconMin-20,iconMin-10},{iconMax+10,iconMin-10}}, color={95,95,95})}), coordinateSystem(preserveAspectRatio=false), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>",   info="<html>
<p>
  Icon block used for the icon of the dynamic icon of the model
  <a href=\"modelica://IBPSA.Controls.HeatPump.SafetyControls.BaseClasses.BoundaryMap\">
  BoundaryMap</a>. Extending this model will display the used
  operational envelope in the top-layer of the used models.
</p>
</html>"));
  end BoundaryMapIcon;

  partial block PartialSafetyControl "Base Block"
    Modelica.Blocks.Interfaces.RealInput nSet
      "Set value relative speed of compressor. Analog from 0 to 1"
      annotation (Placement(transformation(extent={{-152,4},{-120,36}})));
    Modelica.Blocks.Interfaces.RealOutput nOut
      "Relative speed of compressor. From 0 to 1"
      annotation (Placement(transformation(extent={{120,10},{140,30}})));
    IBPSA.Utilities.Logical.SmoothSwitch swiErr
      "If an error occurs, the value of the conZero block will be used(0)"
      annotation (Placement(transformation(extent={{86,-10},{106,10}})));
    Modelica.Blocks.Sources.Constant conZer(final k=0)
      "If an error occurs, the compressor speed is set to zero"
      annotation (Placement(transformation(extent={{58,-24},{70,-12}})));
    IBPSA.Controls.Interfaces.VapourCompressionMachineControlBus sigBusHP
      "Bus-connector for the heat pump"
      annotation (Placement(transformation(extent={{-152,-84},{-118,-54}})));
    Modelica.Blocks.Interfaces.BooleanOutput modeOut
      "Heat pump mode, =true: heating, =false: chilling"
      annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
    Modelica.Blocks.Interfaces.BooleanInput modeSet "Set value of heat pump mode"
      annotation (Placement(transformation(extent={{-152,-36},{-120,-4}})));
    Modelica.Blocks.MathInteger.TriggeredAdd disErr(
      y_start=0,
      use_reset=false,
      use_set=false)
                 "Used to show if the error was triggered" annotation (Placement(
          transformation(
          extent={{-8,-8},{8,8}},
          rotation=270,
          origin={0,-80})));
    Modelica.Blocks.Interfaces.IntegerOutput ERR
      "Integer for displaying number off Errors during simulation"
                                                 annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={0,-110})));
    Modelica.Blocks.Logical.Not not1 annotation (Placement(transformation(
          extent={{-5,-5},{5,5}},
          rotation=270,
          origin={-21,-69})));
    Modelica.Blocks.Sources.IntegerConstant intConOne(final k=1)
      "Used for display of current error"
      annotation (Placement(transformation(extent={{36,-70},{24,-58}})));
  equation
    connect(conZer.y,swiErr. u3) annotation (Line(points={{70.6,-18},{78,-18},
            {78,-8},{84,-8}}, color={0,0,127}));
    connect(swiErr.y, nOut) annotation (Line(points={{107,0},{118,0},{118,20},{
            130,20}}, color={0,0,127}));
    connect(disErr.y, ERR) annotation (Line(points={{-1.77636e-15,-89.6},{
            -1.77636e-15,-100},{0,-100},{0,-110}}, color={255,127,0}));
    connect(not1.y, disErr.trigger) annotation (Line(points={{-21,-74.5},{-21,
            -75.2},{-9.6,-75.2}}, color={255,0,255}));
    connect(intConOne.y, disErr.u) annotation (Line(points={{23.4,-64},{0,-64},{0,
            -68.8}}, color={255,127,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{
              -120,-100},{120,100}}), graphics={
          Polygon(
            points={{-42,20},{0,62},{-42,20}},
            lineColor={28,108,200},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-48,-26},{48,66}},
            lineColor={0,0,0},
            fillColor={91,91,91},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-36,-14},{36,54}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-60,20},{60,-80}},
            lineColor={0,0,0},
            fillColor={91,91,91},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-10,-30},{10,-70}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-14,-40},{16,-12}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-104,100},{106,76}},
            lineColor={28,108,200},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.None,
            textString="%name"),
          Rectangle(
            extent={{-120,100},{120,-100}},
            lineColor={28,108,200},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.None)}),
                                       Diagram(coordinateSystem(
            preserveAspectRatio=false, extent={{-120,-100},{120,100}})),
      Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>",   info="<html>
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
  end PartialSafetyControl;

  block RunPerHouBoundary "Checks if a maximal run per hour value is in boundary"
    extends Modelica.Blocks.Interfaces.BooleanSISO;
    parameter Integer maxRunPer_h "Number of maximal on/off cycles per hour";
    parameter Modelica.Units.SI.Time delayTime(displayUnit="h") = 3600
      "Delay time of output with respect to input signal";
   Modelica.Blocks.Logical.LessThreshold
                                runCouLesMax(threshold=maxRunPer_h)
      "Checks if the count of total runs is lower than the maximal value"
      annotation (Placement(transformation(extent={{74,-8},{90,8}})));
    Modelica.Blocks.MathInteger.TriggeredAdd triggeredAdd
      annotation (Placement(transformation(extent={{-36,6},{-24,-6}})));
    Modelica.Blocks.Sources.IntegerConstant intConPluOne(final k=1)
      "Value for counting"
      annotation (Placement(transformation(extent={{-62,-6},{-50,6}})));
    Modelica.Blocks.Math.IntegerToReal intToReal
      annotation (Placement(transformation(extent={{-14,-6},{-2,6}})));
    Modelica.Blocks.Math.Add sub(k2=-1)
      annotation (Placement(transformation(extent={{44,0},{60,16}})));
    Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(final delayTime(displayUnit=
            "h") = delayTime)
                 annotation (Placement(transformation(extent={{14,-14},{24,-4}})));
  equation
    connect(intConPluOne.y, triggeredAdd.u)
      annotation (Line(points={{-49.4,0},{-38.4,0}}, color={255,127,0}));
    connect(intToReal.u, triggeredAdd.y)
      annotation (Line(points={{-15.2,0},{-22.8,0}}, color={255,127,0}));
    connect(intToReal.y, sub.u1) annotation (Line(points={{-1.4,0},{0.15,0},{0.15,
            12.8},{42.4,12.8}}, color={0,0,127}));
    connect(intToReal.y, fixedDelay.u)
      annotation (Line(points={{-1.4,0},{0,0},{0,-9},{13,-9}}, color={0,0,127}));
    connect(fixedDelay.y, sub.u2) annotation (Line(points={{24.5,-9},{34,-9},{34,3.2},
            {42.4,3.2}}, color={0,0,127}));
    connect(runCouLesMax.y, y)
      annotation (Line(points={{90.8,0},{110,0},{110,0}}, color={255,0,255}));
    connect(u, triggeredAdd.trigger) annotation (Line(points={{-120,0},{-82,0},{
            -82,24},{-33.6,24},{-33.6,7.2}}, color={255,0,255}));
    connect(sub.y, runCouLesMax.u) annotation (Line(points={{60.8,8},{68,8},{68,0},
            {72.4,0}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                  Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
          Line(points={{0,80},{0,60}}, color={160,160,164}),
          Line(points={{80,0},{60,0}}, color={160,160,164}),
          Line(points={{0,-80},{0,-60}}, color={160,160,164}),
          Line(points={{-80,0},{-60,0}}, color={160,160,164}),
          Line(points={{37,70},{26,50}}, color={160,160,164}),
          Line(points={{70,38},{49,26}}, color={160,160,164}),
          Line(points={{71,-37},{52,-27}}, color={160,160,164}),
          Line(points={{39,-70},{29,-51}}, color={160,160,164}),
          Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
          Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
          Line(points={{-71,37},{-54,28}}, color={160,160,164}),
          Line(points={{-38,70},{-28,51}}, color={160,160,164}),
          Line(
            points={{0,0},{-50,50}},
            thickness=0.5),
          Line(
            points={{0,0},{40,0}},
            thickness=0.5)}),                                      Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html><p>
  Everytime the boolean input signal has a rising edge, a counter is
  triggered and adds 1 to the total sum. This represents an on-turning
  of a certain device. With a delay this number is being substracted
  again, as this block counts the number of rising edges in a given
  amount of time(e.g. 1 hour). If this value is higher than a given
  maximal value, the output turns to false.
</p>
<ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"));
  end RunPerHouBoundary;

  block TimeControl
    "Counts seconds a device is turned on and returns true if the time is inside given boundaries"
    extends Modelica.Blocks.Interfaces.BooleanSISO;

    parameter Modelica.Units.SI.Time minRunTime
      "Minimal time the device is turned on or off";
    Modelica.Blocks.Logical.Timer runTim
      "Counts the seconds the heat pump is locked still"
      annotation (Placement(transformation(extent={{-22,-8},{-6,8}})));
    Modelica.Blocks.Logical.GreaterEqualThreshold
                                         runTimGreaterMin(final threshold=
          minRunTime)
      "Checks if the runtime is greater than the minimal runtime"
      annotation (Placement(transformation(extent={{22,-8},{36,8}})));
  equation
    connect(runTimGreaterMin.y, y)
      annotation (Line(points={{36.7,0},{110,0}}, color={255,0,255}));
    connect(u,runTim. u) annotation (Line(points={{-120,0},{-23.6,0}},
                        color={255,0,255}));
    connect(runTim.y, runTimGreaterMin.u)
      annotation (Line(points={{-5.2,0},{20.6,0}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                  Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
          Line(points={{0,80},{0,60}}, color={160,160,164}),
          Line(points={{80,0},{60,0}}, color={160,160,164}),
          Line(points={{0,-80},{0,-60}}, color={160,160,164}),
          Line(points={{-80,0},{-60,0}}, color={160,160,164}),
          Line(points={{37,70},{26,50}}, color={160,160,164}),
          Line(points={{70,38},{49,26}}, color={160,160,164}),
          Line(points={{71,-37},{52,-27}}, color={160,160,164}),
          Line(points={{39,-70},{29,-51}}, color={160,160,164}),
          Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
          Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
          Line(points={{-71,37},{-54,28}}, color={160,160,164}),
          Line(points={{-38,70},{-28,51}}, color={160,160,164}),
          Line(
            points={{0,0},{-50,50}},
            thickness=0.5),
          Line(
            points={{0,0},{40,0}},
            thickness=0.5)}),                                      Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html><p>
  When the input is true, a timer thats counting seconds until it is
  false again. As long as the counted time is smaller than a given
  minimal time, the block yields false.
</p>
<p>
  This block is used to check the mimimal run- or loctime of a device.
</p>
<ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"));
  end TimeControl;
annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Ellipse(
          extent={{-30.0,-30.0},{30.0,30.0}},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This package contains base classes that are used to construct the
  models in <a href=
  \"modelica://IBPSA.Controls.HeatPump.SafetyControls\">SafetyControls</a>
</p>
</html>"));
end BaseClasses;
