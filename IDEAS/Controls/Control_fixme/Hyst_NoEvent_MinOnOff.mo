within IDEAS.Controls.Control_fixme;
block Hyst_NoEvent_MinOnOff
  "Hysteresis without events, with Real in- and output and min on and off-times"

  // still not working as it should

  extends Modelica.Blocks.Interfaces.SISO(y(start=0));
  parameter Real uLow;
  parameter Real uHigh;
  parameter Modelica.SIunits.Time minOnTime=0;
  parameter Modelica.SIunits.Time minOffTime=0;

  IDEAS.Controls.Control_fixme.Timer_NoEvents offTimer(duration=if minOffTime
         > 0 then minOffTime else 666, timerType=IDEAS.Climate.Time.BaseClasses.TimerType.off)
    annotation (Placement(transformation(extent={{-44,28},{-24,48}})));
  IDEAS.Controls.Control_fixme.Timer_NoEvents onTimer(duration=if minOnTime > 0
         then minOnTime else 666, timerType=IDEAS.Climate.Time.BaseClasses.TimerType.on)
    annotation (Placement(transformation(extent={{-46,-20},{-26,0}})));
algorithm
  offTimer.u := y;
  onTimer.u := y;
equation
  if minOffTime > 0 and minOnTime > 0 then
    // both on- and off-timer
    if noEvent(u > uHigh and offTimer.y > 0.5) then
      y = 1;
    elseif noEvent(u >= uLow and y > 0.5) then
      y = 1;
    elseif noEvent(u < uLow and onTimer.y > 0.5) then
      y = 1;
    else
      y = 0;
    end if;
  elseif minOffTime > 0 and minOnTime <= 0 then
    // only off-timer
    if noEvent(u > uHigh and offTimer.y > 0.5) then
      y = 1;
    elseif noEvent(u > uLow and y > 0.5) then
      y = 1;
    else
      y = 0;
    end if;
  elseif minOffTime <= 0 and minOnTime > 0 then
    // only on-timer
    if noEvent(u > uHigh) then
      y = 1;
    elseif noEvent(u > uLow and y > 0.5) then
      y = 1;
    elseif noEvent(u < uLow and onTimer.y > 0.5) then
      y = 1;
    else
      y = 0;
    end if;

  else
    // no timers
    if noEvent(u > uHigh) then
      y = 1;
    elseif noEvent(u > uLow and y > 0.5) then
      y = 1;
    else
      y = 0;
    end if;
  end if;

  annotation (
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
          color={192,192,192}),Text(
          extent={{-92,-49},{-9,-92}},
          lineColor={192,192,192},
          textString="%uLow"),Text(
          extent={{2,-49},{91,-92}},
          lineColor={192,192,192},
          textString="%uHigh"),Rectangle(extent={{-91,-49},{-8,-92}}, lineColor=
           {192,192,192}),Line(points={{-49,-29},{-49,-49}}, color={192,192,192}),
          Rectangle(extent={{2,-49},{91,-92}}, lineColor={192,192,192}),Line(
          points={{41,-29},{41,-49}}, color={192,192,192}),Polygon(
          points={{-63,129},{-71,107},{-55,107},{-63,129}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Line(points={{-63,107},{-63,-41}},
          color={192,192,192}),Line(points={{-88,-30},{84,-30}}, color={192,192,
          192}),Polygon(
          points={{92,-30},{70,-22},{70,-38},{92,-30}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Text(
          extent={{72,-40},{96,-60}},
          lineColor={160,160,164},
          textString="u"),Text(
          extent={{-63,133},{-10,115}},
          lineColor={160,160,164},
          textString="y"),Line(
          points={{-78,-30},{32,-30}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-48,50},{-48,-30}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{32,50},{32,-30}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-8,-25},{2,-30},{-8,-35}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-8,55},{-18,50},{-8,45}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-53,20},{-48,10},{-42,20}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{27,10},{32,21},{37,10}},
          color={0,0,0},
          thickness=0.5),Text(
          extent={{-97,42},{-68,58}},
          lineColor={160,160,164},
          textString="true"),Text(
          extent={{-96,-47},{-64,-33}},
          lineColor={160,160,164},
          textString="false"),Text(
          extent={{21,-47},{46,-30}},
          lineColor={0,0,0},
          textString="uHigh"),Text(
          extent={{-61,-48},{-36,-31}},
          lineColor={0,0,0},
          textString="uLow"),Line(points={{-67,50},{-58,50}}, color={160,160,
          164}),Line(
          points={{32,50},{-48,50},{-46,50}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=0.5)}),
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
end Hyst_NoEvent_MinOnOff;
