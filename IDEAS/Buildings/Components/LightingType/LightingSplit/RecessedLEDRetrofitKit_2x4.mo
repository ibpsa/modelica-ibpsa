within IDEAS.Buildings.Components.LightingType.LightingSplit;
record RecessedLEDRetrofitKit_2x4 "Recessed LED retrofit kit 2x4"
  extends
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingSplit(
      spaFra=0.47, radFra=0.37);

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
Lighting gains distribution for recessed LED retrofit kit 2x4
</p>
</html>"));
end RecessedLEDRetrofitKit_2x4;
