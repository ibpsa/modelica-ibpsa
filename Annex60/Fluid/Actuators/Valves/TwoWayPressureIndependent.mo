within Annex60.Fluid.Actuators.Valves;
model TwoWayPressureIndependent "Model of a pressure-independent two way valve"

  extends Annex60.Fluid.Actuators.BaseClasses.PartialTwoWayValve(final linearized = false, from_dp=true, phi=l + y_actual*(1 - l));

  parameter Real l2(min=1e-10) = 0.01
    "Percentage of additional mass flow rate for higher than nominal pressures";
  parameter Real deltax = 0.1 "Transition region interval for flow rate";

protected
  Modelica.SIunits.MassFlowRate m_flow_set = m_flow_nominal*phi
    "Requested mass flow rate";
  Modelica.SIunits.Pressure dp_min = Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow_set, k=k, m_flow_turbulent=m_flow_turbulent)
    "Minimum dp required for delivering requested mass flow rate";

equation
 kVal = Kv_SI;
 if (dpFixed_nominal > Modelica.Constants.eps) then
   k = sqrt(1/(1/kFixed^2 + 1/kVal^2));
 else
   k = kVal;
 end if;

   if homotopyInitialization then
     if from_dp then
         m_flow=homotopy(actual=Annex60.Utilities.Math.Functions.spliceFunction(
                            x=dp-dp_min,
                            pos= m_flow_set + l2*(dp-dp_min)/dp_nominal*m_flow_nominal,
                            neg= Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                                  dp=dp,
                                  k=k,
                                  m_flow_turbulent=m_flow_turbulent),
                            deltax=dp_nominal_pos*deltax),
                         simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
     else

         dp=homotopy(actual=Annex60.Utilities.Math.Functions.spliceFunction(
                            x=m_flow-m_flow_set,
                            pos= dp_min + (m_flow-m_flow_set)/m_flow_nominal*dp_nominal/l2,
                            neg= Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                                  m_flow=m_flow,
                                  k=k,
                                  m_flow_turbulent=m_flow_turbulent),
                            deltax=m_flow_nominal_pos*deltax*l2),
                     simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
     end if;
   else // do not use homotopy
     if from_dp then
       m_flow=Annex60.Utilities.Math.Functions.spliceFunction(
                            x=dp-dp_min,
                            pos= m_flow_set + l2*(dp-dp_min)/dp_nominal*m_flow_nominal,
                            neg= Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                                  dp=dp,
                                  k=k,
                                  m_flow_turbulent=m_flow_turbulent),
                            deltax=dp_nominal_pos*deltax);
      else
        dp=Annex60.Utilities.Math.Functions.spliceFunction(
                            x=m_flow-m_flow_set,
                            pos= dp_min + (m_flow-m_flow_set)/m_flow_nominal*dp_nominal/l2,
                            neg= Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                                  m_flow=m_flow,
                                  k=k,
                                  m_flow_turbulent=m_flow_turbulent),
                            deltax=m_flow_nominal_pos*deltax*l2);
      end if;
    end if; // homotopyInitialization
  annotation (defaultComponentName="val",
  Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}),       graphics={
        Polygon(
          points={{2,-2},{-76,60},{-76,-60},{2,-2}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,40},{0,-2},{54,40},{54,40},{-50,40}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,-42},{0,-4},{60,40},{60,-42},{-52,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-2},{82,60},{82,-60},{0,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,40},{0,-4}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          visible=not filteredOpening,
          points={{0,100},{0,40}},
          color={0,0,0},
          smooth=Smooth.None)}),
Documentation(info="<html>
<p>
Two way valve with a pressure-independent valve opening characteristic. 
The mass flow rate is controlled such that it is (nearly) equal to 
its set point <code>y*m_flow_nominal</code> unless the pressure 
<code>dp</code> is too low, then a regular Kv characteristic is used.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 29, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayPressureIndependent;
