within Annex60.Experimental.Pipe.BaseClasses.DoublePipeConfig;
partial record DoublePipeData
  "Contains pipe properties for double pipes from catalogs"

  extends Annex60.Experimental.Pipe.BaseClasses.SinglePipeConfig.SinglePipeData;

  parameter Modelica.SIunits.Length h=Di
    "Horizontal distance between pipe walls";
  parameter Modelica.SIunits.Length Dc=2.5*Di "Diameter of circumscribing pipe";

  final parameter Modelica.SIunits.Length E=h + Do
    "Horizontal distance between pipe centers";

  final parameter Modelica.SIunits.Length rc=Dc/2 "Circumscribing radius";
  final parameter Modelica.SIunits.Length e=E/2
    "Half the distance between the center of the pipes";

  //h calculation

  final parameter Real hsInvers=2*lambdaI/lambdaG*Modelica.Math.log(2*Heff/rc)
       + Modelica.Math.log(rc^2/(2*e*ri)) + sigma*Modelica.Math.log(rc^4/(rc^4
       - e^4)) - (ri/(2*e) - sigma*2*ri*e^3/(rc^4 - e^4))/(1 + (ri/(2*e))^2 +
      sigma*(2*ri*rc^2*e/(rc^4 - e^4))^2);
  final parameter Real haInvers=Modelica.Math.log(2*e/ri) + sigma*
      Modelica.Math.log((rc^2 + e^2)/(rc^2 - e^2)) - (ri/(2*e) - gamma*e*ri/(4*
      Heff^2) + 2*sigma*ri*rc^2*e/(rc^4 - e^4))^2/(1 - (ri/(2*e))^2 - gamma*ri/
      (2*e) + 2*sigma*ri^2*rc^2*(rc^4 + e^4)/((rc^4 - e^4)^2)) - gamma*(e/(2*
      Heff))^2;

  final parameter Real sigma=(lambdaI - lambdaG)/(lambdaI + lambdaG);
  final parameter Real gamma=2*(1 - sigma^2)/(1 - sigma*(rc/(2*Heff))^2);

  annotation (Icon(graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,60},{150,100}},
          textString="%name"),
        Rectangle(
          origin={0,-25},
          lineColor={64,64,64},
          fillColor={255,215,136},
          fillPattern=FillPattern.Solid,
          extent={{-100.0,-75.0},{100.0,75.0}},
          radius=25.0),
        Line(points={{-100,0},{100,0}}, color={64,64,64}),
        Line(
          origin={0,-50},
          points={{-100.0,0.0},{100.0,0.0}},
          color={64,64,64}),
        Line(
          origin={0,-25},
          points={{0.0,75.0},{0.0,-75.0}},
          color={64,64,64})}), Documentation(revisions="<html>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">November 30, 2015 by Bram van der Heijde:<br>First implementation.</span></li>
</ul>
</html>", info="<html>
<p>Basic record structure for double pipe dimensions and insulation parameters.</p>
</html>"));
end DoublePipeData;
