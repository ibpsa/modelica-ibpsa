within IDEAS.Buildings.Validation.Data.Constructions;
record LightRoof_195 "BESTEST Light roof"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    final nLay=3,
    incLastLay = IDEAS.Types.Tilt.Ceiling,
    final mats={Materials.Roofdeck_195(d=0.019),insulationType,
        Materials.PlasterBoard(d=0.010)});

end LightRoof_195;
