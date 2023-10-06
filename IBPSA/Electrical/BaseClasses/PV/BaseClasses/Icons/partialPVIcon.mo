within IBPSA.Electrical.BaseClasses.PV.BaseClasses.Icons;
partial model partialPVIcon "Partial model for basic PV model icon"
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                  graphics={
    Rectangle(extent={{-100,100},{100,-100}},
                                         lineColor={215,215,215},fillColor={215,215,215},
            fillPattern =                                                                              FillPattern.Solid),
    Rectangle(extent={{-62,18},{-34,-10}},
                                        lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                     FillPattern.Solid),
    Rectangle(extent={{-30,18},{-2,-10}},
                                       lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                    FillPattern.Solid),
    Rectangle(extent={{2,18},{30,-10}},
                                      lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                   FillPattern.Solid),
    Rectangle(extent={{-62,-14},{-34,-42}},
                                          lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                       FillPattern.Solid),
    Rectangle(extent={{-30,-14},{-2,-42}},
                                         lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{2,-14},{30,-42}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                     FillPattern.Solid),
    Rectangle(extent={{-62,-46},{-34,-74}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                        FillPattern.Solid),
    Rectangle(extent={{-30,50},{-2,22}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                     FillPattern.Solid),
    Rectangle(extent={{2,50},{30,22}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                    FillPattern.Solid),
    Rectangle(extent={{-62,50},{-34,22}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{-30,-46},{-2,-74}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                       FillPattern.Solid),
    Rectangle(extent={{2,-46},{30,-74}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{-94,50},{-66,22}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{-94,18},{-66,-10}},
                                         lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{-94,-14},{-66,-42}},
                                         lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{-94,-46},{-66,-74}},
                                         lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{34,50},{62,22}},  lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{34,18},{62,-10}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{34,-14},{62,-42}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{34,-46},{62,-74}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{66,-46},{94,-74}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{66,-14},{94,-42}},lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{66,18},{94,-10}}, lineColor={0,0,255},fillColor={0,0,255},
            fillPattern =                                                                      FillPattern.Solid),
    Rectangle(extent={{66,50},{94,22}},  lineColor={0,0,255},fillColor={0,0,255},
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
