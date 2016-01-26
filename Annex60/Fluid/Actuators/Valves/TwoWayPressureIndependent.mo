within Annex60.Fluid.Actuators.Valves;
model TwoWayPressureIndependent "Model of a pressure-independent two way valve"
  extends Annex60.Fluid.Actuators.BaseClasses.PartialTwoWayValve(
            final linearized = false,
            from_dp=true,
            phi=l + y_actual*(1 - l));

  parameter Real l2(min=1e-10) = 0.0005
    "Gain for mass flow increase if pressure is above nominal pressure"
    annotation(Dialog(tab="Advanced"));

protected
  Modelica.SIunits.PressureDifference dpTraLow(displayUnit="Pa")
    "Pressure drop for lower transition";
  Modelica.SIunits.PressureDifference dpTraHig(displayUnit="Pa")
    "Pressure drop for upper transition";

  Modelica.SIunits.MassFlowRate mTraLow_flow
    "Mass flow rate for lower transition";
  Modelica.SIunits.MassFlowRate mTraHig_flow
    "Mass flow rate for upper transition";

  Modelica.SIunits.MassFlowRate m_flow_set "Requested mass flow rate";
  Modelica.SIunits.Pressure dp_min
    "Minimum dp required for delivering requested mass flow rate";

  //Modelica.SIunits.MassFlowRate m_flow_cor "Correction for mass flow rate";
  //Modelica.SIunits.Pressure dp_cor "Correction for dp";
equation
  m_flow_set = m_flow_nominal*phi;

  // Compute the region in which the model transitions to
  // setting m_flow_set. In theory, this should be at dp = dp_min.
  // However, as the model typically often operates around dp_min
  // in a well designed and well controlled system, we are bounding
  // the transition slightly away from this region so that for this
  // operating area, we will only need to evaluate a linear equation
  // rather than the cubic spline interpolation that is used in this transition.
  if from_dp then
    dp_min = Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
              m_flow=m_flow_set,
              k=k,
              m_flow_turbulent=m_flow_turbulent);

    dpTraLow = 0.925*dp_min;
    dpTraHig = 0.975*dp_min;
    mTraLow_flow = 0;
    mTraHig_flow = 0;
  else // Fixme: The implementation for from_dp = false seems wrong
    dp_min   = Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
              m_flow=m_flow_set,
              k=k,
              m_flow_turbulent=m_flow_turbulent);
    dpTraLow = 0.925*dp_min;
    dpTraHig = 0.975*dp_min;
    mTraLow_flow = Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
              dp=dpTraLow,
              k=k,
              m_flow_turbulent=m_flow_turbulent);
    mTraHig_flow = m_flow_set + (dp-dp_min)/dp_nominal*m_flow_nominal*l2;
    end if;

 kVal = Kv_SI;
 if (dpFixed_nominal > Modelica.Constants.eps) then
   k = sqrt(1/(1/kFixed^2 + 1/kVal^2));
 else
   k = kVal;
 end if;

 // fixme: if we agree with the implementation,
 // then this also needs to be implemented for homotopyInitialization = false
