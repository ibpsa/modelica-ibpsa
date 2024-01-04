within IBPSA.Electrical.BaseClasses.PV.BaseClasses;
partial model PartialPVThermal
 "Partial model for computing the cell temperature of a PV moduleConnector for PV record data"
  replaceable parameter Data.PV.Generic dat constrainedby
    IBPSA.Electrical.Data.PV.Generic "PV Panel data definition"
    annotation (choicesAllMatching);
  Modelica.Blocks.Interfaces.RealOutput TCel(final unit="K", final displayUnit="degC")
    "Cell temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput TDryBul(final unit="K", final displayUnit="degC")
    "Ambient temperature (dry bulb)"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput winVel(final unit="m/s")
    "Wind velocity"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput HGloTil(final unit="W/m2")
    "Total solar irradiance on the tilted surface"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput eta(final unit="1")
    "Efficiency of the PV module under operating conditions"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{120,100}}),
   graphics={
                             Text(extent={{-84,-68},{0,-102}},textString= "%name"),
    Rectangle(extent={{-94,84},{6,-74}}, lineColor={215,215,215},fillColor={215,215,215},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-90,24},{-62,-4}},
   lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-58,24},{-30,-4}},
   lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-26,24},{2,-4}},
   lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-90,-8},{-62,-36}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-58,-8},{-30,-36}},
   lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-26,-8},{2,-36}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-90,-40},{-62,-68}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-58,56},{-30,28}},
   lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-26,56},{2,28}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-90,56},{-62,28}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-58,-40},{-30,-68}},
   lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
    Rectangle(extent={{-26,-40},{2,-68}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern = FillPattern.Solid),
        Ellipse(
          extent={{46,-90},{86,-52}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,48},{78,-60}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{54,48},{54,88},{56,94},{60,96},{66,98},{72,96},{76,94},{78,
              88},{78,48},{54,48}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{54,48},{54,-56}},
          thickness=0.5),
        Line(
          points={{78,48},{78,-56}},
          thickness=0.5),
        Text(
          extent={{92,4},{-28,-26}},
          textString="T")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
            Documentation(info="<html>
        <p>This is a partial model for the thermal surrogate model of a photovoltaic modelt.</p>
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPVThermal;
