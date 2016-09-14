within IDEAS.Examples.TwinHouses.BaseClasses.Data.Constructions;
record door_ext
       extends IDEAS.Buildings.Data.Interfaces.Construction(
       final nLay = 1,
       final mats={Materials.wooddoor(d=0.04)});
end door_ext;
