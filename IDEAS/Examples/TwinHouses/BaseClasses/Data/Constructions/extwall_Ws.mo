within IDEAS.Examples.TwinHouses.BaseClasses.Data.Constructions;
record extwall_Ws
       extends IDEAS.Buildings.Data.Interfaces.Construction(
       final nLay = 5,
       final mats={Materials.ext_plaster(d=0.01),Materials.ins_eps(d=0.08),Materials.formerext_plast(d=0.03),Materials.honeycomb_brick(d=0.3),Materials.int_plaster(d=0.01)});
end extwall_Ws;
