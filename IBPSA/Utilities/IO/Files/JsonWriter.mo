within IBPSA.Utilities.IO.Files;
model JsonWriter "Model for writing results to a json file"
  extends Modelica.Blocks.Icons.DiscreteBlock;
  parameter Integer nin
    "Number of inputs"
    annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter String fileName = getInstanceName() + ".json"
    "File name, including extension";
  parameter String[nin] keyNames = {"key"+String(i) for i in 1:nin}
    "Key names, indices by default";
  parameter IBPSA.Utilities.IO.Files.BaseClasses.OutputTime outputTime=
    IBPSA.Utilities.IO.Files.BaseClasses.OutputTime.Terminal
    "Time when results are outputted"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Time customTime = 0
    "Custom time when results are stored, used if outputTime=Custom only"
    annotation(Dialog(enable=outputTime==IBPSA.Utilities.IO.Files.BaseClasses.OutputTime.Custom));

  Modelica.Blocks.Interfaces.RealVectorInput[nin] u "Variables that are saved"
     annotation (Placement(transformation(extent={{-120,20},{-80,-20}})));

equation
  if outputTime==IBPSA.Utilities.IO.Files.BaseClasses.OutputTime.Terminal then
    when terminal() then
      IBPSA.Utilities.IO.Files.BaseClasses.writeJson(fileName, keyNames, u);
    end when;
  end if;

  if outputTime==IBPSA.Utilities.IO.Files.BaseClasses.OutputTime.Initial then
    when initial() then
      IBPSA.Utilities.IO.Files.BaseClasses.writeJson(fileName, keyNames, u);
    end when;
  end if;

  if outputTime==IBPSA.Utilities.IO.Files.BaseClasses.OutputTime.Custom then
    when time>customTime then
      IBPSA.Utilities.IO.Files.BaseClasses.writeJson(fileName, keyNames, u);
    end when;
  end if;

  annotation (Documentation(info="<html>
<p>
This model samples the model inputs <code>u</code> and saves them to a json file.
</p>
<h4>Typical use and important parameters</h4>
<p>
The parameter <code>nin</code> defines the number of variables that are stored.
In Dymola, this parameter is updated automatically when inputs are connected to the component.
</p>
<p>
The parameter <code>fileName</code> defines to what file name the results
are saved. The file is in the current working directory,
unless an absolute path is provided.
</p>
<p>
The parameter <code>keyNames</code> defines the key names that are used to 
store the json values corresponding to the inputs <code>u</code>.
</p>
<h4>Dynamics</h4>
<p>
This model samples the outputs at one point in time and saves the results to file.
The point in time is determined by the parameter <code>outputTime</code>.
When <code>outputTime==OutputTime.Custom</code>, results are saved when the built-in variable
<code>time</code> exceeds <code>customTime</code>.
When <code>outputTime==OutputTime.Initial</code>, results are saved at initialisation.
When <code>outputTime==OutputTime.Terminal</code>, results are saved when terminating the simulation.
</p>
</html>", revisions="<html>
<ul>
<li>
April 9, 2019 by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1114\">#1114</a>.
</li>
</ul>
</html>"), Icon(graphics={                                                Text(
          extent={{-88,90},{88,48}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="JSON")}));
end JsonWriter;
