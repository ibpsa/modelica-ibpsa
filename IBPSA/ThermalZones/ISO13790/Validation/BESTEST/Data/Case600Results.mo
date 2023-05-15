within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Data;
record Case600Results "BESTEST comparison results"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Energy EHeaMax=4.504*3.6e9 "Maximum annual heating load";
  parameter Modelica.Units.SI.Energy EHeaMin=3.993*3.6e9 "Minimum annaul heating load";
  parameter Modelica.Units.SI.Energy ECooMax=-6.162*3.6e9 "Maximum annual cooling load";
  parameter Modelica.Units.SI.Energy ECooMin=-5.432*3.6e9 "Minimum annual cooling load";
  parameter Modelica.Units.SI.Power PHeaMax=3.359*1000 "Maximum peak heating load";
  parameter Modelica.Units.SI.Power PHeaMin=3.020*1000 "Minimum peak heating load";
  parameter Modelica.Units.SI.Power PCooMax=-6.481*1000 "Maximum peak cooling load";
  parameter Modelica.Units.SI.Power PCooMin=-5.422*1000 "Minimum peak cooling load";

  parameter Modelica.Units.SI.Energy heaMax=4.98*3.6e9
    "Maximum annual heating load of the test acceptance criteria defined in ASHRAE 140"
    annotation (Dialog(group="Test criteria limits"));
  parameter Modelica.Units.SI.Energy heaMin=3.75*3.6e9
    "Minimum annual heating load of the test acceptance criteria defined in ASHRAE 140"
    annotation (Dialog(group="Test criteria limits"));
  parameter Modelica.Units.SI.Energy cooMax=-6.83*3.6e9
    "Maximum annual cooling load of the test acceptance criteria defined in ASHRAE 140"
    annotation (Dialog(group="Test criteria limits"));
  parameter Modelica.Units.SI.Energy cooMin=-5.0*3.6e9
    "Minimum annual cooling load of the test acceptance criteria defined in ASHRAE 140"
    annotation (Dialog(group="Test criteria limits"));


  annotation (defaultComponentName="annComBESTEST",Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
BESTEST results for annual heating and cooling loads.
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
end Case600Results;
