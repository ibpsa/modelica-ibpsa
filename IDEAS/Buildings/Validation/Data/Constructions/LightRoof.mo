within IDEAS.Buildings.Validation.Data.Constructions;
record LightRoof "BESTEST Light roof"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=3,
    incLastLay = IDEAS.Types.Tilt.Ceiling,
    final mats={
      IDEAS.Buildings.Validation.Data.Materials.Roofdeck(d=0.019),
      insulationType,
      IDEAS.Buildings.Validation.Data.Materials.PlasterBoard(d=0.010)});

end LightRoof;