// if homotopyInitialization then
  if from_dp then
    m_flow=homotopy(
      actual=
        if dp < dpTraLow then
          Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                               dp=dp,
                               k=k,
                               m_flow_turbulent=m_flow_turbulent)
        elseif dp > dpTraHig then
          m_flow_set + (dp-dp_min)/dp_nominal*m_flow_nominal*l2
        else
          Modelica.Fluid.Utilities.cubicHermite(
          x=   dp,
          x1=  dpTraLow,
          x2=  dpTraHig,
          y1=  Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                                  dp=dpTraLow,
                                  k=k,
                                  m_flow_turbulent=m_flow_turbulent),
          y2=  m_flow_set + (dpTraHig-dp_min)/dp_nominal*m_flow_nominal*l2,
          y1d=  Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
                                  dp=dpTraLow,
                                  k=k,
                                  m_flow_turbulent=m_flow_turbulent,
                                  dp_der=  1),
          y2d=  m_flow_nominal*l2/dp_nominal),
      simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
  else
    dp=homotopy(
      actual=
        if m_flow < mTraLow_flow then
          Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                               m_flow=m_flow,
                               k=k,
                               m_flow_turbulent=m_flow_turbulent)
        elseif m_flow > mTraHig_flow then
          dp_min + (m_flow-m_flow_set)*dp_nominal/(m_flow_nominal*l2)
        else
          Modelica.Fluid.Utilities.cubicHermite(
          x=   m_flow,
          x1=  mTraLow_flow,
          x2=  mTraHig_flow,
          y1=  Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                                  m_flow=mTraLow_flow,
                                  k=k,
                                  m_flow_turbulent=m_flow_turbulent),
          y2=  dp_min + (mTraHig_flow-m_flow_set)*dp_nominal/(m_flow_nominal*l2),
          y1d=  Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der(
                                  m_flow=mTraLow_flow,
                                  k=k,
                                  m_flow_turbulent=m_flow_turbulent,
                                  m_flow_der=  1),
          y2d=  dp_nominal/(m_flow_nominal*l2)),
      simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
    end if;

// else // do not use homotopy
//   if from_dp then
//     m_flow=m_flow_set-m_flow_cor;
 //   else
//      dp=0; // fixme: not yet implemented dp_min-dp_cor;
//    end if;
//  end if; // homotopyInitialization
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
          points={{0,40},{0,-4}}),
        Line(
          visible=not filteredOpening,
          points={{0,100},{0,40}})}),
Documentation(info="<html>
<p>
Two way valve with a pressure-independent valve opening characteristic.
The mass flow rate is controlled such that it is nearly equal to its
set point <code>y*m_flow_nominal</code>, unless the pressure
<code>dp</code> is too low, in which case a regular <code>Kv</code>
characteristic is used.
</p>
<h4>Main equations</h4>
<p>
First the minimum pressure head <code>dp_min</code>
required for delivering the requested mass flow rate
<code>y*m_flow_nominal</code> is computed. If
<code>dp &gt; dp_min</code> then the requested mass flow
rate is supplied. If <code>dp &lt; dp_min</code> then
<code>m_flow = Kv/sqrt(dp)</code>. Transition between
these two flow regimes happens in a smooth way.
</p>
<h4>Typical use and important parameters</h4>
<p>
This model is configured by setting <code>m_flow_nominal</code>
to the mass flow rate that the valve should supply when it is
completely open, i.e., <code>y = 1</code>. The pressure drop corresponding
to this working point can be set using <code>dpValve_nominal</code>,
or using a <code>Kv</code>, <code>Cv</code> or <code>Av</code>
value. The parameter <code>dpValve_fixed</code> can be used to add
additional pressure drops, although in this valve it is equivalent to
add these to <code>dpValve_nominal</code>.
</p>
<p>
The parameter <code>l2</code> represents the non-ideal
leakage behaviour of this valve for high pressures.
It is assumed that the mass flow rate will rise beyond
the requested mass flow rate <code>y*m_flow_nominal</code>
if <code>dp &gt; dpValve_nominal+dpFixed_nominal</code>.
The parameter <code>l2</code> can be used to control
the control the magnitude of this leakage.
In the ideal case <code>l2=0</code>, but
this may introduce singularities, for instance when
connecting this component with a fixed mass flow source.
</p>
<h4>Options</h4>
<p>
Parameter <code>deltax</code> sets the duration of
the transition region between the two flow regimes
as a fraction of <code>dp_nominal</code> or <code>m_flow_nominal</code>,
depending on the value of <code>from_dp</code>.
</p>
<h4>Implementation</h4>
<p>
Note that the result in the transition region when
using <code>from_dp = true</code> is not identical to
the result when using <code>from_dp = false</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 7, 2016, by Filip Jorissen:<br/>
Changed implementation such that <code>dp(m_flow)</code> is strictly
increasing and has a continuous derivative.
Removed parameter <code>deltax</code>.
</li>
<li>
January 29, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayPressureIndependent;
