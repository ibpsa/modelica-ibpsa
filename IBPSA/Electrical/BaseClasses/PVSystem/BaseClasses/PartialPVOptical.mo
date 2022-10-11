within IBPSA.Electrical.BaseClasses.PVSystem.BaseClasses;
partial model PartialPVOptical
  Modelica.Blocks.Interfaces.RealInput HGloHor annotation (Placement(
        transformation(extent={{-132,-16},{-100,16}}),iconTransformation(
          extent={{-132,-16},{-100,16}})));
  Modelica.Blocks.Interfaces.RealOutput absRadRat
    "Ratio of absorbed radiation under operating conditions to standard conditions"
    annotation (Placement(transformation(extent={{100,42},{120,62}})));
  Modelica.Blocks.Interfaces.RealOutput radTil
    "Total solar radiation on the tilted surface"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-78,76},{-22,24}},
          lineColor={0,0,0},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{12,-34},{42,22},{96,10},{68,-48},{12,-34}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-26,32},{44,-14},{-34,-56}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled})}),                    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialPVOptical;
