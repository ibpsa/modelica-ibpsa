within IDEAS.Buildings.Components.LightingType.LightingSplit;
record RecessedLEDColorTuningFixture
  "Recessed LED color tuning fixture"
  extends
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingSplit(
      spaFra=0.55, radFra=0.41);

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
Lighting gains distribution for recessed LED color tuning fixture
</p>
</html>"));
end RecessedLEDColorTuningFixture;
