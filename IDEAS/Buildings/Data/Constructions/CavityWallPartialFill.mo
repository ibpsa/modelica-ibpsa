within IDEAS.Buildings.Data.Constructions;
record CavityWallPartialFill
  "Classic cavity wall construction with partially-filled cavity"
 extends IDEAS.Buildings.Data.Interfaces.Construction(
    incLastLay = IDEAS.Types.Tilt.Wall,
    mats={
      IDEAS.Buildings.Data.Materials.BrickHe(d=0.08),
      IDEAS.Buildings.Data.Materials.Air(d=0.03),
      insulationType,
      IDEAS.Buildings.Data.Materials.BrickLe(d=0.14),
      IDEAS.Buildings.Data.Materials.Gypsum(d=0.015)});

  annotation (Documentation(info="<html>
<p>
Example implementation of a cavity wall with a partially filled cavity.
</p>
</html>"));
end CavityWallPartialFill;
