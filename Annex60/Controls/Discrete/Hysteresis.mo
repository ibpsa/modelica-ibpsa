within Annex60.Controls.Discrete;
model Hysteresis "Hysteresis controller with additional options"
  extends Modelica.Blocks.Icons.PartialBooleanBlock;

  parameter Boolean invert = false
    "Set to true if the hysteresis returns true when u < uLow instead of u > uHigh (for example for heating put revert = true)"
    annotation(Evaluate=true);
  parameter Boolean y_start = false "Output of controller at initial time"
    annotation(Dialog(group="Initialization"));
  parameter Real uLow_val = 0 "Lower bound value"
    annotation(dialog(enable=not useBoundInput and not useHysDelta));
  parameter Real uHigh_val = 1 "Higher bound value"
    annotation(dialog(enable=not useBoundInput));
  parameter Boolean useHysDelta = false
    "If true, lower bound parameter/input is disabled and equal to 'upper bound - hysDelta'"
    annotation(Dialog(group="Bound options"));
  parameter Real hysDelta(min=0) = 1
    "Delta when using a constant hysteresis difference"
    annotation(Dialog(enable=useHysDelta, group="Bound options"));
  parameter Boolean useBoundInput = false
    "If true, use realInputs uLow and uHigh instead of parameters"
    annotation(Dialog(group="Bound options"), Evaluate=true);
  parameter Boolean useOnOffInput = false
    "Set to true to switch device on/off using boolean input 'on'"
    annotation(Dialog(group="On/off options"));
  parameter Boolean onOff=true "Set to true if device is on"
  annotation (Evaluate=true,Dialog(enable= not useOnOffInput,group="On/off options"));
  parameter Boolean offOutput = false "Output of the controller when it is off"
    annotation(Dialog(enable=useOnOffInput or (not useOnOffInput and not onOff),group="On/off options"));

  Modelica.Blocks.Interfaces.BooleanInput on if useOnOffInput annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,118})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(extent={
            {-140,-20},{-100,20}}, rotation=0)));
  Modelica.Blocks.Interfaces.BooleanOutput y annotation (Placement(transformation(
          extent={{100,-10},{120,10}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput uLow if useBoundInput and not useHysDelta
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput uHigh if useBoundInput
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
protected
  Modelica.Blocks.Interfaces.RealInput uLow_internal
    "Required for connecting to conditional connector";
  Modelica.Blocks.Interfaces.RealInput uHigh_internal
    "Required for connecting to conditional connector";
  Modelica.Blocks.Interfaces.BooleanInput on_internal
    "Required for connecting to conditional connector";
initial equation
  pre(y) = y_start;
equation
  //connection of conditional inputs:
  connect(uLow,uLow_internal);
  connect(uHigh,uHigh_internal);
  if not useBoundInput then
    uHigh_internal = uHigh_val;
  end if;
  if useHysDelta then
      uLow_internal = uHigh_internal - hysDelta;
  elseif not useBoundInput then
      uLow_internal = uLow_val;
  end if;

  connect(on,on_internal);
  if not useOnOffInput then
    on_internal=onOff;
  end if;

  //hysteresis functionality:
  if on_internal then
    if invert then
      y = u < uHigh_internal and pre(y) or u <= uLow_internal;
    else
      y = u > uHigh_internal or pre(y) and u >= uLow_internal;
    end if;
  else
    y = offOutput;
  end if;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics={Ellipse(
          extent={{32,190},{84,120}},
          lineColor={201,170,90},
          fillColor={249,228,142},
          fillPattern=FillPattern.Sphere),
        Line(
          points={{32,158},{38,168},{44,158},{52,168},{58,156},{66,168},{72,158},
              {78,168},{84,158}},
          color={230,83,99},
          thickness=3),
        Line(
          points={{34,168},{40,178},{44,168},{52,178},{58,168},{64,178},{70,170},
              {76,178},{82,170}},
          color={44,111,164},
          thickness=2),
        Ellipse(
          extent={{33,155},{37,151}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{39,152},{43,148}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{45,150},{49,146}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{52,148},{56,144}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{58,148},{62,144}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{64,149},{68,145}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{70,151},{74,147}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{75,154},{79,150}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{80,157},{84,153}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{34,140},{58,134},{34,140}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{32,144},{38,142},{44,140},{48,140},{52,140},{56,140},{60,140},
              {66,140},{70,140},{74,142},{78,144},{84,148},{82,140},{80,138},{76,
              134},{72,132},{66,130},{62,130},{56,130},{52,130},{48,130},{44,132},
              {40,134},{34,136},{34,140},{32,144}},
          lineColor={11,105,127},
          pattern=LinePattern.None,
          fillColor={17,150,180},
          fillPattern=FillPattern.Sphere),
        Line(
          points={{38,132},{48,126},{56,124},{62,124},{68,126},{80,134}},
          color={35,80,120},
          thickness=2),
        Ellipse(
          extent={{37,140},{41,136}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={200,50,80},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{44,137},{48,133}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={200,50,80},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{50,136},{54,132}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={200,50,80},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{56,136},{60,132}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={200,50,80},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{63,136},{67,132}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={200,50,80},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{69,138},{73,134}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={200,50,80},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{75,141},{79,137}},
          pattern=LinePattern.None,
          lineThickness=1,
          fillColor={200,50,80},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,190},{86,120}},
          lineThickness=3,
          lineColor={241,242,242}),
        Text(
          extent={{-46,182},{22,146}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Easter egg ! ->"),
        Text(
          extent={{-60,160},{36,140}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fontSize=11,
          textString="With proper (Belgian) chocolate")}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Line(points={{-80,68},{-80,-29}},
          color={192,192,192}),Polygon(
          points={{92,-29},{70,-21},{70,-37},{92,-29}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Line(points={{-79,-29},{84,-29}},
          color={192,192,192}),Line(points={{-79,-29},{41,-29}}, color={0,0,0}),
          Line(points={{-15,-21},{1,-29},{-15,-36}}, color={0,0,0}),Line(points=
           {{41,51},{41,-29}}, color={0,0,0}),Line(points={{33,3},{41,22},{50,3}},
          color={0,0,0}),Line(points={{-49,51},{81,51}}, color={0,0,0}),Line(
          points={{-4,59},{-19,51},{-4,43}}, color={0,0,0}),Line(points={{-59,
          29},{-49,11},{-39,29}}, color={0,0,0}),Line(points={{-49,51},{-49,-29}},
          color={0,0,0}),Text(
          extent={{-92,-49},{-9,-92}},
          lineColor={192,192,192},
          textString="%uLow"),Text(
          extent={{2,-49},{91,-92}},
          lineColor={192,192,192},
          textString="%uHigh"),Rectangle(extent={{-91,-49},{-8,-92}}, lineColor=
           {192,192,192}),Line(points={{-49,-29},{-49,-49}}, color={192,192,192}),
          Rectangle(extent={{2,-49},{91,-92}}, lineColor={192,192,192}),Line(
          points={{41,-29},{41,-49}}, color={192,192,192})}),
    Documentation(info="<html>
<p>
This model contains a flexible implementation of a hysteresis controller. 
By default the behaviour of this model is the same as Modelica.Blocks.Logical.Hysteresis, 
but additional options exist.
</p>
<h4>Main equations</h4>
<p>
The default behaviour of this model is that of a normal hysteresis controller:
</p>
<pre>
y = u > uHigh or pre(y) and u >= uLow;
</pre>
<p>
However this behaviour can change by using additional options.
</p>
<h4>Typical use and important parameters</h4>
<p>
A typical use of this model is to check if a temperature is within certain bounds.
If the temperature is above the upper bound then the output will become true, 
which may turn on a cooler.
The temperature would then drop but the cooler will only be turned off when the temperature drops
below the lower bound.
</p>
<h4>Options</h4>
<p>
The controller can use bound inputs <code>uLow</code> and <code>uHigh</code> 
instead of parameters <code>uLow_val</code> and <code>uHigh_val</code>. 
It can also be disabled using a boolean input <code>on</code> by setting
<code>useOnOffInput=true</code>. 
The output is then set to the parameter value of <code>offOutput</code>. 
There also exists an option (<code>useHysDelta=true</code>) to set the width of the hysteresis 
band instead of defining both an upper and a lower bound.
The lower bound then equals the upper bound minus <code>hysDelta</code>.
</p>
<h4>References</h4>
<p>
http://i.imgur.com/FhwfMlM.png
</p>
</html>",
  revisions="<html>
<ul>
<li>
September 19, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end Hysteresis;
