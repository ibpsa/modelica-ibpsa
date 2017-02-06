within IDEAS.BoundaryConditions.Climate.Meteo.Locations;
model Holzkirchen "IEA Annex 58, Holzkirchen"
  extends IDEAS.BoundaryConditions.Climate.Meteo.Location(
    lat=47.874/180*Modelica.Constants.pi,
    lon=11.728/180*Modelica.Constants.pi,
    Tdes=265.15,
    TdesGround=283.15,
    timZonSta=3600,
    DST=false,
    yr=2013,
    locNam="Holzkirchen");
end Holzkirchen;
