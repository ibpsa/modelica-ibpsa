within IDEAS.Buildings.Components.LightingType.BaseClasses;
partial record PartialLighting
  "Record for defining the lighting type"
  extends Modelica.Icons.Record;

  parameter Real radFra(min=0,max=1)
    "Radiant fraction of lighting heat exchange";

  parameter Modelica.SIunits.LuminousEfficacy eps
    "Luminous efficacy,specifies the lm/W (lumen per watt) of the installed lighting";

protected
  parameter Real conFra(min=0, max=1) = 1-radFra
    "Convective fraction of lighting heat exchange";
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
