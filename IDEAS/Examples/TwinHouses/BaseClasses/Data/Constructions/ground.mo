within IDEAS.Examples.TwinHouses.BaseClasses.Data.Constructions;
record ground
       extends IDEAS.Buildings.Data.Interfaces.Construction(
       incLastLay=IDEAS.Types.Tilt.Floor,
       final mats={Materials.concrete2(d=0.22),Materials.levelling(d=0.029),Materials.pur_damm(d=0.03),Materials.composite(d=0.033),Materials.screed(d=0.065)});
end ground;
