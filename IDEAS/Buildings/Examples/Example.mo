within IDEAS.Buildings.Examples;
model Example "Example detailed building model"

  extends IDEAS.Buildings.Interfaces.Building(nZones=3);

//Definition of the exterior wall orientations where "0" is South and "-90" is East
final parameter Modelica.SIunits.Angle front = IDEAS.Climate.Meteo.Orientations.Azimuth.East;
final parameter Modelica.SIunits.Angle side = IDEAS.Climate.Meteo.Orientations.Azimuth.South;
final parameter Modelica.SIunits.Angle back = IDEAS.Climate.Meteo.Orientations.Azimuth.West;
final parameter Modelica.SIunits.Angle floor = IDEAS.Climate.Meteo.Orientations.Inclination.Floor;
final parameter Modelica.SIunits.Angle ceiling = IDEAS.Climate.Meteo.Orientations.Inclination.Ceiling;
final parameter Modelica.SIunits.Angle wall = IDEAS.Climate.Meteo.Orientations.Inclination.Wall;

//Definition of the used construction materials in the dwelling

//The thermal zones of the modeled dwelling
  Components.Zone gF_zone(
    V=216.0,
    height=3.0,
    nSurf=6,
    ACH=0.5,
    weightFactor={0.2,0.3,0.1,0.1,0.1,0.2},
    Tset=293.15) "ground floor (gF) with living area"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Components.Zone fF_zone(
    V=216.0,
    height=3.0,
    nSurf=6,
    ACH=0.5,
    weightFactor={0.2,0.3,0.1,0.1,0.1,0.2},
    Tset=291.15) "first floor (fF) with sleeping area"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Components.Zone sF_zone(
    V=216.0,
    height=3.0,
    nSurf=6,
    ACH=0.5,
    weightFactor={0.2,0.3,0.1,0.1,0.1,0.2},
    Tset=291.15) "second floor (sF) with sleeping area"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));

//The vertical exterior walls gathered as a single wall per floor
IDEAS.Buildings.Components.OuterWall gF_wallExt(
    A=38.5,
    inc=wall,
    azi=side,
    nLay=4,
    mats={bricke,mw,bricki,gypsum});
IDEAS.Buildings.Components.OuterWall fF_wallExt(
    A=41.0,
    inc=wall,
    azi=side,
    nLay=4,
    mats={bricke,mw,bricki,gypsum});
IDEAS.Buildings.Components.OuterWall sF_wallExt(
    A=41.0,
    inc=wall,
    azi=side,
    nLay=4,
    mats={bricke,mw,bricki,gypsum});

//The internal floor slabs
IDEAS.Buildings.Components.SlabOnGround gF_floor(
    A=72.0,
    P=26,
    inc=floor,
    azi=side,
    nLay=5,
    mats={concrete,screed,pur,screed,tile},
    locGain=4);
IDEAS.Buildings.Components.InternalWall fF_floor(
    A=72.0,
    inc=floor,
    nLay=6,
    mats={tile,screed,pur,screed,concrete,gypsum},
    locGain=2);
IDEAS.Buildings.Components.InternalWall sF_floor(
    A=72.0,
    inc=floor,
    nLay=6,
    mats={tile,screed,pur,screed,concrete,gypsum},
    locGain=2);
//The exterior roofs gathered as a single wall per floor
IDEAS.Buildings.Components.OuterWall sF_roof(
    A=72.0,
    inc=ceiling,
    azi=side,
    nLay=3,
    mats={xps,concrete,gypsum});

//The external windows gathered per floor per orientation
//i.e. three orientations for the ground floor
IDEAS.Buildings.Components.Window gF_frontWin(
    A=3.0,
    azi=front,
    inc=wall,
    glazing=gla,
    shading=true);
IDEAS.Buildings.Components.Window gF_backWin(
    A=5.0,
    azi=back,
    inc=wall,
    glazing=gla,
    shading=true);
//three orientations for the first floor
IDEAS.Buildings.Components.Window fF_frontWin(
    A=3.0,
    azi=front,
    inc=wall,
    glazing=gla,
    shading=true);
IDEAS.Buildings.Components.Window fF_backWin(
    A=5.5,
    azi=back,
    inc=wall,
    glazing=gla,
    shading=true);
//and three orientations for the second floor
IDEAS.Buildings.Components.Window sF_frontWin(
    A=3.0,
    azi=front,
    inc=wall,
    glazing=gla,
    shading=true);
IDEAS.Buildings.Components.Window sF_backWin(
    A=5.5,
    azi=back,
    inc=wall,
    glazing=gla,
    shading=true);
