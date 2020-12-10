within IBPSA.Airflow.Multizone;
model Powerlaw_2Datapoints
  "Powerlaw with coeffients fitted based on 2 datapoints"

extends IBPSA.Airflow.Multizone.BaseClasses.PowerLawResistance_mflow(m=n, final k=Cd*sqrt(rho_default));      //mass flow form of orifice equation

public
  parameter Modelica.SIunits.PressureDifference dP1 "pressure difference of first test point" annotation (Dialog(group="Test data"));
  parameter Modelica.SIunits.MassFlowRate  F1 "corresponding mass flow rate " annotation (Dialog(group="Test data"));
  parameter Modelica.SIunits.PressureDifference dP2 "pressure difference of second test point"
                                                                                              annotation (Dialog(group="Test data"));
  parameter Modelica.SIunits.MassFlowRate  F2 "corresponding mass flow rate "
                                                                             annotation (Dialog(group="Test data"));

protected
  parameter Real Cd=F1/(sqrt(rho_default)*(dP1^m)) "Discharge coeffiënt";
  parameter Real  n=(log(F1)-log(F2))/(log(dP1)-log(dP2)) "Flow exponent";

     annotation (Icon(graphics={
        Text(
          extent={{12,-62},{96,-100}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C=%C"),
        Text(
          extent={{16,-34},{92,-72}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=
               "m=%m"),
        Text(
          extent={{-86,100},{44,40}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.None,
          textString="F=C*dp^m"),
        Rectangle(
          extent={{-52,34},{50,-34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,14},{78,-12}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,6},{-62,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,8},{102,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-68,4},{-50,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-86,6},{-50,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid)}),
defaultComponentName="lea",
Documentation(info="<html>
<p><br><br><br>Model that fits the flow coeffici&euml;nt and exponent of the orifice equation (mass flow) based on 2 measerd datapoints.</p>
<p><br>A similar model is also used in the CONTAM software (Dols and Walton, 2015).</p>
<p><b>References</b></p>
<ul>
<li><b>W. S. Dols and B. J. Polidoro</b>,<b>2015</b>. <i>CONTAM User Guide and Program Documentation Version 3.2</i>, National Institute of Standards and Technology, NIST TN 1887, Sep. 2015. doi: <a href=\"https://doi.org/10.6028/NIST.TN.1887\">10.6028/NIST.TN.1887</a>. </li>
</ul>
</html>",
revisions="<html>
<ul>
<li>June 26, 2020, by Klaas De Jonge (UGent):<br/>
First implementation</li>
</ul>
</html>
"));
end Powerlaw_2Datapoints;
