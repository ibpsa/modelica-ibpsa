within IDEAS.Buildings.Validation.Data.Constructions;
record HeavyFloor "BESTEST Heavy floor"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=2,
    incLastLay = IDEAS.Types.Tilt.Floor,
    final mats={
      insulationType,
      IDEAS.Buildings.Validation.Data.Materials.ConcreteSlab(d=0.08)});

end HeavyFloor;
