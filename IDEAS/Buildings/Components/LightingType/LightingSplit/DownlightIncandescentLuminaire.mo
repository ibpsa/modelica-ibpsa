within IDEAS.Buildings.Components.LightingType.LightingSplit;
record DownlightIncandescentLuminaire
  "Downligth incandescent luminaire"
  extends
    IDEAS.Buildings.Components.LightingType.BaseClasses.PartialLightingSplit(
      spaFra=0.75, radFra=0.98);

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
Lighting gains distribution for downlight incandescent luminaire
</p>
</html>"));
end DownlightIncandescentLuminaire;
