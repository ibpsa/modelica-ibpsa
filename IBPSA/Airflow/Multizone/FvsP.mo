within IBPSA.Airflow.Multizone;
model FvsP "F vs P cubic spline fit model"

extends IBPSA.Airflow.Multizone.BaseClasses.PartialOneWayFlowelement;

parameter Real table[:,:]=[-50,-0.08709; -25,-0.06158; -10,-0.03895; -5,-0.02754;
      -3,-0.02133; -2,-0.01742; -1,-0.01232; 0,0; 1,0.01232; 2,0.01742; 3,0.02133;
      4.5,0.02613; 50,0.02614] "1 column: reference pressure, 2 column: corresponding mass flow rate unit= kg/s";

equation

m_flow =IBPSA.Airflow.Multizone.BaseClasses.flowElementData(u=dp, table=table[:, :]);


  annotation (Icon(graphics={
        Rectangle(
          extent={{-50,44},{50,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,12},{50,-12}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-60,94},{60,50}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="F vs P"),
        Rectangle(
          extent={{-100,6},{-50,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,6},{100,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This model describes the one-directional pressure driven air flow through an opening based on fixed tabular input describing the relation between massflow and the pressure difference over the component.</p>
<p><img src=\"modelica://IBPSA/Resources/Images/equations/equation-e8kZTJdc.png\" alt=\"m_flow = f(dp)\"/></p>
<p><i>dp = the pressure difference over the flow element</i></p>
<p><i>m_flow = the mass flow through the element (positive from A-&gt;B)</i></p>
<p>Based on the table input, a cubic hermite spline is constructed between all point except for the second to last and last point. These point are connected linearly. The constructed curve is the direct relation between dp and m_flow. </p>
<p><br>A similar model is also used in the CONTAM software (Dols and Walton, 2015). </p>
<h4>References</h4>
<ul>
<li><b>W. S. Dols and B. J. Polidoro</b>,<b>2015</b>. <i>CONTAM User Guide and Program Documentation Version 3.2</i>, National Institute of Standards and Technology, NIST TN 1887, Sep. 2015. doi: <a href=\"https://doi.org/10.6028/NIST.TN.1887\">10.6028/NIST.TN.1887</a>. </li>
</ul>
</html>", revisions="<html>
<ul>
<li>
Jun 26, 2020, by Klaas De Jonge:<br/>
First release
</li>
</ul>
</html>"));
end FvsP;
