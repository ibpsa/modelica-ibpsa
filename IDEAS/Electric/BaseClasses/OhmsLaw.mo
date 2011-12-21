within IDEAS.Electric.BaseClasses;
model OhmsLaw

  Modelica.Blocks.Interfaces.RealInput P "Active power"
    annotation (Placement(transformation(extent={{-120,4},{-80,44}})));
  Modelica.Blocks.Interfaces.RealInput Q "Reactive power"
    annotation (Placement(transformation(extent={{-120,-44},{-80,-4}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin pin
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  P = Modelica.ComplexMath.real(pin.v*Modelica.ComplexMath.conj(pin.i));
  Q = Modelica.ComplexMath.imag(pin.v*Modelica.ComplexMath.conj(pin.i));

  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{22,60},{64,20}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,54},{-32,20},{-12,20},{-12,28},{-2,28},{-2,32},{-12,32},
              {-12,44},{2,44},{2,50},{-12,50},{-12,54},{-32,54}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-20,20},{-20,0},{-100,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{40,52},{46,42}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{48,36},{54,26}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,36},{36,26}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{42,20},{42,0},{90,0}},
          color={127,0,0},
          smooth=Smooth.None)}));
end OhmsLaw;
