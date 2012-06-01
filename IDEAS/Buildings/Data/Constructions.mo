within IDEAS.Buildings.Data;
package Constructions "Library of building envelope constructions"

  extends Modelica.Icons.MaterialPropertiesPackage;

  model CavityWall "Classic cavity wall construction with fully-filled cavity"

    extends IDEAS.Buildings.Data.Interfaces.Construction(
      nLay=4,
      locGain=2,
      mats={Materials.BrickMe(d=0.08),insulationType,Materials.BrickMi(d=0.14),Materials.Gypsum(d=0.015)});

  end CavityWall;

  model FloorOnGround "Floor on ground for floro heating system"

    extends IDEAS.Buildings.Data.Interfaces.Construction(
      nLay=4,
      locGain=2,
      mats={Materials.Concrete(d=0.20),insulationType,Materials.Screed(d=0.08,nState=4),Materials.Concrete(d=0.015)});

  end FloorOnGround;
end Constructions;
