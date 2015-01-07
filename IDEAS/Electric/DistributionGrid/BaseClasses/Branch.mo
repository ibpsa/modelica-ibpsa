within IDEAS.Electric.DistributionGrid.BaseClasses;
model Branch

  extends Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.OnePort(i(
        re(start=0), im(start=0)));
  Modelica.SIunits.ActivePower Plos;

  parameter Modelica.SIunits.Resistance R=0.0057;
  parameter Modelica.SIunits.Reactance X=0.0039;
  final parameter Modelica.SIunits.ComplexImpedance Z=Complex(R, X);

equation
  v = Z*i;
  Plos = R*Modelica.ComplexMath.'abs'(i)^2;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Rectangle(
          extent={{-40,12},{40,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{40,0},{100,0}}, color={0,0,0}),
        Line(points={{-100,0},{-40,0}}, color={0,0,0})}));
end Branch;
