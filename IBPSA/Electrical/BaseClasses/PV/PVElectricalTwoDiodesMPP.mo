within IBPSA.Electrical.BaseClasses.PV;
model PVElectricalTwoDiodesMPP
  "2 diodes model for PV I-V characteristics 
  with temp. dependency based on 9 parameters with automatic MPP tracking"
  extends
    IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVElectricalTwoDiodes;
  Real lambda(start = 0.0)
    "Lagrange multiplier";

  output Modelica.Blocks.Interfaces.RealOutput U(
    unit="V",
    start = 0.0)
    "Module voltage"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
                                                                     iconTransformation(extent={{100,-10},
            {120,10}})));

equation
  // Calculation of I_MPP and U_MPP with the calculation method extremes under constraints with Lagrange multiplier
  0 = I_ph - I_s1 * (Modelica.Math.exp((U / n_ser + (I / n_par) * R_s)/(1.0 * Ut)) - 1.0)
    - I_s2 * (Modelica.Math.exp((U / n_ser + (I / n_par) * R_s)/(2.0 * Ut)) - 1.0)
    - (U / n_ser + (I / n_par) * R_s) / R_sh - I / n_par;

  0 = I / n_par - lambda * ((I_s1 / (1.0 * Ut)) * Modelica.Math.exp((U / n_ser + (I / n_par) * R_s) / (1.0 * Ut))
    + (I_s2 / (2.0 * Ut))* Modelica.Math.exp((U / n_ser + (I / n_par) * R_s) / (2.0 * Ut)) + 1.0 / R_sh);

  0 = U / n_ser - lambda * (( R_s * I_s1) / (1.0 * Ut) * Modelica.Math.exp((U / n_ser + (I / n_par) * R_s) / (1.0 * Ut))
    + (R_s * I_s2) / (2.0 * Ut) * Modelica.Math.exp((U / n_ser + (I / n_par) * R_s) / (2.0 * Ut)) + R_s / R_sh + 1.0);

  P = I * U * n_mod;
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
