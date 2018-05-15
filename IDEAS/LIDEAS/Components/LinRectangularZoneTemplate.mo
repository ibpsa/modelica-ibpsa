within IDEAS.LIDEAS.Components;
model LinRectangularZoneTemplate
  extends IDEAS.Buildings.Components.RectangularZoneTemplate(redeclare replaceable
      BaseClasses.LinearAirModel airModel(linearise=linearise),
    redeclare LinWindow winA(indexWindow=indexWindowA),
    redeclare LinWindow winCei(indexWindow=indexWindowCei),
    redeclare LinWindow winB(indexWindow=indexWindowB),
    redeclare LinWindow winC(indexWindow=indexWindowC),
    redeclare LinWindow winD(indexWindow=indexWindowD));
  parameter Boolean linearise=sim.linearise;
  parameter Integer indexWindowA=1 if hasWinA "Index of this window A";
  parameter Integer indexWindowB=1 if hasWinB "Index of this window B";
  parameter Integer indexWindowC=1 if hasWinC "Index of this window C";
  parameter Integer indexWindowD=1 if hasWinD "Index of this window D";
  parameter Integer indexWindowCei=1 if hasWinCei "Index of this window Cei";
end LinRectangularZoneTemplate;
