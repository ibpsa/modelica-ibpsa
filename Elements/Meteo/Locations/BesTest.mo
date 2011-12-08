within IDEAS.Elements.Meteo.Locations;
model BesTest "Climate file for BesTest"
extends IDEAS.Elements.Meteo.location(
    lat=39.8/180*Modelica.Constants.pi,
    lon=-104.9/180*Modelica.Constants.pi,
    Tdes=265.15,
    TdesGround=283.15,
    timZonSta=-7*3600,
    DST=false,
    yr=2010,
    LocNam="BesTest");
end BesTest;
