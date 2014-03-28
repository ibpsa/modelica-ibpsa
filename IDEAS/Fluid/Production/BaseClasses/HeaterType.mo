within IDEAS.Fluid.Production.BaseClasses;
type HeaterType = enumeration(
    HP_AW "Air/water Heat pump",
    HP_BW "Brine/water Heat pump",
    HP_BW_Collective "Brine/water HP with collective borefield",
    Boiler "Boiler")
  "Type of the heater: heat pump, gas boiler, fuel boiler, pellet boiler, ...";
