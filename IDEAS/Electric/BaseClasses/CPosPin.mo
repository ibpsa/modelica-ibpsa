within IDEAS.Electric.BaseClasses;
connector CPosPin

      Modelica.SIunits.ComplexVoltage v "Potential at the pin"   annotation (
            unassignedMessage="An electrical potential cannot be uniquely calculated.
The reason could be that
- a ground object is missing (Modelica.Electrical.Analog.Basic.Ground)
  to define the zero potential of the electrical circuit, or
- a connector of an electrical component is not connected.");
      flow Modelica.SIunits.ComplexCurrent i "Current flowing into the pin"     annotation (
            unassignedMessage="An electrical current cannot be uniquely calculated.
The reason could be that
- a ground object is missing (Modelica.Electrical.Analog.Basic.Ground)
  to define the zero potential of the electrical circuit, or
- a connector of an electrical component is not connected.");
      annotation (
        defaultComponentName="pin_p",
        Documentation(info="<html>
<p>Connectors PositivePin and NegativePin are nearly identical. The only difference is that the icons are different in order to identify more easily the pins of a component. Usually, connector PositivePin is used for the positive and connector NegativePin for the negative pin of an electrical component.</p>
</html>", revisions="<html>
<ul>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,255},
                  fillColor={0,0,255},
                  fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                100,100}}), graphics={Rectangle(
                  extent={{-40,40},{40,-40}},
                  lineColor={0,0,255},
                  fillColor={0,0,255},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-160,110},{40,50}},
                  lineColor={0,0,255},
                  textString="%name")}));

end CPosPin;
