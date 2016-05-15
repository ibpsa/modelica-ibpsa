within IDEAS.BoundaryConditions.Climate.Meteo.Solar.Elements;
block AngleHour

extends Modelica.Blocks.Interfaces.BlockIcon;

  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));

  Modelica.Blocks.Interfaces.RealOutput angHou(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "hour angle"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));

algorithm
angHou :=(sim.timSol/3600 - 12)*2*Modelica.Constants.pi/24;

  annotation (Diagram(graphics));
end AngleHour;
