within IBPSA.Electrical.BaseClasses.PV;
model PVElectrical2Diodes
  "2 diodes model for PV I-V characteristics with temp. dependency based on 9 parameters"
  extends
    IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVElectrical2Diodes;
  input Modelica.Blocks.Interfaces.RealInput U(unit="V")
    "Module voltage"
    annotation (Placement(transformation(extent={{-138,-20},{-100,18}}),
                                                                      iconTransformation(extent={{-10,-10},{10,10}},origin={-110,8})));
equation
  0 = IPho - ISat1 * (Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer)/(1.0 * Ut)) - 1.0)
    - ISat2 * (Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer)/(2.0 * Ut)) - 1.0)
    - (U / nCelSer + (I / nCelPar) * RSer) / RPar - I / nCelPar;
  P = I * U;
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
end PVElectrical2Diodes;
