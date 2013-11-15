within IDEAS.Climate.Meteo.Solar;
model RadiationSolar "solar angle to surface"

Real solDirPer "direct solar illuminance on normal to solar zenith";
Real solDirHor;
Real solDifHor;
Real TeAv "running average of ambient outdoor temperature of the last 5 days";

Modelica.Blocks.Interfaces.RealOutput solDir
    "direct solar illuminance on surface s";
Modelica.Blocks.Interfaces.RealOutput solDif
    "diffuse solar illuminance on surface s";
Modelica.Blocks.Interfaces.RealOutput cosXi
    "for determination of window properties";

parameter Real inc "inclination";
parameter Real azi "azimuth";
parameter Real lat = 50.8;
parameter Modelica.SIunits.Area A;

Real albedo(min=0.2,max=0.8) = 11.895 - 0.042*TeAv; /**** Te TO BE DETERMINED as in running average of last 2 weeks ****/

IDEAS.Climate.Meteo.Solar.Elements.AngleHour hour;
IDEAS.Climate.Meteo.Solar.Elements.Declination dec;

IDEAS.Climate.Meteo.Solar.Elements.AngleSolar aziPlane(
    inc=inc,
    azi=azi,
    lat=lat);
IDEAS.Climate.Meteo.Solar.Elements.AngleSolar aziHoriz(
    inc=0,
    azi=0,
    lat=lat);
IDEAS.Climate.Meteo.Solar.Elements.solradExtraTerra extraTerra;

Real omega;

equation
if noEvent(0.3-2*solDirPer*aziPlane.cosXi/extraTerra.sol >0) then
  omega=0.3-2*solDirPer*aziPlane.cosXi/extraTerra.sol;
else
  omega=0;
  end if;

aziPlane.hour = hour.hour;
aziPlane.dec = dec.delta;
aziHoriz.hour = hour.hour;
aziHoriz.dec = dec.delta;

if noEvent(inc > 0) then
  solDir = max(0,A*solDirPer*aziPlane.cosXi);
else
  solDir = solDirHor;
end if;

if noEvent(inc > 0) then
  solDif = max(0,A*(solDir/extraTerra.sol+omega*cos(inc/180*Modelica.Constants.pi)*solDifHor
         +(1+aziPlane.cosXi)/2*(1-solDirHor/extraTerra.sol-omega)
         +(1-aziPlane.cosXi)/2*albedo*(solDirHor+solDifHor)));
else
  solDif = solDifHor;
end if;

cosXi=aziPlane.cosXi;

end RadiationSolar;
