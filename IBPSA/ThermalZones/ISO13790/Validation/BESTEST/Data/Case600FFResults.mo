within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Data;
record Case600FFResults "BESTEST comparison results free-floating"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Temperature TavgMax=299.25 "Maximum average annual air temperature";
  parameter Modelica.Units.SI.Temperature TavgMin=297.45 "Minimum average annual air temperature";
  annotation (defaultComponentName="annComBESTESTFF",Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
BESTEST results for annual heating and cooling loads in free-floating mode.
</p>
</html>",
revisions="<html>
<ul>
<li>
Mar 15, 2023, by Jianjun Hu:<br/>
Updated the maximum and minimum values based on ASHRAE 140-2020.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1750\">issue 1750</a>.
</li>
</ul>
</html>"));
end Case600FFResults;
