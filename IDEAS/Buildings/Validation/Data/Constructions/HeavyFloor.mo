within IDEAS.Buildings.Validation.Data.Constructions;
model HeavyFloor "BESTEST Heavy floor"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=2,
    locGain=2,
    mats={insulationType,Materials.ConcreteSlab(d=0.08)});

end HeavyFloor;
