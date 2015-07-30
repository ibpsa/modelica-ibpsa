within Annex60.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_dp_der2 "2nd derivative of flow function"
  input Modelica.SIunits.Pressure dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real k(min=0, unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0) "Mass flow rate";
  input Real dp_der
    "1st derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real dp_der2
    "2nd derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  output Real m_flow_der2
    "2nd derivative of mass flow rate in design flow direction";
algorithm
 m_flow_der2 := (if noEvent(dp>m_flow_turbulent^2/k/k) then -0.25*k*dp^(-1.5) else
                   if noEvent(dp<-m_flow_turbulent^2/k/k) then 0.25*k*(-dp)^(-1.5) else
                     -6*k/4/(m_flow_turbulent/k)^5*dp)*dp_der
                +(if noEvent(dp>m_flow_turbulent^2/k/k) then 0.5*k/sqrt(dp) else
                   if noEvent(dp<-m_flow_turbulent^2/k/k) then 0.5*k/sqrt(-dp) else
                     (k^2*5/4/m_flow_turbulent)-3*k/4/(m_flow_turbulent/k)^5*dp^2)*dp_der2;

 annotation (LateInline=true,
             Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Line(
          points={{-80,-40},{-80,60},{80,-40},{80,60}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=1), Text(
          extent={{-40,-40},{40,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={232,0,0},
          textString="%name")}),
Documentation(info="<html>
<p>
Function that implements the first order derivative of
<a href=\"modelica://Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>
with respect to the mass flow rate.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 29, 2015, by Michael Wetter:<br/>
First implementation to avoid in Dymola 2016 the warning
\"Differentiating ... under the assumption that it is continuous at switching\".
</li>
</ul>
</html>"));
end basicFlowFunction_dp_der2;
