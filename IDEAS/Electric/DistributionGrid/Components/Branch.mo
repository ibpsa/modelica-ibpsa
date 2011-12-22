within IDEAS.Electric.DistributionGrid.Components;
model Branch
      extends IDEAS.Electric.DistributionGrid.Components.COnePort;

      parameter Modelica.SIunits.Resistance R = 0.0057;
      parameter Modelica.SIunits.Reactance X=0.0039;
      Modelica.SIunits.ComplexImpedance Z;

Modelica.SIunits.ActivePower Plos;

equation
      Z = R + Modelica.ComplexMath.j*X;
      v = Z*i;
  Plos = R*(Modelica.ComplexMath.'abs'(i))^2;
end Branch;
