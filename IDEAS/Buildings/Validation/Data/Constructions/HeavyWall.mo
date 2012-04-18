within IDEAS.Buildings.Validation.Data.Constructions;
model HeavyWall

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=3,
    locGain=2,
    mats={Materials.WoodSiding(d=0.009),insulationType,Materials.ConcreteBlock(d=0.010, nState=10)});

end HeavyWall;
