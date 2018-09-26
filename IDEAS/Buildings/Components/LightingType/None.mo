within IDEAS.Buildings.Components.LightingType;
record None "No lighting installed in the zone"
  extends Modelica.Icons.Record;
  extends IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLighting(
      eps = Modelica.Constants.inf,
      radFra = 0);                   //infinite to force 0 lighting gains in the lighting model

  annotation (Documentation(revisions="<html>
<ul>
<li>
August 28, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</ul>
</html>", info=""));

end None;
