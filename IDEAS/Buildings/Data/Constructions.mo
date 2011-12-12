within IDEAS.Buildings.Data;
package Constructions

  extends Modelica.Icons.MaterialPropertiesPackage;

  model CavityWall

    extends IDEAS.Buildings.Data.Interfaces.Construction(
      nLay=4,
      locGain=2,
      mats={Materials.Gypsum(d=0.015),Materials.BrickMi(d=0.14),insulationType,Materials.BrickMe(d=0.08)});

  end CavityWall;

end Constructions;
