within IDEAS.BoundaryConditions.Climate.Meteo.Locations;
model Uccle "Uccle, Belgium"
  extends IDEAS.BoundaryConditions.Climate.Meteo.Location(
    lat=50.800/180*Modelica.Constants.pi,
    lon=4.317/180*Modelica.Constants.pi,
    Tdes=265.15,
    TdesGround=284.15,
    timZonSta=3600,
    DST=true,
    yr=2010,
    locNam="climate");
end Uccle;
