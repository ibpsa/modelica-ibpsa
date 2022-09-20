within IBPSA.Fluid.HeatPumps.BlackBoxData.Functions;
function CarnotFunction
  "Function to emulate the polynomal approach of the Carnot_y heat pump model"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.Functions.BaseClasses.PartialBaseFct;
  parameter Modelica.Units.SI.Power Pel_nominal=2000
    "Constant nominal electric power";
  parameter Real etaCarnot_nominal(unit="1") = 0.5
      "Carnot effectiveness (=COP/COP_Carnot) used if use_eta_Carnot_nominal = true"
      annotation (Dialog(group="Efficiency", enable=use_eta_Carnot_nominal));

  parameter Real a[:] = {1}
    "Coefficients for efficiency curve (need p(a=a, yPL=1)=1)"
    annotation (Dialog(group="Efficiency"));
protected
  Modelica.Units.SI.Power Pel;
  Real COP;
  Real COP_carnot;
  Real etaPartLoad = IBPSA.Utilities.Math.Functions.polynomial(a=a, x=N);
algorithm
  assert(abs(T_con - T_eva)>Modelica.Constants.eps, "Temperatures have to differ to calculate the Carnot efficiency", AssertionLevel.warning);
  COP_carnot :=T_con/(T_con - T_eva);
  Pel :=Pel_nominal*N;
  COP :=etaCarnot_nominal*etaPartLoad*COP_carnot;
  Char[1] :=Pel;
  Char[2] :=COP*Pel;
  annotation (Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This function emulates the Carnot model (<a href=
  \"modelica://IBPSA.Fluid.Chillers.BaseClasses.Carnot\">IBPSA.Fluid.Chillers.BaseClasses.Carnot</a>).
  See this description for more info on assumptions etc.
</p>
</html>"));
end CarnotFunction;
