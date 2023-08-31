within IBPSA.Electrical.Data.PV;
record TwoDiodesData
  "Basic record of a PV module with two diodes base model"
  extends Modelica.Icons.Record;
  extends IBPSA.Electrical.Data.PV.Generic;

  parameter Real c1(unit = "m2/V")
    "1st coefficient IPho";
  parameter Real c2(unit = "m2/(kV.K)")
    "2nd coefficient IPho";
  parameter Real cs1(unit = "A/K3")
    "1st coefficient ISat1";
  parameter Real cs2(unit = "A/(K5)")
    "2nd coefficient ISat2";
  parameter Modelica.Units.SI.Resistance R_s
    "Serial resistance";
  parameter Modelica.Units.SI.Resistance R_sh
    "Parallel resistance";
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(
            preserveAspectRatio=false)));
end TwoDiodesData;
