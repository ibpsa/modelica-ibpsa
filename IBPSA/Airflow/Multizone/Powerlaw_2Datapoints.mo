within IBPSA.Airflow.Multizone;
model Powerlaw_2Datapoints
  "Powerlaw with flow coefficient and flow exponent fitted based on 2 datapoints"
  extends IBPSA.Airflow.Multizone.Powerlaw_m_flow(
    final C=C2*sqrt(rho_default),
    final m=m2);

  parameter Modelica.Units.SI.PressureDifference dP1
      "Pressure difference of first test point"
    annotation (Dialog(group="Test data"));
  parameter Modelica.Units.SI.MassFlowRate  m1_flow
      "Mass flow rate of first test point"
    annotation (Dialog(group="Test data"));
  parameter Modelica.Units.SI.PressureDifference dP2
      "Pressure difference of second test point"
    annotation (Dialog(group="Test data"));
  parameter Modelica.Units.SI.MassFlowRate  m2_flow
      "Mass flow rate of second test point" annotation (Dialog(group="Test data"));
protected
  parameter Real C2 = m1_flow/(sqrt(rho_default)*(dP1^m2)) "Flow coeffient";
  parameter Real m2 = (log(m1_flow)-log(m2_flow))/(log(dP1)-log(dP2)) "Flow exponent";

     annotation (
    Icon(graphics={
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
    defaultComponentName="powLaw",
    Documentation(info="<html>
<p>
Model that fits the flow coefficient of the massflow version of the
orifice equation based on 2 datapoints of mass flow rate and pressure difference.
</p>
<p>
A similar model is also used in the CONTAM software (Dols and Walton, 2015).
</p>
<p><b>References</b></p>
<ul>
<li>
<b>W. S. Dols and B. J. Polidoro</b>,<b>2015</b>.
<i>CONTAM User Guide and Program Documentation Version 3.2</i>,
National Institute of Standards and Technology, NIST TN 1887, Sep. 2015. doi: <a href=\"https://doi.org/10.6028/NIST.TN.1887\">10.6028/NIST.TN.1887</a>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
Apr 6, 2021, by Klaas De Jonge:<br/>
First implementation.
</li>
</ul>
</html>
"));
end Powerlaw_2Datapoints;
