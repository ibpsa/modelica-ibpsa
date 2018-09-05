within IDEAS.Buildings.Components.LightingType.LightingGains;
record MeetingLights
  "Properties for typical meeting/conference rooms"
  extends
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingGains(
      speW=13.3);

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
Typical lighting gains distribution per square meter for a meeting or conference room
</p>
</html>"));
end MeetingLights;
