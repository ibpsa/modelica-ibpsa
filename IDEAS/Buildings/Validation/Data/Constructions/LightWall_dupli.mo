within IDEAS.Buildings.Validation.Data.Constructions;
model LightWall_dupli "BESTEST Light wall"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=3,
    locGain=2,
    mats={Materials.WoodSiding(d=0.009),insulationType,Materials.PlasterBoard(d
        =0.012)});

end LightWall_dupli;
