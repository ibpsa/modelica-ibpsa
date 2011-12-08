within IDEAS.Building.Component.Elements;
model ShadingControl "shading control based on irradiation"

extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Real uLow = 250 "upper limit above which shading goes down";
  parameter Real uHigh = 150 "lower limit below which shading goes up again";
  IDEAS.Elements.General.Hyst_NoEvent   hyst(uLow=uLow, uHigh=uHigh);
  Modelica.Blocks.Interfaces.RealInput irr "irradiance on the depicted surface"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealOutput y "control signal"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

equation
hyst.u = irr;
if noEvent(time > 8E6) and noEvent(time <2.6E7) then
  hyst.y=y;
else
  y=0;
end if;
end ShadingControl;
