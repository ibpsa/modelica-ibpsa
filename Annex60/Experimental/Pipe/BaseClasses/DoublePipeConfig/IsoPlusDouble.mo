within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig;
partial record IsoPlusDouble "IsoPlus double pipes"
  // Pipes in shared insulation buried underground
  extends PipeData(lambdaI=0.028);

  // Resistance parameters for two pipes embedded in the same insulation
  final parameter Real hsInvers=
    2*lambdaI/lambdaG*Modelica.Math.log(2*Heff/rc) +
    Modelica.Math.log(rc^2/(2*e*ri)) +
    sigma*Modelica.Math.log(rc^4/(rc^4-e^4)) -
    (ri/(2*e) - sigma*2*ri*e^3/(rc^4-e^4))/(1+(ri/(2*e))^2 + sigma*(2*ri*rc^2*e/(rc^4-e^4))^2);
  final parameter Real haInvers=
    Modelica.Math.log(2*e/ri) +
    sigma*Modelica.Math.log((rc^2+e^2)/(rc^2-e^2)) -
    (ri/(2*e)-gamma*e*ri/(4*Heff^2)+2*sigma*ri*rc^2*e/(rc^4-e^4))^2/(1-(ri/(2*e))^2-gamma*ri/(2*e)+2*sigma*ri^2*rc^2*(rc^4+e^4)/((rc^4-e^4)^2))
    - gamma*(e/(2*Heff))^2;

  final parameter Real sigma = (lambdaI-lambdaG)/(lambdaI+lambdaG);
  final parameter Real gamma = 2*(1-sigma^2)/(1-sigma*(rc/(2*Heff))^2);
  annotation (Documentation(revisions="<html>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">November 30, 2015 by Bram van der Heijde:<br>First implementation.</span></li>
</ul>
</html>", info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basic record structure for pipe dimensions and insulation parameters, in the specific case of IsoPlus double pipes. Data from IsoPlus catalogue. </span></p>
</html>"));
end IsoPlusDouble;
