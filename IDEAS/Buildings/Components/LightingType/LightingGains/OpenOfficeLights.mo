within IDEAS.Buildings.Components.LightingType.LightingGains;
record OpenOfficeLights "Properties for typical open plan office work."
  extends
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingGains(
      W_per_sqm=10.6);

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
Typical lighting gains distribution per square meter for an open office space
</p>
</html>"));
end OpenOfficeLights;
