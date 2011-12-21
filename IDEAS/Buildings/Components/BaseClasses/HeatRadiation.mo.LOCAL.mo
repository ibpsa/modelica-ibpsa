within IDEAS.Buildings.Components.BaseClasses;
model HeatRadiation "radiative heat exchange between two temperatures"

extends IDEAS.Buildings.Components.Interfaces.StateDouble;

input Real R "heat resistance for longwave radiative heat exchange";

equation
port_a.Q_flow = -port_b.Q_flow;
port_a.Q_flow = Modelica.Constants.sigma/R*dT*(port_a.T+port_b.T)*(port_a.T^2+port_b.T^2);

  annotation (Icon(graphics={
        Line(
          points={{-96,0},{104,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-18,10},{22,-8}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}));
end HeatRadiation;
