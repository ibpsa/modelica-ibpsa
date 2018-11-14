within IBPSA.Utilities.IO.RESTClient;
block Send_Real "Block that sends the model output to the external server"
  extends IBPSA.Utilities.IO.RESTClient.BaseClasses.PartialSocketClient(final numberVariable=1,final nameVariable={nameSig});
  parameter String nameSig = "control"
    "Signal name";
  parameter String unitSig[numberVariable] = {"none"}
    "Variable unit";
  parameter Modelica.SIunits.Time samplePeriod=config.samplePeriod
    "Sample period";
  Modelica.Blocks.Interfaces.RealInput u
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Real message[numberVariable](each start=0)
    "Floar array to be sent to the external source";


protected
  Modelica.SIunits.Time actualSamplePeriod(start=config.samplePeriod)
    "Actual sample period";

algorithm
    when (time>=nextSampleTime and activate_internal) then
      if (activation == IBPSA.Utilities.IO.RESTClient.Types.LocalActivation.global) then
            actualSamplePeriod:=config.samplePeriod;
      else  actualSamplePeriod:=samplePeriod;
      end if;
      nextSampleTime:=IBPSA.Utilities.IO.RESTClient.BaseClasses.Round(nextSampleTime+actualSamplePeriod,1);
      IBPSA.Utilities.IO.RESTClient.BaseClasses.SocClientSend(
      numberVariable,
      message,
      nameVariable,
      unitSig,
      time,
      hosAddress,
      tcpPort);
      message[1]:=u;

    end when;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-88,54},{94,-32}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(points={{-80,22},{-76,32},{-70,42},{-62,48},{-50,48},{-42,42},{-36,
              34},{-32,22},{-32,2},{-26,-10},{-14,-14},{-4,-14},{6,-6},{10,6},{
              14,16},{16,22},{18,30},{20,40},{24,46},{30,50},{42,48},{48,42},{
              52,34},{56,24},{58,16},{62,8},{64,2},{72,-6},{82,-12},{88,-6},{92,
              0},{94,6}},
                       color={28,108,200}),
        Text(
          extent={{-66,-56},{66,-94}},
          lineColor={28,108,200},
          textString="Sampler")}), Documentation(info="<html>
<p>This block samples time series, and sends them to the socket server. </p>
<p>Please noted that the message received by the socket server will be with a json format:</p>
<p>{ name &QUOT;string&QUOT;: </p>
<p>{ &QUOT;type&QUOT;: &ldquo;Double|Boolean|Integer&rdquo;, </p>
<p>&QUOT;unit&QUOT;: &QUOT;string&QUOT;, </p>
<p>&QUOT;time&QUOT;: &ldquo;double&rdquo; </p>
<p>}</p>
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
end Send_Real;
