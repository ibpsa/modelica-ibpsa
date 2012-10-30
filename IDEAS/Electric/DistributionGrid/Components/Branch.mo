within IDEAS.Electric.DistributionGrid.Components;
model Branch

      extends
    Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.OnePort(i(re(start = 0), im(start=0)));

      parameter Modelica.SIunits.Resistance R = 0.0057;
      parameter Modelica.SIunits.Reactance X=0.0039;
      parameter Modelica.SIunits.ComplexImpedance Z=R + Modelica.ComplexMath.j*X;

Modelica.SIunits.ActivePower Plos;

equation
  v = Z*i;
  Plos = R*(Modelica.ComplexMath.'abs'(i))^2;
end Branch;
