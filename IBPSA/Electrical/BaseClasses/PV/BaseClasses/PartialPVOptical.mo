within IBPSA.Electrical.BaseClasses.PV.BaseClasses;
partial model PartialPVOptical
  Modelica.Blocks.Interfaces.RealOutput absRadRat
    "Ratio of absorbed radiation under operating conditions to standard conditions"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput zenAng(final unit="rad", final
      displayUnit="deg")                                                                 "Zenith angle for object"
    annotation (Placement(transformation(extent={{-140,68},{-100,108}})));
  Modelica.Blocks.Interfaces.RealInput HGloHor(final unit="W/m2") "Global horizontal irradiation"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput HDifHor(final unit="W/m2") "Diffuse horizontal irradiation"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput incAng(final unit="rad", final
      displayUnit="deg")                                                                 "Incidence angle"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
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
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
        <p>This is a partial model for the optical surrogate model of a photovoltaic model.</p>
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPVOptical;
