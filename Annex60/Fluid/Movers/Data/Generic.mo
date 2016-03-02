within Annex60.Fluid.Movers.Data;
record Generic "Generic data record for movers"
  extends Modelica.Icons.Record;

  parameter
    Annex60.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    hydraulicEfficiency(
      V_flow={0},
      eta={0.7}) "Hydraulic efficiency (used if use_powerCharacteristic=false)";
  parameter
    Annex60.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    motorEfficiency(
      V_flow={0},
      eta={0.7})
    "Electric motor efficiency (used if use_powerCharacteristic=false)";
  parameter Annex60.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure(
    V_flow={0.5,1},
    dp={1,0}) "Volume flow rate vs. total pressure rise"
    annotation(Evaluate=true);
  // Power requires default values to avoid in Dymola the message
  // Failed to expand the variable Power.V_flow
  parameter BaseClasses.Characteristics.powerParameters power(
    V_flow={0},
    P={0})
    "Volume flow rate vs. electrical power consumption (used if use_powerCharacteristic=true)"
   annotation (Dialog(enable=use_powerCharacteristic));

  parameter Boolean motorCooledByFluid=true
    "If true, then motor heat is added to fluid stream";

  parameter Real speed_nominal(final min=0, final unit="1") = 1
    "Nominal rotational speed for flow characteristic";

  parameter Real constantSpeed(final min=0, final unit="1") = constantSpeed_rpm/speed_rpm_nominal
    "Normalized speed set point when using inputType = Annex60.Fluid.Types.InputType.Constant";

  parameter Real[:] speeds(each final min = 0, each final unit="1") = speeds_rpm       /speed_rpm_nominal
    "Vector of normalized speed set points when using inputType = Annex60.Fluid.Types.InputType.Stages";

  parameter Boolean use_powerCharacteristic=false
    "Use power data instead of motor efficiency";

  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm speed_rpm_nominal=1500
    "Nominal rotational speed for flow characteristic";

  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm constantSpeed_rpm=
    speed_rpm_nominal
    "Speed set point when using inputType = Annex60.Fluid.Types.InputType.Constant";

  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm[:] speeds_rpm = {speed_rpm_nominal}
    "Vector of speed set points when using inputType = Annex60.Fluid.Types.InputType.Stages";

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(revisions="<html>
<ul>
<li>
February 19, 2016, by Filip Jorissen:<br/>
Refactored model such that <code>SpeedControlled_Nrpm</code>, 
<code>SpeedControlled_y</code> and <code>FlowControlled</code> 
are integrated into one record.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/417\">#417</a>.
</li>
<li>
February 17, 2016, by Michael Wetter:<br/>
Changed parameter <code>N_nominal</code> to
<code>speed_rpm_nominal</code> as it is the same quantity as <code>speeds_rmp</code>.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/396\">#396</a>.
</li>
<li>
January 19, 2016, by Filip Jorissen:<br/>
Added parameter <code>speeds_rpm</code>.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/396\">#396</a>.
</li>
<li>
February 13, 2015, by Michael Wetter:<br/>
Updated documentation.
</li>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised record for OpenModelica.
</li>
<li>
November 22, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Record containing parameters for pumps or fans.
</p>
<p>
This record may be used to assign for example fan performance data using
declaration such as
</p>
<pre>
  Annex60.Fluid.Movers.SpeedControlled_y fan(
    redeclare package Medium = Medium,
      per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
                   dp={2*dp_nominal,dp_nominal,0}))) \"Fan\";
</pre>
<p>
This data record can be used with
<a href=\"modelica://Annex60.Fluid.Movers.SpeedControlled_Nrpm\">
Annex60.Fluid.Movers.SpeedControlled_Nrpm</a>,
<a href=\"modelica://Annex60.Fluid.Movers.SpeedControlled_y\">
Annex60.Fluid.Movers.SpeedControlled_y</a>,
<a href=\"modelica://Annex60.Fluid.Movers.FlowControlled_dp\">
Annex60.Fluid.Movers.FlowControlled_dp</a>,
<a href=\"modelica://Annex60.Fluid.Movers.FlowControlled_m_flow\">
Annex60.Fluid.Movers.FlowControlled_m_flow</a>.
</p>
<p>
An example that uses manufacturer data can be found in
<a href=\"modelica://Annex60.Fluid.Movers.Validation.Pump_Nrpm_stratos\">
Annex60.Fluid.Movers.Validation.Pump_Nrpm_stratos</a>.
</p>
</html>"));
end Generic;
