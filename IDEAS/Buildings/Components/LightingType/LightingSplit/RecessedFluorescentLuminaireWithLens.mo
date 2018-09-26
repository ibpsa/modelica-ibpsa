within IDEAS.Buildings.Components.LightingType.LightingSplit;
record RecessedFluorescentLuminaireWithLens
  "Properties for typical fluorescent luminaire with lens."
  extends
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingSplit(
      spaFra=0.45, radFra=0.67);

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
Lighting gains distribution for fluorescent luminaires with lens
</p>
</html>"));
end RecessedFluorescentLuminaireWithLens;
