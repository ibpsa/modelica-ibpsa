within IBPSA.Utilities.IO.RESTClient;
block Sampler_Real "the block to send the model output to the external party"
  extends IBPSA.Utilities.IO.RESTClient.BaseClasses.PartialSocketClient;

equation
  t0 = 0;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-88,54},{92,-6}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(points={{-80,22},{-76,32},{-70,42},{-62,48},{-50,48},{-42,42},{-36,
              34},{-32,22},{-28,12},{-22,6},{-14,-2},{-4,-4},{4,-2},{10,6},{14,
              16},{16,22},{18,30},{20,40},{24,46},{30,50},{42,48},{48,42},{52,
              34},{56,24},{58,16},{62,8},{64,4},{72,-2},{78,-4},{84,-2},{90,2},
              {92,6}}, color={28,108,200}),
        Text(
          extent={{-62,-22},{70,-60}},
          lineColor={28,108,200},
          textString="Sampler")}), Documentation(info="<html>
<p>Block that samples time series, and sends them to the remoted server. Please noted that the information received by the remoted server will be a string with delimiter as &QUOT;,&QUOT;. </p>
</html>"));
end Sampler_Real;
