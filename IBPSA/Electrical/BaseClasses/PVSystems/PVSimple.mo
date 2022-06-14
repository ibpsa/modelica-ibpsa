within IBPSA.Electrical.BaseClasses.PVSystems;
model PVSimple "Simple PV model with internal or external MPP tracking"

  replaceable model ElectricalModel =
    IBPSA.Electrical.BaseClasses.BaseClasses.PartialPVElectrical
   "Model with electrical characteristics";

  replaceable model ThermalModel =
    IBPSA.Electrical.BaseClasses.BaseClasses.PartialPVThermal
    "Model with thermal characteristics";

  replaceable model OpticalModel =
    IBPSA.Electrical.BaseClasses.BaseClasses.PartialPVOptical
    "Model with optical characteristics"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

  replaceable parameter IBPSA.Electrical.DataBase.PVSimpleBaseDataDefinition data
   constrainedby AixLib.DataBase.SolarElectric.PVBaseDataDefinition
   "PV Panel data definition"
                             annotation (choicesAllMatching);

end PVSimple;
