within IBPSA.Electrical.BaseClasses.PVSystem;
package BaseClasses "Base parameters for PV Model"
  extends Modelica.Icons.BasesPackage;

  partial model PartialPVElectrical
    "Partial electrical model for PV module model"
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
       Rectangle(
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{-100,100},{100,-100}}),
          Line(
            points={{-66,-64},{-66,88}},
            color={0,0,0},
            arrow={Arrow.None,Arrow.Filled},
            thickness=0.5),
          Line(
            points={{-66,-64},{64,-64}},
            color={0,0,0},
            arrow={Arrow.None,Arrow.Filled},
            thickness=0.5),
          Text(
            extent={{-72,80},{-102,68}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="I"),
          Text(
            extent={{80,-80},{50,-92}},
            lineColor={0,0,0},
            lineThickness=0.5,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="U"),
          Line(
            points={{-66,54},{-66,54},{-6,54},{12,50},{22,42},{32,28},{38,8},{
                42,-14},{44,-44},{44,-64}},
            color={0,0,0},
            thickness=0.5,
            smooth=Smooth.Bezier)}),                               Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialPVElectrical;

  partial model PartialPVThermal
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                               Text(extent={{-40,-68},{44,-102}},
                                                                lineColor={0,0,255},textString= "%name"),
      Rectangle(extent={{-94,86},{6,-72}}, lineColor={215,215,215},fillColor={215,215,215},
              fillPattern =                                                                              FillPattern.Solid),
      Rectangle(extent={{-90,24},{-62,-4}},
                                          lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{-58,24},{-30,-4}},
                                         lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                    FillPattern.Solid),
      Rectangle(extent={{-26,24},{2,-4}},
                                        lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                   FillPattern.Solid),
      Rectangle(extent={{-90,-8},{-62,-36}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                       FillPattern.Solid),
      Rectangle(extent={{-58,-8},{-30,-36}},
                                           lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid),
      Rectangle(extent={{-26,-8},{2,-36}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{-90,-40},{-62,-68}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                        FillPattern.Solid),
      Rectangle(extent={{-58,56},{-30,28}},
                                          lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                     FillPattern.Solid),
      Rectangle(extent={{-26,56},{2,28}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                    FillPattern.Solid),
      Rectangle(extent={{-90,56},{-62,28}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid),
      Rectangle(extent={{-58,-40},{-30,-68}},
                                            lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                       FillPattern.Solid),
      Rectangle(extent={{-26,-40},{2,-68}},lineColor={0,0,255},fillColor={0,0,255},
              fillPattern =                                                                      FillPattern.Solid),
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
            lineColor={0,0,0},
            textString="T")}),                                     Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialPVThermal;

  partial model PartialPVOptical
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
end BaseClasses;
