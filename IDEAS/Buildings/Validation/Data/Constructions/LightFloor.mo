within IDEAS.Buildings.Validation.Data.Constructions;
model LightFloor

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=2,
    locGain=2,
    mats={insulationType,Materials.PlasterBoard(d=0.010)});

end LightFloor;
