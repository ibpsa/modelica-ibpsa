within IDEAS.Buildings.Components.LightingType.LightingSplit;
record RecessedLEDTrofferPartialApertureDiffuser
  "Recessed LED troffer partial aperture diffuser"
  extends
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingSplit(
      spaFra=0.57, radFra=0.42);

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
Lighting gains distribution for recessed LED troffer partial aperture diffuser
</p>
</html>"));
end RecessedLEDTrofferPartialApertureDiffuser;
