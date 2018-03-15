within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.LoadHistory;
function readLineHistory
  "Read line from file, encapsulated to avoid potential memory issues with large files."
  extends Modelica.Icons.Function;

  input String filNam "File path to where data is stored";
  input Integer lin "Line to read";

  output Real t;
  output Real y;

protected
  String strLine;
  Integer nextIndex;

algorithm
  strLine := Modelica.Utilities.Streams.readLine(filNam,lin);
  (t, nextIndex) := Modelica.Utilities.Strings.scanReal(strLine);
  y := Modelica.Utilities.Strings.scanReal(strLine, nextIndex);

end readLineHistory;
