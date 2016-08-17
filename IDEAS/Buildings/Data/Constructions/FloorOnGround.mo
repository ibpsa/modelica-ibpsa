within IDEAS.Buildings.Data.Constructions;
record FloorOnGround "Floor on ground for floor heating system"

  extends IDEAS.Buildings.Data.Interfaces.Construction(
    locGain={3},
    incLastLay = IDEAS.Types.Tilt.Floor,
    mats={Materials.Concrete(d=0.20),insulationType,Materials.Screed(d=0.08),
        Materials.Concrete(d=0.015)});

end FloorOnGround;
