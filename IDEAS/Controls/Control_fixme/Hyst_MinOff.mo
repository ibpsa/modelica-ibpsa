within IDEAS.Controls.Control_fixme;
block Hyst_MinOff "Hysteresis, with Real in- and output and min off-time"

  extends Modelica.Blocks.Interfaces.partialBooleanBlockIcon;
  parameter Real uLow;
  parameter Real uHigh;
  parameter Modelica.SIunits.Time minOffTime=0;

  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
protected
  Hyst_NoEvent3 hyst(uLow=uLow, uHigh=uHigh)
    annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
  IDEAS.Controls.Control_fixme.MinOffTimer_Events timerOff(duration=minOffTime)
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
public
  output Real error;

algorithm
  error := hyst.error;
  y := min(hyst.y, timerOff.y);

equation
  connect(u, hyst.u) annotation (Line(
      points={{-108,0},{-54.8,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hyst.y, timerOff.u) annotation (Line(
      points={{-33.4,0},{-4,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Placement(transformation(extent={{18,56},{38,76}})),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
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
    Documentation(info="<HTML>
<p>
This block transforms a <b>Real</b> input signal into a <b>Boolean</b>
output signal:
</p>
<ul>
<li> When the output was <b>false</b> and the input becomes
     <b>greater</b> than parameter <b>uHigh</b>, the output
     switches to <b>true</b>.</li>
<li> When the output was <b>true</b> and the input becomes
     <b>less</b> than parameter <b>uLow</b>, the output
     switches to <b>false</b>.</li>
</ul>
<p>
The start value of the output is defined via parameter
<b>pre_y_start</b> (= value of pre(y) at initial time).
The default value of this parameter is <b>false</b>.
</p>
</HTML>
"));
end Hyst_MinOff;
