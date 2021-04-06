within IBPSA.Airflow.Multizone;
model Powerlaw_1Datapoint
  "Powerlaw with flow coeffient fitted based on flow exponent and 1 datapoint"
  extends IBPSA.Airflow.Multizone.BaseClasses.PartialPowerLawResistance_mflow(
    m=0.5, k=C*sqrt(rho_default)); //mass flow form of orifice equation
    // fixme : Since C is a protected variable, it may be better to directly use the expression for k=F1/dP1^m
    // fixme : Is it intended for users to change the values of m and k? If not, then they can be hidden with the final keyword.

  parameter Modelica.SIunits.PressureDifference dP1
      "Pressure difference of test point"
    annotation (Dialog(group="Test data"));
  // fixme: Is F a commonly used variable for mass flow rate in the zonal air flow litterature? Consider using m1_flow (I assume F1 comes from Contam terminology).
  parameter Modelica.SIunits.MassFlowRate  F1
      "Mass flow rate of test point"
    annotation (Dialog(group="Test data"));

protected
  parameter Real C=F1/(sqrt(rho_default)*(dP1^m)) "Flow coeffiënt";

  // fixme : A validation/test case is missing.
     annotation (Icon(graphics={
        Text(
          extent={{12,-64},{96,-102}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C=%C"),
        Text(
          extent={{10,-40},{86,-78}},
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
<p><br><br><br>Model that fits the flow coeffici&euml;nt of the massflow version of the orifice equation based on 1 measured datapoint and given flow exponent. </p>
<p><br><br><br>A similar model is also used in the CONTAM software (Dols and Walton, 2015).</p>
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
end Powerlaw_1Datapoint;
