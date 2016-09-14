within IDEAS.Examples.TwinHouses.BaseClasses.Data.Constructions;
record ceiling
       extends IDEAS.Buildings.Data.Interfaces.Construction(
       final nLay = 5,
       final mats={Materials.screed(d=0.04),Materials.insulation(d=0.04),Materials.concrete(d=0.22),Materials.plaster(d=0.01),Materials.insul_underceil(d=0.1)});
end ceiling;
