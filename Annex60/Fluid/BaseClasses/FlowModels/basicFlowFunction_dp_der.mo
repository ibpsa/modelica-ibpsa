within Annex60.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_dp_der "Derivative of flow function"
  input Modelica.SIunits.Pressure dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real k(min=0, unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Real dp_der
    "Derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  output Real m_flow_der(unit="kg/s2")
    "Derivative of mass flow rate in design flow direction";
protected
  Real m_k = m_flow_turbulent/k "Auxiliary variable";
  Modelica.SIunits.Pressure dp_turbulent = (m_k)^2
    "Pressure where flow changes to turbulent";
algorithm
 m_flow_der := (if noEvent(dp>dp_turbulent) then 0.5*k/sqrt(dp)
                elseif noEvent(dp<-dp_turbulent) then 0.5*k/sqrt(-dp)
                else 1.25*k/m_k-0.75*k/m_k^5*dp^2)*dp_der;

 annotation (LateInline=true,
             smoothOrder=1,
             derivative(order=2, zeroDerivative=k, zeroDerivative=m_flow_turbulent)=
               Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2,
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
end basicFlowFunction_dp_der;
