within IDEAS.Examples.TwinHouses.BaseClasses.Data.Constructions;
record Door
       extends IDEAS.Buildings.Data.Interfaces.Construction(
   final nLay = 1,
 final mats={IDEAS.Buildings.Data.Materials.Timber(d=0.04)});
end Door;
