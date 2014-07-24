within IDEAS.Buildings.Validation.Data.Constructions;
record HeavyFloor "BESTEST Heavy floor"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=2,
    final locGain=2,
    final mats={insulationType,Materials.ConcreteSlab(d=0.08)});

end HeavyFloor;
