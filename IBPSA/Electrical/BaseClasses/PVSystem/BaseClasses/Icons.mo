within IBPSA.Electrical.BaseClasses.PVSystem.BaseClasses;
package Icons
  partial model partialPVIcon "Partial model for basic PV model icon"
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                               Text(extent={{-38,-64},{46,-98}},lineColor={0,0,255},textString= "%name"),
      Rectangle(extent={{-50,90},{50,-68}},lineColor={215,215,215},fillColor={215,215,215},
              fillPattern =                                                                              FillPattern.Solid),
      Rectangle(extent={{-46,28},{-18,0}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{-14,28},{14,0}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                    FillPattern.Solid),
      Rectangle(extent={{18,28},{46,0}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                   FillPattern.Solid),
      Rectangle(extent={{-46,-4},{-18,-32}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                       FillPattern.Solid),
      Rectangle(extent={{-14,-4},{14,-32}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid),
      Rectangle(extent={{18,-4},{46,-32}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{-46,-36},{-18,-64}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                        FillPattern.Solid),
      Rectangle(extent={{-14,60},{14,32}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{18,60},{46,32}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                    FillPattern.Solid),
      Rectangle(extent={{-46,60},{-18,32}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid),
      Rectangle(extent={{-14,-36},{14,-64}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                       FillPattern.Solid),
      Rectangle(extent={{18,-36},{46,-64}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid)}),
        Diagram(coordinateSystem(preserveAspectRatio=false)));
  end partialPVIcon;
end Icons;
