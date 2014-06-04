within IDEAS.HeatingSystems.Examples;
model BuildingFreeFloat "Dummy building without heating"

  extends Modelica.Icons.Example;
  final parameter Integer  nZones = 2 "Number of zones";

  DummyBuilding dummyBuilding(nZones=nZones, nEmb=2)
    annotation (Placement(transformation(extent={{-68,12},{-38,32}})));
  inner SimInfoManager sim
    annotation (Placement(transformation(extent={{-90,74},{-70,94}})));
end BuildingFreeFloat;
