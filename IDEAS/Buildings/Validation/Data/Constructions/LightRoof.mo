within IDEAS.Buildings.Validation.Data.Constructions;
record LightRoof "BESTEST Light roof"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=3,
    final locGain=2,
    final mats={Materials.Roofdeck(d=0.019),insulationType,
        Materials.PlasterBoard(d=0.010)});

end LightRoof;
