within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Earth;
model TopOnGround "Represents the top ground with a fixed temperature"
parameter RecordEarthLayer recordEarthLayer;

// No index needed anymore..?
parameter Integer index=16;

Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    fixedTemperature;

end TopOnGround;
