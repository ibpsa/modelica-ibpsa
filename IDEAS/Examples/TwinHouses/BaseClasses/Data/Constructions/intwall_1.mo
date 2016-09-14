within IDEAS.Examples.TwinHouses.BaseClasses.Data.Constructions;
record intwall_1
       extends IDEAS.Buildings.Data.Interfaces.Construction(
       final nLay = 3,
       final mats={Materials.int_plaster2(d=0.01),Materials.honeycomb_bricki(d=0.24),Materials.int_plaster2(d=0.01)});
end intwall_1;
