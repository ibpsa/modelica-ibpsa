within IDEAS.Electric.BaseClasses.AC;
model WattsLaw "For use  with loads"
  parameter Integer numPha=1 "Choose the number of phases" annotation (choices(
        choice=1 "Single-phase", choice=3 "Symmetrical three-phase"));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.NegativePin[numPha]
    vi annotation (Placement(transformation(extent={{90,-10},{110,10}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput P(start=0) annotation (Placement(
        transformation(extent={{-130,-10},{-90,30}}),iconTransformation(extent={{-110,10},
            {-90,30}})));
  Modelica.Blocks.Interfaces.RealInput Q(start=0) annotation (Placement(
        transformation(extent={{-130,-50},{-90,-10}}),iconTransformation(extent={{-110,
            -30},{-90,-10}})));
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
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                         graphics),Documentation(info="<html>
<p>
This model converts the apparent power to a nodal voltage and current. It can be used for single-phase (numPha=1) loads or three-phase (numPha=3) loads (symmetrically divided over all phases)
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2015 by Juan Van Roy:<br/>
Documentation added.
</li>
</ul>
</html>"));
end WattsLaw;
