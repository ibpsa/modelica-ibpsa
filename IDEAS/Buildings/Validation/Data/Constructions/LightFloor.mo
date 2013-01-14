within IDEAS.Buildings.Validation.Data.Constructions;
model LightFloor "BESTEST Light floor"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=2,
    locGain=1,
    mats={insulationType,Materials.PlasterBoard(d=0.010)});

end LightFloor;
