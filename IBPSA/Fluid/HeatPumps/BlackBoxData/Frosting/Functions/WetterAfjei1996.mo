within IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions;
function WetterAfjei1996
  "Correction of COP (Icing, Defrost) according to Wetter,Afjei 1996"
  extends
    IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions.PartialBaseFct;

  parameter Real facA=0.03 "Factor for linear term";
  parameter Real facB=-0.004 "Factor for linear term";
  parameter Real facC=0.1534 "Factor for gaussian curve";
  parameter Real facD=0.8869 "Factor for gaussian curve";
  parameter Real facE=26.06 "Factor for gaussian curve";
protected
  Real fac "Probability of icing";
  Real linTer "Linear part of equation";
  Real gauTer "Gaussian part of equation";
algorithm
  linTer := facA + facB*TEvaInMea;
  gauTer := facC*Modelica.Math.exp(-(TEvaInMea - facD)*(TEvaInMea - facD)/facE);
  if linTer > 0 then
    fac := linTer + gauTer;
  else
    fac := gauTer;
  end if;
  iceFac:=1 - fac;
  annotation (Documentation(info="<html>
<p>Correction of CoP (Icing, Defrost) according to Wetter, Afjei 1996. </p>
</html>",
  revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end WetterAfjei1996;
