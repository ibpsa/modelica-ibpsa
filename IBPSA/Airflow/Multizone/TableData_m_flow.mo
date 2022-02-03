within IBPSA.Airflow.Multizone;
model TableData_m_flow
  "Mass flow(y-axis) vs Pressure(x-axis) cubic spline fit model based from table data, with last two points linearly interpolated"
  extends IBPSA.Airflow.Multizone.BaseClasses.PartialOneWayFlowElement(
    m_flow = IBPSA.Airflow.Multizone.BaseClasses.interpolate(u=dp,xd=xd,yd=yd,d=d),
    final m_flow_nominal=min(abs(table[:,2])));

  parameter Real table[:,2]
    "Table with pressure difference in Pa in first column, and mass flow rate in kg/s in second column";

protected
  parameter Real[:] xd=table[:,1] "X-axis support points";
  parameter Real[size(xd, 1)] yd=table[:,2] "Y-axis support points";
  parameter Real[size(xd, 1)] d(each fixed=false) "Derivatives at the support points";

initial equation
  d =IBPSA.Utilities.Math.Functions.splineDerivatives(
    x=xd,
    y=yd,
    ensureMonotonicity=true);

  annotation (
    Icon(graphics={
        Rectangle(
          extent={{-50,80},{50,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
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
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,78},{0,-78}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,78},{26,-78}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{0,13},{0,-13}},
          textColor={0,0,127},
          textString="m_flow",
          origin={13,0},
          rotation=90),
        Rectangle(
          extent={{-24,78},{26,58}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Forward),
        Line(points={{0,78},{0,-78}}, color={28,108,200})}),
    defaultComponentName="tabDat",
    Documentation(info="<html>
<p>
This model describes the one-directional pressure driven air flow through an
opening based on user-provided tabular data describing the relation between mass flow rate
and pressure difference over the component.
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775; = f(&Delta;p),
</p>
<p>
where <i>m&#775;</i> is the volume flow rate and
<i>&Delta;p</i> is the pressure difference.
<p>
Based on the table input, a cubic hermite spline is constructed between all points
except for the two last pairs of points. These point are connected linearly.
</p>
<p>
The constructed curve is the direct relation between <i>m&#775;</i> and <i>&Delta;p</i>.
</p>
<p>
A similar model is also used in the CONTAM software (Dols and Walton, 2015).
</p>
<h4>References</h4>
<ul>
<li>
<b>W. S. Dols and B. J. Polidoro</b>,<b>2015</b>. <i>CONTAM User Guide and Program Documentation Version 3.2</i>,
National Institute of Standards and Technology, NIST TN 1887, Sep. 2015. doi:
<a href=\"https://doi.org/10.6028/NIST.TN.1887\">10.6028/NIST.TN.1887</a>.
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
<li>Apr 6, 2021, 2020, by Klaas De Jonge:<br/>
First implementation.
</li>
</ul>
</html>
"));
end TableData_m_flow;
