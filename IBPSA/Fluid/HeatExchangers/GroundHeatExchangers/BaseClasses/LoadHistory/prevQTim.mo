within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.LoadHistory;
function prevQTim "Outputs the elapsed time in the previous load history"
  extends Modelica.Icons.Function;

  input String prevQFilNam "File path to where matrix data is stored";
  input Integer prevQnrow "Number of lines in file";
  input Boolean prevQfromFile "Whether or not load history is used";

  output Real timDiff "Elapsed time in load history";

protected
  String strLine;
  Real number1, number2;

algorithm
  if prevQfromFile and prevQFilNam<>"NoName"
    and not Modelica.Utilities.Strings.isEmpty(prevQFilNam)
    and prevQnrow>1 then
      strLine := Modelica.Utilities.Streams.readLine(prevQFilNam,1);
      number1 := Modelica.Utilities.Strings.scanReal(strLine);

      strLine := Modelica.Utilities.Streams.readLine(prevQFilNam,prevQnrow);
      number2 := Modelica.Utilities.Strings.scanReal(strLine);

      timDiff := number2 - number1;

      assert(timDiff>=0,
        "Load history file isn't chronological.");
  else
    timDiff:=0;
  end if;
end prevQTim;
