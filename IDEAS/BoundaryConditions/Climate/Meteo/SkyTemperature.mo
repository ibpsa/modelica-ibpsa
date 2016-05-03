within IDEAS.BoundaryConditions.Climate.Meteo;
model SkyTemperature "sky temperature"

  Modelica.Blocks.Interfaces.RealInput C "tenths cloud cover";
  Modelica.Blocks.Interfaces.RealInput Tdew "dew point of the exterior";
  Modelica.Blocks.Interfaces.RealInput Te "ambient outdoor temperature";

  Modelica.Blocks.Interfaces.RealOutput tSky "sky temperature";

protected
  Real fc "cloud factor";
  Real eps "sky emissivity";

equation
  fc = 1.0 + 0.024*C - 0.0035*C^2 + 0.00028*C^3;
  eps = 0.787 + 0.764*fc*log(Tdew/273.15);
  tSky = Te*eps^0.25;

end SkyTemperature;
