within IDEAS.Examples.TwinHouses.BaseClasses.Data.Constructions;
record column
       extends IDEAS.Buildings.Data.Interfaces.Construction(
       final nLay = 1,
       final mats={Materials.concrete(d=0.07)});
end column;
