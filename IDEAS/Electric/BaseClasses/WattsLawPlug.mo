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
        transformation(extent={{-120,20},{-80,60}}), iconTransformation(extent={{-100,40},
            {-80,60}})));
  Modelica.Blocks.Interfaces.RealInput[nLoads] Q annotation (Placement(
        transformation(extent={{-130,-20},{-90,20}}), iconTransformation(extent={{-110,0},
            {-90,20}})));

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
      points={{-100,40},{-96,40},{-96,50},{-82,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q, sum_Q.u) annotation (Line(
      points={{-110,0},{-96,0},{-96,10},{-82,10}},
      color={0,0,127},
      smooth=Smooth.None));
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
          points={{-26,24},{-26,-26}},
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
          points={{-14,24},{-14,-26}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{40,60},{40,-60}},
          color={0,0,0},
          smooth=Smooth.None)}), Diagram(graphics));
end WattsLawPlug;