//The vertical common walls with the neighbors gathered as a single wall per floor
IDEAS.Buildings.Components.CommonWall gF_wallNei(
    A=54.0,
    inc=wall,
    azi=side,
    nLay=5,
    mats={gypsum,bricki,mw,bricki,gypsum});
IDEAS.Buildings.Components.CommonWall fF_wallNei(
    A=54.0,
    inc=wall,
    azi=side,
    nLay=5,
    mats={gypsum,bricki,mw,bricki,gypsum});
IDEAS.Buildings.Components.CommonWall sF_wallNei(
    A=54.0,
    inc=wall,
    azi=side,
    nLay=5,
    mats={gypsum,bricki,mw,bricki,gypsum});

equation
//First we build up the complete ground floor (gF)
//i.e. the exterior walls of gF
connect(gF_wallExt.port_b, gF_zone.surfCon[1]);
connect(gF_wallExt.port_bRad, gF_zone.surfRad[1]);
connect(gF_wallExt.iEpsLw, gF_zone.epsLw[1]);
connect(gF_wallExt.iEpsSw, gF_zone.epsSw[1]);
connect(gF_wallExt.area, gF_zone.area[1]);
//i.e. the floor of gF
connect(gF_floor.port_b, gF_zone.surfCon[2]);
connect(gF_floor.port_bRad, gF_zone.surfRad[2]);
connect(gF_floor.iEpsLw, gF_zone.epsLw[2]);
connect(gF_floor.iEpsSw, gF_zone.epsSw[2]);
connect(gF_floor.area, gF_zone.area[2]);
//i.e. the front window of gF
connect(gF_frontWin.port_b, gF_zone.surfCon[3]);
connect(gF_frontWin.port_bRad, gF_zone.surfRad[3]);
connect(gF_frontWin.port_bSolDir, gF_zone.iSolDir);
connect(gF_frontWin.port_bSolDif, gF_zone.iSolDif);
connect(gF_frontWin.iEpsLw, gF_zone.epsLw[3]);
connect(gF_frontWin.iEpsSw, gF_zone.epsSw[3]);
connect(gF_frontWin.area, gF_zone.area[3]);
//i.e. the back window of gF
connect(gF_backWin.port_b, gF_zone.surfCon[4]);
connect(gF_backWin.port_bRad, gF_zone.surfRad[4]);
connect(gF_backWin.port_bSolDir, gF_zone.iSolDir);
connect(gF_backWin.port_bSolDif, gF_zone.iSolDif);
connect(gF_backWin.iEpsLw, gF_zone.epsLw[4]);
connect(gF_backWin.iEpsSw, gF_zone.epsSw[4]);
connect(gF_backWin.area, gF_zone.area[4]);
//i.e. the floor of fF
connect(fF_floor.port_b, gF_zone.surfCon[5]);
connect(fF_floor.port_bRad, gF_zone.surfRad[5]);
connect(fF_floor.iEpsLwb, gF_zone.epsLw[5]);
connect(fF_floor.iEpsSwb, gF_zone.epsSw[5]);
connect(fF_floor.area, gF_zone.area[5]);
//i.e. the neighbor wall of gF
connect(gF_wallNei.port_b, gF_zone.surfCon[6]);
connect(gF_wallNei.port_bRad, gF_zone.surfRad[6]);
connect(gF_wallNei.iEpsLw, gF_zone.epsLw[6]);
connect(gF_wallNei.iEpsSw, gF_zone.epsSw[6]);
connect(gF_wallNei.area, gF_zone.area[6]);
//then we build up the complete first floor (fF)
//i.e. the exterior walls of fF
connect(fF_wallExt.port_b, fF_zone.surfCon[1]);
connect(fF_wallExt.port_bRad, fF_zone.surfRad[1]);
connect(fF_wallExt.iEpsLw, fF_zone.epsLw[1]);
connect(fF_wallExt.iEpsSw, fF_zone.epsSw[1]);
connect(fF_wallExt.area, fF_zone.area[1]);
//i.e. the floor of fF
connect(fF_floor.port_a, fF_zone.surfCon[2]);
connect(fF_floor.port_aRad, fF_zone.surfRad[2]);
connect(fF_floor.iEpsLwa, fF_zone.epsLw[2]);
connect(fF_floor.iEpsSwa, fF_zone.epsSw[2]);
connect(fF_floor.area, fF_zone.area[2]);
//i.e. the front window of fF
connect(fF_frontWin.port_b, fF_zone.surfCon[3]);
connect(fF_frontWin.port_bRad, fF_zone.surfRad[3]);
connect(fF_frontWin.port_bSolDir, fF_zone.iSolDir);
connect(fF_frontWin.port_bSolDif, fF_zone.iSolDif);
connect(fF_frontWin.iEpsLw, fF_zone.epsLw[3]);
connect(fF_frontWin.iEpsSw, fF_zone.epsSw[3]);
connect(fF_frontWin.area, fF_zone.area[3]);
//i.e. the back window of f
connect(fF_backWin.port_b, fF_zone.surfCon[4]);
connect(fF_backWin.port_bRad, fF_zone.surfRad[4]);
connect(fF_backWin.port_bSolDir, fF_zone.iSolDir);
connect(fF_backWin.port_bSolDif, fF_zone.iSolDif);
connect(fF_backWin.iEpsLw, fF_zone.epsLw[4]);
connect(fF_backWin.iEpsSw, fF_zone.epsSw[4]);
connect(fF_backWin.area, fF_zone.area[4]);
//i.e. the floor of sF
connect(sF_floor.port_b, fF_zone.surfCon[5]);
connect(sF_floor.port_bRad, fF_zone.surfRad[5]);
connect(sF_floor.iEpsLwb, fF_zone.epsLw[5]);
connect(sF_floor.iEpsSwb, fF_zone.epsSw[5]);
connect(sF_floor.area, fF_zone.area[5]);
//i.e. the neighbor wall of fF
connect(fF_wallNei.port_b, fF_zone.surfCon[6]);
connect(fF_wallNei.port_bRad, fF_zone.surfRad[6]);
connect(fF_wallNei.iEpsLw, fF_zone.epsLw[6]);
connect(fF_wallNei.iEpsSw, fF_zone.epsSw[6]);
connect(fF_wallNei.area, fF_zone.area[6]);
//then we build up the complete second floor (sF)
//i.e. the exterior walls of sF
connect(sF_wallExt.port_b, sF_zone.surfCon[1]);
connect(sF_wallExt.port_bRad, sF_zone.surfRad[1]);
connect(sF_wallExt.iEpsLw, sF_zone.epsLw[1]);
connect(sF_wallExt.iEpsSw, sF_zone.epsSw[1]);
connect(sF_wallExt.area, sF_zone.area[1]);
//i.e. the floor of sF
connect(sF_floor.port_a, sF_zone.surfCon[2]);
connect(sF_floor.port_aRad, sF_zone.surfRad[2]);
connect(sF_floor.iEpsLwa, sF_zone.epsLw[2]);
connect(sF_floor.iEpsSwa, sF_zone.epsSw[2]);
connect(sF_floor.area, sF_zone.area[2]);
//i.e. the roof of sF
connect(sF_roof.port_b, sF_zone.surfCon[3]);
connect(sF_roof.port_bRad, sF_zone.surfRad[3]);
connect(sF_roof.iEpsLw, sF_zone.epsLw[3]);
connect(sF_roof.iEpsSw, sF_zone.epsSw[3]);
connect(sF_roof.area, sF_zone.area[3]);
//i.e. the front window of gF
connect(sF_frontWin.port_b, sF_zone.surfCon[4]);
connect(sF_frontWin.port_bRad, sF_zone.surfRad[4]);
connect(sF_frontWin.port_bSolDir, sF_zone.iSolDir);
connect(sF_frontWin.port_bSolDif, sF_zone.iSolDif);
connect(sF_frontWin.iEpsLw, sF_zone.epsLw[4]);
connect(sF_frontWin.iEpsSw, sF_zone.epsSw[4]);
connect(sF_frontWin.area, sF_zone.area[4]);
//i.e. the back window of sF
connect(sF_backWin.port_b, sF_zone.surfCon[5]);
connect(sF_backWin.port_bRad, sF_zone.surfRad[5]);
connect(sF_backWin.port_bSolDir, sF_zone.iSolDir);
connect(sF_backWin.port_bSolDif, sF_zone.iSolDif);
connect(sF_backWin.iEpsLw, sF_zone.epsLw[5]);
connect(sF_backWin.iEpsSw, sF_zone.epsSw[5]);
connect(sF_backWin.area, sF_zone.area[5]);
//i.e. the neighbor wall of sF
connect(sF_wallNei.port_b, sF_zone.surfCon[6]);
connect(sF_wallNei.port_bRad, sF_zone.surfRad[6]);
connect(sF_wallNei.iEpsLw, sF_zone.epsLw[6]);
connect(sF_wallNei.iEpsSw, sF_zone.epsSw[6]);
connect(sF_wallNei.area, sF_zone.area[6]);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,
            -100},{150,100}}),
                      graphics));
end Example;
