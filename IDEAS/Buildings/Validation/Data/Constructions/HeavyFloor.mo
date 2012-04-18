within IDEAS.Buildings.Validation.Data.Constructions;
model HeavyFloor

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=2,
    locGain=2,
    mats={insulationType,Materials.ConcreteSlab(d=0.08,nState=10)});

end HeavyFloor;
