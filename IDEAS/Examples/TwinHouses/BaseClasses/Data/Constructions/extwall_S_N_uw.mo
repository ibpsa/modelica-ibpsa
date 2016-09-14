within IDEAS.Examples.TwinHouses.BaseClasses.Data.Constructions;
record extwall_S_N_uw
       extends IDEAS.Buildings.Data.Interfaces.Construction(
       final nLay = 5,
       final mats={Materials.ext_plaster(d=0.01),Materials.ins_pu(d=0.12),Materials.formerext_plast(d=0.03),Materials.honeycomb_brick(d=0.2),Materials.int_plaster(d=0.01)});
end extwall_S_N_uw;
