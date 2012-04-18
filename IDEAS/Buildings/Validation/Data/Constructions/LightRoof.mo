within IDEAS.Buildings.Validation.Data.Constructions;
model LightRoof

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=3,
    locGain=2,
    mats={Materials.Roofdeck(d=0.019),insulationType,Materials.PlasterBoard(d=0.010)});

end LightRoof;
