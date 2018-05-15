within IDEAS.LIDEAS.Examples;
model ZoneWithInputsCreateOutputs_customWeather
  extends ZoneWithInputsCreateOutputs(redeclare BaseClasses.SimInfoManagerInputs sim(
                                   lineariseDymola=false, createOutputs=true));
annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -160},{100,100}})),           __Dymola_Commands(file=
          "Scripts/createOutputs_zoneWithInputsCreateOutputs_customWeather.mos" "Create outputs"),
    Documentation(revisions="<html>
<ul>
<li>
April 5, 2018 by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>This is the model which generates the inputs for the linearised model from LIDEAS.Examples.zoneWithInputsLinearise. The model will automatically include the weather disturbances and the prescribed variables.</p>
<p>In order to create the file, use the <i>Create output</i> command from the Dymola Commands menu.</p>
</html>"),
    Icon(coordinateSystem(extent={{-100,-160},{100,100}})));
end ZoneWithInputsCreateOutputs_customWeather;
