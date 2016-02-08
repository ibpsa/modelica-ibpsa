within IDEAS.Buildings.Validation.Data.Constructions;
record LightFloor "BESTEST Light floor"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=2,
    incLastLay = IDEAS.Types.Tilt.Floor,
    final mats={insulationType,Materials.PlasterBoard(d=0.010)});

end LightFloor;
