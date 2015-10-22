within Annex60.Experimental.ThermalZones.ROM.Examples;
model VDI6007TestCase8 "Illustrates the use of ThermalZoneTwoElements"

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat
    annotation (Placement(transformation(extent={{-92,52},{-72,72}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil
    annotation (Placement(transformation(extent={{-52,20},{-32,40}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil
    annotation (Placement(transformation(extent={{-52,52},{-32,72}})));
  BoundaryConditions.SkyTemperature.BlackBody TBlaSky
    annotation (Placement(transformation(extent={{-52,-14},{-32,6}})));
  CorrectionSolarGain.CorGDoublePane corGDoublePane
    annotation (Placement(transformation(extent={{6,54},{26,74}})));
  AggWindow aggWindow
    annotation (Placement(transformation(extent={{38,54},{58,74}})));
  ThermalZoneTwoElements thermalZoneTwoElements
    annotation (Placement(transformation(extent={{40,-2},{88,34}})));
  EqAirTemp.EqAirTemp eqAirTemp
    annotation (Placement(transformation(extent={{-8,2},{12,22}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end VDI6007TestCase8;
