within IDEAS.BoundaryConditions.Climate.Meteo.Locations;
model BesTest "IEA Annex 21, Bestest"
  extends IDEAS.BoundaryConditions.Climate.Meteo.Location(
    lat=39.8/180*Modelica.Constants.pi,
    lon=-104.9/180*Modelica.Constants.pi,
    Tdes=265.15,
    TdesGround=283.15,
    timZonSta=-7*3600,
    DST=false,
    yr=2010,
    locNam="BesTest");
end BesTest;
