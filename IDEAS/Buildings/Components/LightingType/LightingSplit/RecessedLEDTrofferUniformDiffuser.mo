within IDEAS.Buildings.Components.LightingType.LightingSplit;
record RecessedLEDTrofferUniformDiffuser
  "Recessed LED troffer uniform diffuser"
  extends
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingSplit(
      spaFra=0.55, radFra=0.36);

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
Lighting gains distribution for recessed LED troffer uniform diffuser
</p>
</html>"));
end RecessedLEDTrofferUniformDiffuser;
