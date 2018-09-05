within IDEAS.Buildings.Components.LightingType.LightingGains;
record CopyroomLights "Properties for typical copy/print room lights"
  extends
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingGains(
      speW=7.8);

  annotation (Documentation(revisions="<html>
<ul>
<li>
August 28, 2018 by Iago Cupeiro:<br/>
First implementation
See <a href=\"https://github.com/open-ideas/IDEAS/issues/879\">#879</a>.
</li>
</ul>
</html>", info="<html>
<p>
Typical lighting gains distribution per square meter for a local with copy machines and printers
</p>
</html>"));
end CopyroomLights;
