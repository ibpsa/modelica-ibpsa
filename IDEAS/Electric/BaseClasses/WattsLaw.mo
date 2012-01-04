within IDEAS.Electric.BaseClasses;
model WattsLaw
  "For use  with loads. Either symmetrically divided over 3 phases (numPha=3) or single phase (numPha=1)."
  parameter Integer numPha=3 "Choose the number of phases" annotation(choices(choice=1
        "single phase",                                                                               choice=3
        "symmetrical 3 phase"));
 Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin[
                          numPha] vi
                     annotation (Placement(transformation(extent={{90,-10},{110,10}},
                                   rotation=0)));
  Modelica.Blocks.Interfaces.RealInput P
    annotation (Placement(transformation(extent={{-120,20},{-80,60}})));
  Modelica.Blocks.Interfaces.RealInput Q
    annotation (Placement(transformation(extent={{-120,-40},{-80,0}})));
equation
    for i in 1:numPha loop
    P/numPha = Modelica.ComplexMath.real(vi[i].v*Modelica.ComplexMath.conj(vi[i].i));
    Q/numPha = Modelica.ComplexMath.imag(vi[i].v*Modelica.ComplexMath.conj(vi[i].i));
    end for;

  annotation (Icon(graphics={
        Polygon(
          points={{0,80},{-80,-60},{80,-60},{0,80}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          lineThickness=1),
        Text(
          extent={{-20,40},{20,0}},
          lineColor={0,0,255},
          lineThickness=0.5,
          textString="P"),
        Text(
          extent={{-60,-20},{-20,-60}},
          lineColor={0,0,255},
          lineThickness=0.5,
          textString="V"),
        Text(
          extent={{20,-20},{60,-60}},
          lineColor={0,0,255},
          lineThickness=0.5,
          textString="I"),
        Line(
          points={{-40,0},{40,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-10,-50},{10,-30}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-10,-30},{10,-50}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}));
end WattsLaw;
