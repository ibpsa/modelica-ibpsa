within IDEAS.Buildings.Data.Constructions;
record TABS "Example - Classic TABS floor"
  extends IDEAS.Buildings.Data.Interfaces.Construction(
    nLay=5,
    nGain = 1,
    locGain={4},
    mats={
        IDEAS.Buildings.Data.Materials.Tile(d=0.005),
        IDEAS.Buildings.Data.Materials.Screed(d=0.05),
        IDEAS.Buildings.Data.Insulation.Rockwool(d=0.01),
        IDEAS.Buildings.Data.Materials.Concrete(d=0.125),
        IDEAS.Buildings.Data.Materials.Concrete(d=0.125)});
end TABS;
