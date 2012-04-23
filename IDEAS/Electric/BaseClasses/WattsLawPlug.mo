within IDEAS.Electric.BaseClasses;
model WattsLawPlug
  "For use  with loads. Either symmetrically divided over 3 phases (numPha=3) or single phase (numPha=1)."
  parameter Integer numPha=1 "Choose the number of phases" annotation(choices(choice=1
        "single phase",                                                                               choice=3
        "symmetrical 3 phase"));
 Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.NegativePlug vi(m=numPha)
                     annotation (Placement(transformation(extent={{90,-10},{110,10}},
                                   rotation=0)));
  Modelica.Blocks.Interfaces.RealInput P
    annotation (Placement(transformation(extent={{-120,20},{-80,60}})));
  Modelica.Blocks.Interfaces.RealInput Q
    annotation (Placement(transformation(extent={{-120,-40},{-80,0}})));
equation
    for i in 1:numPha loop
    P/numPha = Modelica.ComplexMath.real(vi.pin[i].v*Modelica.ComplexMath.conj(vi.pin[i].i));
    Q/numPha = Modelica.ComplexMath.imag(vi.pin[i].v*Modelica.ComplexMath.conj(vi.pin[i].i));
    end for;

  annotation (Icon(graphics={
        Text(
          extent={{-20,30},{20,-10}},
          lineColor={85,170,255},
          lineThickness=0.5,
          textString="P"),
        Text(
          extent={{-50,-30},{-10,-70}},
          lineColor={85,170,255},
          lineThickness=0.5,
          textString="V"),
        Text(
          extent={{10,-30},{50,-70}},
          lineColor={85,170,255},
          lineThickness=0.5,
          textString="I"),
        Line(
          points={{-40,-20},{40,-20}},
          color={95,95,95},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-6,-56},{6,-44}},
          color={95,95,95},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-6,-44},{6,-56}},
          color={95,95,95},
          thickness=0.5,
          smooth=Smooth.None),           Polygon(
          points={{-100,-90},{0,90},{100,-90},{-100,-90}},
          lineColor={85,170,255},
          lineThickness=0.5,
          smooth=Smooth.None)}), Diagram(graphics));
end WattsLawPlug;
