within IDEAS.Buildings.Data.Constructions;
record TABS "Classic TABS floor"
  extends IDEAS.Buildings.Data.Interfaces.Construction(
    locGain={4},
    incLastLay = IDEAS.Types.Tilt.Floor,
    mats={IDEAS.Buildings.Data.Materials.Concrete(d=0.125),
    IDEAS.Buildings.Data.Materials.Concrete(d=0.125),
    IDEAS.Buildings.Data.Insulation.Rockwool(d=0.01),
    IDEAS.Buildings.Data.Materials.Screed(d=0.05),
        IDEAS.Buildings.Data.Materials.Tile(d=0.005)});
end TABS;
