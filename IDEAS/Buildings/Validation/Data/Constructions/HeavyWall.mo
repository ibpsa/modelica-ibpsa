within IDEAS.Buildings.Validation.Data.Constructions;
model HeavyWall "BESTEST Heavy wall"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=3,
    locGain=2,
    mats={Materials.WoodSiding(d=0.009),insulationType,Materials.ConcreteBlock(
        d=0.10, nState=10)});

end HeavyWall;
