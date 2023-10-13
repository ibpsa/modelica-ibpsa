within IBPSA.Electrical.BaseClasses.PV.BaseClasses.Icons;
partial model partialPVIcon "Partial model for basic PV model icon"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                  graphics={
    Rectangle(extent={{-100,100},{100,-100}},
                                         lineColor={215,215,215},fillColor={215,215,215},
            fillPattern =                                                                              FillPattern.Solid),
    Rectangle(extent={{-62,30},{-34,2}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                     FillPattern.Solid),
    Rectangle(extent={{-30,30},{-2,2}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                    FillPattern.Solid),
    Rectangle(extent={{2,30},{30,2}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                   FillPattern.Solid),
    Rectangle(extent={{-62,-2},{-34,-30}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                       FillPattern.Solid),
    Rectangle(extent={{-30,-2},{-2,-30}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{2,-2},{30,-30}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                     FillPattern.Solid),
    Rectangle(extent={{-62,-34},{-34,-62}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                        FillPattern.Solid),
    Rectangle(extent={{-30,62},{-2,34}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                     FillPattern.Solid),
    Rectangle(extent={{2,62},{30,34}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                    FillPattern.Solid),
    Rectangle(extent={{-62,62},{-34,34}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{-30,-34},{-2,-62}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                       FillPattern.Solid),
    Rectangle(extent={{2,-34},{30,-62}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{-94,62},{-66,34}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{-94,30},{-66,2}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{-94,-2},{-66,-30}},
                                         lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{-94,-34},{-66,-62}},
                                         lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{34,62},{62,34}},  lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{34,30},{62,2}},   lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{34,-2},{62,-30}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{34,-34},{62,-62}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{66,-34},{94,-62}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{66,-2},{94,-30}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{66,30},{94,2}},   lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{66,62},{94,34}},  lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
                                        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        textColor={0,0,255})}),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
            Documentation(info="<html>
<p>
This is a partial model containing the base icon of the PV-related models.
</p>
</html>",
        revisions="<html>
<ul>
<li>
Oct 6, 2023, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialPVIcon;
