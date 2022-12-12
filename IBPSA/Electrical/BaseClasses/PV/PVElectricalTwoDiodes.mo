within IBPSA.Electrical.BaseClasses.PV;
model PVElectricalTwoDiodes
  "2 diodes model for PV I-V characteristics with temp. dependency based on 9 parameters"
  extends
    IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVElectricalTwoDiodes;
  input Modelica.Blocks.Interfaces.RealInput U(unit="V")
    "Module voltage"
    annotation (Placement(transformation(extent={{-138,-20},{-100,18}}),
                                                                      iconTransformation(extent={{-10,-10},{10,10}},origin={-110,8})));
equation
  0 = IPho - ISat1 * (Modelica.Math.exp((U / n_ser + (I / n_par) * RSer)/(1.0 * Ut)) - 1.0)
    - ISat2 * (Modelica.Math.exp((U / n_ser + (I / n_par) * RSer)/(2.0 * Ut)) - 1.0)
    - (U / n_ser + (I / n_par) * RSer) / RPar - I / n_par;
  P = I * U;

  eta= if noEvent(radTil <= Modelica.Constants.eps*10) then 0 else P_mod/(radTil*A_pan);
  annotation (
Documentation(info="<html>
<p>
This is a 2 diodes electrical model of a PV module.
</p>
</html>", revisions="<html>
<ul>
<li>
October 11, 2022 by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVElectricalTwoDiodes;
