within IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem;
model PVElectrical2DiodesMPP
  "MPP controlled 2 diodes model for PV I-V characteristics with temp. dependency based on 9 parameters"
  extends
    IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVElectrical2Diodes;
  output Modelica.Blocks.Interfaces.RealOutput U(
    unit="V",
    start = 0.0)
    "Module voltage"
    annotation (Placement(transformation(extent={{60,-10},{80,10}}), iconTransformation(extent={{60,-10},{80,10}})));
  Real lambda(start = 0.0)
    "Lagrange multiplier";

equation
  // Calculation of I_MPP and U_MPP with the calculation method extremes under constraints with Lagrange multiplier
  0 = IPho - ISat1 * (Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer)/(1.0 * Ut)) - 1.0)
    - ISat2 * (Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer)/(2.0 * Ut)) - 1.0)
    - (U / nCelSer + (I / nCelPar) * RSer) / RPar - I / nCelPar;

  0 = I / nCelPar - lambda * ((ISat1 / (1.0 * Ut)) * Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer) / (1.0 * Ut))
    + (ISat2 / (2.0 * Ut))* Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer) / (2.0 * Ut)) + 1.0 / RPar);

  0 = U / nCelSer - lambda * (( RSer * ISat1) / (1.0 * Ut) * Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer) / (1.0 * Ut))
    + (RSer * ISat2) / (2.0 * Ut) * Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer) / (2.0 * Ut)) + RSer / RPar + 1.0);

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
end PVElectrical2DiodesMPP;
