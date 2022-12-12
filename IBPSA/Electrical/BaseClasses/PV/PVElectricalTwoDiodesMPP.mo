within IBPSA.Electrical.BaseClasses.PV;
model PVElectricalTwoDiodesMPP
  "MPP controlled 2 diodes model for PV I-V characteristics with temp. dependency based on 9 parameters"
  extends
    IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVElectricalTwoDiodes;
  output Modelica.Blocks.Interfaces.RealOutput U(
    unit="V",
    start = 0.0)
    "Module voltage"
    annotation (Placement(transformation(extent={{60,-10},{80,10}}), iconTransformation(extent={{60,-10},{80,10}})));
  Real lambda(start = 0.0)
    "Lagrange multiplier";

equation
  // Calculation of I_MPP and U_MPP with the calculation method extremes under constraints with Lagrange multiplier
  0 = IPho - ISat1 * (Modelica.Math.exp((U / n_ser + (I / n_par) * RSer)/(1.0 * Ut)) - 1.0)
    - ISat2 * (Modelica.Math.exp((U / n_ser + (I / n_par) * RSer)/(2.0 * Ut)) - 1.0)
    - (U / n_ser + (I / n_par) * RSer) / RPar - I / n_par;

  0 = I / n_par - lambda * ((ISat1 / (1.0 * Ut)) * Modelica.Math.exp((U / n_ser + (I / n_par) * RSer) / (1.0 * Ut))
    + (ISat2 / (2.0 * Ut))* Modelica.Math.exp((U / n_ser + (I / n_par) * RSer) / (2.0 * Ut)) + 1.0 / RPar);

  0 = U / n_ser - lambda * (( RSer * ISat1) / (1.0 * Ut) * Modelica.Math.exp((U / n_ser + (I / n_par) * RSer) / (1.0 * Ut))
    + (RSer * ISat2) / (2.0 * Ut) * Modelica.Math.exp((U / n_ser + (I / n_par) * RSer) / (2.0 * Ut)) + RSer / RPar + 1.0);

  P = I * U;
  annotation (
Documentation(info="<html>
<p>
This is a 2 diodes MPP controlled electrical model of a PV module.
</p>
</html>", revisions="<html>
<ul>
<li>
October 11, 2022 by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVElectricalTwoDiodesMPP;
