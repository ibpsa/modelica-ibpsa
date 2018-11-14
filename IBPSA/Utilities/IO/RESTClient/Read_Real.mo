within IBPSA.Utilities.IO.RESTClient;
block Read_Real "Block that receives model input from an external server"
  extends IBPSA.Utilities.IO.RESTClient.BaseClasses.PartialSocketClient(final numberVariable=1,final nameVariable={overVariable});

  parameter String overVariable = "control"
    "Signal name";
  Modelica.SIunits.Time nextSampleTimeEP(start=(if t0 > 0 then floor(0.5+t0) else ceil(t0-0.5)))
    "Next sample time from user";
  Modelica.Blocks.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-14},{128,14}})));
  Modelica.Blocks.Interfaces.RealInput u(start= 0)
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Real derivativeVariable[numberVariable](each start= 0)
    "Overwriting derivative signals";
  Real valueVariable[numberVariable](each start= 0)
    "Overwriting signals";
  Boolean enableFlag[numberVariable](each start=false)
    "Overwritten signals";
  Modelica.SIunits.Time timeRecord(start= 0);
  Real ystart;

protected
  Modelica.SIunits.Time actualSamplePeriod(start=config.samplePeriod)
    "Actual sample period";


algorithm
    when (time>=nextSampleTime and activate_internal) then
      if enableFlag[1] then
          ystart:=valueVariable[1];
      else
          ystart:=u;
      end if;

      (valueVariable,nextSampleTimeEP,enableFlag,derivativeVariable):=IBPSA.Utilities.IO.RESTClient.BaseClasses.SocClientReci(
       numberVariable,
       nameVariable,
       time,
       hosAddress,
       tcpPort);
       timeRecord:=time;


      if (activation == IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.global) then
         actualSamplePeriod:=config.samplePeriod;
      else
         actualSamplePeriod:=nextSampleTimeEP-nextSampleTime;
      end if;
      nextSampleTime:=IBPSA.Utilities.IO.RESTClient.BaseClasses.Round(nextSampleTime+actualSamplePeriod,1);
    end when;


initial equation
  y=u;
  ystart=u;
equation
      if enableFlag[1] and abs(derivativeVariable[1])>Modelica.Constants.eps then
         y=(time-timeRecord)*derivativeVariable[1]+ystart;
    elseif enableFlag[1] then
         y=valueVariable[1];
    else y=u;
    end if;
    annotation (Placement(transformation(extent={{-94,10},{-74,30}})),
                Placement(transformation(extent={{-50,-8},{-34,8}})),
              Icon(graphics={
        Rectangle(
          extent={{-88,54},{92,-6}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(points={{-80,22},{-76,32},{-70,42},{-62,48},{-50,48},{-42,42},{-36,34},{-32,22},{-28,
              12},{-22,6},{-14,-2},{-4,-4},{4,-2},{10,6},{14,16},{16,22},{18,30},{20,40},{24,46},
              {30,50},{42,48},{48,42},{52,34},{56,24},{58,16},{62,8},{64,4},{72,-2},{78,-4},{84,
              -2},{90,2},{92,6}}, color={28,108,200}),
        Text(
          extent={{-62,-22},{70,-60}},
          lineColor={28,108,200},
          textString="Overwritten"),
        Line(
          points={{-22,6},{-22,30},{92,30}},
          color={255,0,0},
          thickness=0.5)}), Documentation(info="<html>
<p>Block that receives input signals from a socket server. </p>
<p>The message that this block is expected shall have the following format:</p>
<p>{ name &ldquo;string&rdquo;: </p>
<p>{ type: &ldquo;double|boolean|integer&rdquo;,</p>
<p>value: &ldquo;double|boolean|int&rdquo;, </p>
<p>derivative: &ldquo;double&rdquo;, // optional</p>
<p>enable: &ldquo;boolean&rdquo;, // if false, value will be ignored and the input to the block will be sent to its output</p>
<p>nextSampleTime: &ldquo;s&rdquo;, // optional: next sample time in second of model time }</p>
<p>}</p>
<p>};</p>
<p>In addition, the folllowing message is used to notify the window for overwriting is avaiable:</p>
<p>{ name &ldquo;string&rdquo;,</p>
<p>time &ldquo;double&rdquo; </p>
<p>}.</p>
</html>", revisions="<html>
<ul>
<li>
Nov 12, 2018 by Sen Huang:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/926\">#926</a>.
</li>
</ul>
</html>"));
end Read_Real;
