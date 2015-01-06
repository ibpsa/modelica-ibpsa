within IDEAS.Electric.BaseClasses;
model WattsLaw
  "For use  with loads. Either symmetrically divided over 3 phases (numPha=3) or single phase (numPha=1)."
  parameter Integer numPha=1 "Choose the number of phases" annotation (choices(
        choice=1 "single phase", choice=3 "symmetrical 3 phase"));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin[numPha]
    vi annotation (Placement(transformation(extent={{90,-10},{110,10}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput P(start=0) annotation (Placement(
        transformation(extent={{-120,20},{-80,60}}), iconTransformation(extent={{-100,40},
            {-80,60}})));
  Modelica.Blocks.Interfaces.RealInput Q(start=0) annotation (Placement(
        transformation(extent={{-130,-20},{-90,20}}), iconTransformation(extent={{-110,0},
            {-90,20}})));
equation
  for i in 1:numPha loop
    P/numPha = Modelica.ComplexMath.real(vi[i].v*Modelica.ComplexMath.conj(vi[i].i));
    Q/numPha = Modelica.ComplexMath.imag(vi[i].v*Modelica.ComplexMath.conj(vi[i].i));
  end for;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Ellipse(
          extent={{-80,60},{40,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{40,0},{100,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-46,0},{-26,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-14,0},{6,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{40,60},{40,-60}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-26,24},{-26,-26}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-14,24},{-14,-26}},
          color={0,0,0},
          smooth=Smooth.None)}), Diagram(graphics));
end WattsLaw;
