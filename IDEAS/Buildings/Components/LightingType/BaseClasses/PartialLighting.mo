within IDEAS.Buildings.Components.LightingType.BaseClasses;
partial record PartialLighting
  "Record for defining the type of the lighting"
  extends Modelica.Icons.Record;

  replaceable parameter IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingGains ligGai(A=A)
    constrainedby
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingGains "Lighting gains, only used for evaluating lighting heat gains"
    annotation (
    choicesAllMatching=true,
    Dialog(group="Lighting (optional)"),
    Placement(transformation(extent={{-40,0},{-20,20}})));

  replaceable parameter IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingSplit ligSpl
    constrainedby
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingSplit "Lighting split, only used for evaluating lighting heat fractions"
    annotation (
    choicesAllMatching=true,
    Dialog(group="Lighting (optional)"),
    Placement(transformation(extent={{20,0},{40,20}})));
    final parameter SI.Area A "Area of the zone";
  annotation (Documentation(revisions="<html>
<ul>
<li>
August 28, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</ul>
</html>", info="<html>
<p>Record combining lighting gains and split</p>
</html>"));
end PartialLighting;
