within IBPSA.Fluid.HeatPumps.BlackBoxData.Functions;
function PolynomalApproach
  "Function to emulate the polynomal approach of the TRNSYS Type 401 heat pump model"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.Functions.BaseClasses.PartialBaseFct;
  parameter Modelica.Units.SI.Power p[6] = {0,0,0,0,0,0}
    "Polynomal coefficient for the electrical power";
  parameter Modelica.Units.SI.HeatFlowRate q[6] = {0,0,0,0,0,0}
    "Polynomal coefficient for the condenser heat flow";

protected
  Real TEva_normalized=TEvaIn/273.15 + 1 "Normalized evaporator temperature";
  Real TCon_normalized=TConOut/273.15 + 1 "Normalized condenser temperature";
algorithm
  if N >= Modelica.Constants.eps then
    //Pel
    Char[1] :=p[1] + p[2]*TEva_normalized + p[3]*TCon_normalized + p[4]*
      TCon_normalized*TEva_normalized + p[5]*TEva_normalized^2 + p[6]*
      TCon_normalized^2;
    //QCon
    Char[2] :=q[1] + q[2]*TEva_normalized + q[3]*TCon_normalized + q[4]*
      TCon_normalized*TEva_normalized + q[5]*TEva_normalized^2 + q[6]*
      TCon_normalized^2;
  else //Maybe something better could be used such as smooth()
    Char[1] := 0;
    Char[2] := 0;
  end if;
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Based on the work of Afjej and Wetter, 1997 [1] and the TRNYS Type
  401 heat pump model, this function uses a six-coefficient polynom to
  calculate the electrical power and the heat flow to the condenser.
  The coefficients are calculated based on the data in DIN EN 14511
  with a minimization-problem in python using the
  root-mean-square-error.
</p>
<p>
  The normalized input temperatures are calculated with the formular:
</p>
<p style=\"text-align:center;\">
  <i>T_n = (T/273.15) + 1</i>
</p>
<p>
  The coefficients for the polynomal functions are stored inside the
  record for heat pumps in <a href=
  \"modelica://IBPSA.Fluid.HeatPumps.BlackBoxData.Functions\">
  IBPSA.Fluid.HeatPumps.BlackBoxData.Functions</a>.
</p>
<p>
  [1]: https://www.trnsys.de/download/en/ts_type_401_en.pdf
</p>
</html>"));
end PolynomalApproach;
