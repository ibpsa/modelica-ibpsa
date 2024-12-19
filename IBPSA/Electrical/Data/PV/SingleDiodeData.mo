within IBPSA.Electrical.Data.PV;
record SingleDiodeData
  "Basic record of a PV module with single diode base model"
  extends Modelica.Icons.Record;
  extends IBPSA.Electrical.Data.PV.Generic;

  parameter Modelica.Units.SI.Efficiency eta0
    "Efficiency under standard conditions. If not found in data sheet, use eta0 = ((VMP0*IMP0)/(1000*ACel*nSer))"
    annotation (Dialog(group="General"));

  parameter Modelica.Units.SI.ElectricCurrent IMP0
    "MPP current under standard conditions"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.Power PMP0
    "MPP power of one PV module under standard conditions"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Real TCoeISC(unit="A/K")
    "Temperature coefficient for short circuit current, >0. If not found in data sheet, use TCoeISC=alphaISC*ISC0 and type in alphaISC manually"
    annotation(Dialog(group="Cell specific: Electrical characteristics"));
  parameter Real TCoeVOC(unit="V/K")
    "Temperature coefficient for open circuit voltage, <0. If not found in data sheet, use TCoeVOC=betaVOC*VOC0 and type in betaVOC manually"
    annotation(Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.LinearTemperatureCoefficient alphaISC=TCoeISC/
      ISC0 "Normalized temperature coefficient for short circuit current, >0"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.LinearTemperatureCoefficient betaVOC=TCoeVOC/VOC0
    "Normalized temperature coefficient for open circuit voltage, <0"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.LinearTemperatureCoefficient gammaPMP
    "Normalized temperature coefficient for power at MPP"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.Voltage VOC0
    "Open circuit voltage under standard conditions"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.ElectricCurrent ISC0
    "Short circuit current under standard conditions"
    annotation (Dialog(group="Cell specific: Electrical characteristics"));
  parameter Modelica.Units.SI.Voltage VMP0
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
