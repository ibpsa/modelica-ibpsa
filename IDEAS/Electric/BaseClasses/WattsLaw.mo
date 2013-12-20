within IDEAS.Electric.BaseClasses;
model WattsLaw
  "For use  with loads. Either symmetrically divided over 3 phases (numPha=3) or single phase (numPha=1)."
  parameter Integer numPha=1 "Choose the number of phases" annotation (choices(
        choice=1 "single phase", choice=3 "symmetrical 3 phase"));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin[numPha]
    vi annotation (Placement(transformation(extent={{90,-10},{110,10}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput P(start=0) annotation (Placement(
        transformation(extent={{-128,30},{-88,70}}), iconTransformation(extent=
            {{-108,50},{-88,70}})));
  Modelica.Blocks.Interfaces.RealInput Q(start=0) annotation (Placement(
        transformation(extent={{-128,-10},{-88,30}}), iconTransformation(extent=
           {{-108,10},{-88,30}})));
equation
  for i in 1:numPha loop
    P/numPha = Modelica.ComplexMath.real(vi[i].v*Modelica.ComplexMath.conj(vi[i].i));
    Q/numPha = Modelica.ComplexMath.imag(vi[i].v*Modelica.ComplexMath.conj(vi[i].i));
  end for;

  annotation (Icon(graphics={
        Ellipse(extent={{-60,60},{60,-60}}, lineColor={0,0,127}),
        Line(
          points={{-100,0},{-60,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{60,0},{100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Text(
          extent={{-20,40},{20,20}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="P"),
        Text(
          extent={{0,-20},{40,-40}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="I"),
        Text(
          extent={{-40,-20},{0,-40}},
          lineColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="V"),
        Line(
          points={{-40,0},{40,0}},
          color={135,135,135},
          smooth=Smooth.None),
        Line(
          points={{0,0},{0,-40}},
          color={135,135,135},
          smooth=Smooth.None),
        Line(
          points={{-100,80},{-100,-80}},
          color={0,0,127},
          smooth=Smooth.None)}), Diagram(graphics));
end WattsLaw;
