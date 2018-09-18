within IDEAS.Buildings.Components.LightingType.LightingSplit;
record DownlightCompactFluorescentLuminaire
  "Downlight compact fluorescent luminaire."
  extends IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingSplit(
      spaFra=0.18, radFra=0.98);

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
Lighting gains distribution for downlight compact fluorescent luminaire
</p>
</html>"));
end DownlightCompactFluorescentLuminaire;
