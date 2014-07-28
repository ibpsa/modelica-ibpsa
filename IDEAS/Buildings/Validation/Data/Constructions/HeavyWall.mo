within IDEAS.Buildings.Validation.Data.Constructions;
record HeavyWall "BESTEST Heavy wall"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=3,
    final locGain=2,
    final mats={Materials.WoodSiding(d=0.009),insulationType,Materials.ConcreteBlock(d=0.10)});

end HeavyWall;
