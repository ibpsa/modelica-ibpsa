within IDEAS.Buildings.Components.BaseClasses;
model ExteriorSolarAbsorption
  "shortwave radiation absorption on an exterior surface"

  extends IDEAS.Buildings.Components.Interfaces.StateSingle;
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Area A "surface area";

  Modelica.Blocks.Interfaces.RealInput solDir
    "direct solar illuminance on surface se"
    annotation (Placement(transformation(extent={{120,40},{80,80}})));
  Modelica.Blocks.Interfaces.RealInput solDif
    "diffuse solar illuminance on surface s"
    annotation (Placement(transformation(extent={{120,0},{80,40}})));
  Modelica.Blocks.Interfaces.RealInput epsSw
    "shortwave emissivity of the surface"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
equation
port_a.Q_flow = - (solDir + solDif) * epsSw;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-76.5,5.5},{76.5,-5.5}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          origin={-65.5,-0.5},
          rotation=90),
        Line(
          points={{-100,0},{52,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{44,8},{58,-6}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Rectangle(
          extent={{-30,10},{10,-8}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end ExteriorSolarAbsorption;
