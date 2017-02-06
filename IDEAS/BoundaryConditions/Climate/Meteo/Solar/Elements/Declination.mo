within IDEAS.BoundaryConditions.Climate.Meteo.Solar.Elements;
block Declination "solar declination"

extends Modelica.Blocks.Interfaces.BlockIcon;

  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Interfaces.RealOutput delta(final quantity="Angle", final unit="rad",displayUnit="deg")
    "Declination angle"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
equation
  delta = asin(-sin(23.45*2*Modelica.Constants.pi/360)*cos((sim.timLoc/86400+10)*2*Modelica.Constants.pi/365.25));

  annotation (Icon(graphics={
        Ellipse(
          extent={{-74,74},{78,-72}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,90},{0,-88}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-28,-86},{32,88}},
          color={0,0,0},
          smooth=Smooth.None)}));
end Declination;
