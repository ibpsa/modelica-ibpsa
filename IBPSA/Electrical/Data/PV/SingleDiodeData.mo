within IBPSA.Electrical.Data.PV;
record SingleDiodeData
  "Basic record of a PV module with single diode base model"
  extends Modelica.Icons.Record;
  extends IBPSA.Electrical.Data.PV.Generic;

  parameter Modelica.Units.SI.Efficiency eta_0
    "Efficiency under standard conditions. If not found in data sheet, use eta_0 = ((V_mp0*I_mp0)/(1000*A_cel*n_ser))"
    annotation (Dialog(group="General"));

  parameter Modelica.Units.SI.ElectricCurrent I_mp0
    "MPP current under standard conditions"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.Power P_mp0
    "MPP power of one PV module under standard conditions"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Real TCoeff_Isc(unit = "A/K")
    "Temperature coefficient for short circuit current, >0. If not found in data sheet, use TCoeff_Isc=alpha_Isc*I_sc0 and type in alpha_Isc manually"
    annotation(Dialog(group="Cell specific: Electrical characteristics"));
  parameter Real TCoeff_Voc(unit = "V/K")
    "Temperature coefficient for open circuit voltage, <0. If not found in data sheet, use TCoeff_Voc=beta_Voc*V_oc0 and type in beta_Voc manually"
    annotation(Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.LinearTemperatureCoefficient alpha_Isc=
     TCoeff_Isc/I_sc0
    "Normalized temperature coefficient for short circuit current, >0"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.LinearTemperatureCoefficient beta_Voc=TCoeff_Voc/
    V_oc0
    "Normalized temperature coefficient for open circuit voltage, <0"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.LinearTemperatureCoefficient gamma_Pmp
    "Normalized temperature coefficient for power at MPP"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.Voltage V_oc0
    "Open circuit voltage under standard conditions"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.ElectricCurrent I_sc0
    "Short circuit current under standard conditions"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.Voltage V_mp0
    "MPP voltage under standard conditions"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Real C
    "Band gap temperature coefficient; for Silicon: 0.0002677";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
          preserveAspectRatio=false)),Documentation(info="<html>
<p>
This is the base data model for the data models for the single-diode PV model.
</p>
</html>",
        revisions="<html>
<ul>
<li>
Oct 6, 2023, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleDiodeData;
