within IDEAS.Buildings.Validation.Data.Constructions;
record HeavyWall "BESTEST Heavy wall"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=3,
    final mats={
      IDEAS.Buildings.Validation.Data.Materials.WoodSiding(d=0.009),
      insulationType,
      IDEAS.Buildings.Validation.Data.Materials.ConcreteBlock(d=0.10)});

end HeavyWall;
