within IDEAS.Examples.PPD12.Data;
record Ppd12WestShadingGnd "Ppd shading model for west side, ground floor"
  extends Buildings.Components.Shading.Interfaces.ShadingProperties(
    controlled=false,
    shaType=IDEAS.Buildings.Components.Shading.Interfaces.ShadingType.BuildingShade,
    L=12,
    dh=hRoofTip-hBotWin);
  parameter Modelica.SIunits.Length hRoofTip = 0.5+3+3+2.5+1.5 "Height difference between street level and roof tip of opposite buildings";
  parameter Modelica.SIunits.Length hBotWin = 1.2 "Height difference between street level and bottom of window";
    //Shading model representing shading from roof tip (9.3m high, 12m horizontal distance to windows)
    //of the opposite building on the west side
    //window bottom on ground floor is 1.2 m above the ground
end Ppd12WestShadingGnd;
