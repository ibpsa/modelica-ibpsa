within IDEAS.Electric.BaseClasses;
model WattsLawPlug
  "For use  with loads. Either symmetrically divided over 3 phases (numPha=3) or single phase (numPha=1)."
  parameter Integer numPha=1 "Choose the number of phases" annotation (choices(
        choice=1 "single phase", choice=3 "symmetrical 3 phase"));
  parameter Integer nLoads=1;
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.NegativePlug vi(m=
        numPha) annotation (Placement(transformation(extent={{90,-10},{110,10}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput[nLoads] P annotation (Placement(
        transformation(extent={{-130,30},{-90,70}}), iconTransformation(extent=
            {{-110,50},{-90,70}})));
  Modelica.Blocks.Interfaces.RealInput[nLoads] Q annotation (Placement(
        transformation(extent={{-130,-10},{-90,30}}), iconTransformation(extent=
           {{-110,10},{-90,30}})));

  Modelica.Blocks.Math.Sum sum_P(final nin=nLoads)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Math.Sum sum_Q(final nin=nLoads)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  for i in 1:numPha loop
    sum_P.y/numPha = Modelica.ComplexMath.real(vi.pin[i].v*
      Modelica.ComplexMath.conj(vi.pin[i].i));
    sum_Q.y/numPha = Modelica.ComplexMath.imag(vi.pin[i].v*
      Modelica.ComplexMath.conj(vi.pin[i].i));
  end for;

  connect(P, sum_P.u) annotation (Line(
      points={{-110,50},{-82,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q, sum_Q.u) annotation (Line(
      points={{-110,10},{-82,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(graphics={
        Line(
          points={{-100,80},{-100,-80}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
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
          smooth=Smooth.None)}), Diagram(graphics));
end WattsLawPlug;
