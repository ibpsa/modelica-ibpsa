within IBPSA.Airflow.Multizone;
model DoorOperable
  "Door model for bi-directional air flow between rooms that can be open or closed"
  extends IBPSA.Airflow.Multizone.BaseClasses.Door(
    A = (1-y)*AClo + y*AOpe);

   parameter Modelica.SIunits.PressureDifference dpCloRat(min=0,
                                                          displayUnit="Pa") = 4
    "Pressure drop at rating condition of closed door"
      annotation (Dialog(group="Rating conditions"));

  parameter Real CDCloRat(min=0, max=1)=1
    "Discharge coefficient at rating conditions of closed door"
      annotation (Dialog(group="Rating conditions"));

  parameter Modelica.SIunits.Area LClo(min=0)
    "Effective leakage area of closed door"
      annotation (Dialog(group="Closed door"));

  parameter Real CDOpe=0.65 "Discharge coefficient of open door"
    annotation (Dialog(group="Open door"));
  parameter Real CDClo=0.65 "Discharge coefficient of closed door"
    annotation (Dialog(group="Closed door"));

  parameter Real mOpe = 0.5 "Flow exponent for door of open door"
    annotation (Dialog(group="Open door"));
  parameter Real mClo= 0.65 "Flow exponent for crack of closed door"
    annotation (Dialog(group="Closed door"));

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1, unit="1")
    "Opening signal, 0=closed, 1=open"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}), iconTransformation(extent={{-120,-10},{-100,10}})));

protected
  parameter Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  parameter Real[2] a = {gamma, gamma}
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b[2] = {1/8*m^2 - 3*gamma - 3/2*m + 35.0/8 for m in {mOpe, mClo}}
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real c[2] = {-1/4*m^2 + 3*gamma + 5/2*m - 21.0/4 for m in {mOpe, mClo}}
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real d[2] = {1/8*m^2 - gamma - m + 15.0/8 for m in {mOpe, mClo}}
    "Polynomial coefficient for regularized implementation of flow resistance";

  parameter Real kVal[2]={
   CDOpe*AOpe*sqrt(2/rho_default),
   CDClo*AClo*sqrt(2/rho_default)}
   "Flow coefficient, k = V_flow/ dp^m";
  parameter Real kTOpe = CDOpe*wOpe*sqrt(2/rho_default)
    *(Modelica.Constants.g_n*rho_default*hOpe/2/Medium.T_default)^mOpe *hOpe/2
    / conTP^mOpe
    "Constant coefficient for buoyancy driven air flow rate";
  parameter Real conTP = IBPSA.Media.Air.dStp*Modelica.Media.IdealGases.Common.SingleGasesData.Air.R
    "Conversion factor for converting temperature difference to pressure difference";

  Modelica.SIunits.VolumeFlowRate VABpOpeClo_flow(nominal=0.001)
    "Volume flow rate from A to B if positive due to static pressure difference";
  Modelica.SIunits.VolumeFlowRate VABp_flow(nominal=0.001)
    "Volume flow rate from A to B if positive due to static pressure difference";
  Modelica.SIunits.VolumeFlowRate VABt_flow(nominal=0.001)
    "Volume flow rate from A to B if positive due to buoyancy";

 parameter Modelica.SIunits.Area AClo = CDClo/CDCloRat * LClo * dpCloRat^(0.5-mClo) "Closed aperture area";

equation
  // Air flow rate due to static pressure difference
  VABpOpeClo_flow = IBPSA.Airflow.Multizone.BaseClasses.powerLawFixedM(
      k=kVal,
      dp=port_a1.p-port_a2.p,
      m={mOpe, mClo},
      a=a,
      b=b,
      c=c,
      d=d,
      dp_turbulent=dp_turbulent);
  VABp_flow = y*VABpOpeClo_flow[1] + (1-y)*VABpOpeClo_flow[2];
  // Air flow rate due to buoyancy
  // Because powerLawFixedM requires as an input a pressure difference pa-pb,
  // we convert Ta-Tb by multiplying it with rho*R, and we divide
  // above the constant expression by (rho*R)^m on the right hand-side of kT.
  VABt_flow = y*IBPSA.Airflow.Multizone.BaseClasses.powerLawFixedM(
      k=kT,
      dp=conTP*(Medium.temperature(state_a1_inflow)-Medium.temperature(state_a2_inflow)),
      m=mOpe,
      a=a[1],
      b=b[1],
      c=c[1],
      d=d[1],
      dp_turbulent=dp_turbulent);

  // Net flow rate
  port_a1.m_flow = rho_default * (+VABp_flow/2 + VABt_flow);
  port_b2.m_flow = rho_default * (+VABp_flow/2 - VABt_flow);

  annotation (defaultComponentName="doo",
Documentation(info="<html>
<p>
Model for bi-directional air flow through a large opening such as a door which can be opened or closed
based on the control input signal <i>y</i>.
</p>
<p>
For the control input signal <i>y=1</i>, this model is identical to
<a href=\"modelica://IBPSA.Airflow.Multizone.DoorOpen\">
IBPSA.Airflow.Multizone.DoorOpen</a>, and for
<i>y=0</i>, the door is assumed to be closed and the air flow rate is
set to the air flow rate through the crack posed by the open door, <i>V&#775;<sub>clo</sub></i>.
<p>
<p>
The air flow rate for the closed door is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
    V&#775;<sub>clo</sub> = k<sub>clo</sub> &Delta;p<sup>mClo</sup>,
</p>
<p>
where
<i>V&#775;<sub>clo</sub></i> is the volume flow rate,
<i>k<sub>clo</sub></i> is a flow coefficient and
<i>mClo</i> is the flow exponent.
The flow coefficient is
</p>
<p align=\"center\" style=\"font-style:italic;\">
k<sub>clo</sub> = L<sub>clo</sub> C<sub>DCloRat</sub> &Delta;p<sub>Rat</sub><sup>(0.5-mClo</sup>) (2/&rho;<sub>0</sub>)<sup>0.5</sup>,
</p>
<p>
where
<i>L<sub>clo</sub></i> is the effective air leakage area,
<i>C<sub>DCloRat</sub></i> is the discharge coefficient at the reference condition,
<i>&Delta;p<sub>Rat</sub></i> is the pressure drop at the rating condition, and
<i>&rho;<sub>0</sub></i> is the mass density at the medium default pressure, temperature and humidity.
</p>
<p>
For the open door, the air flow rate
<i>V&#775;<sub>ope</sub></i> is computed as described in
<a href=\"modelica://IBPSA.Airflow.Multizone.DoorOpen\">
IBPSA.Airflow.Multizone.DoorOpen</a>
with the parameters <code>CDOpe</code> and <code>mOpe</code>.
</p>
<p>
The actual air flow rate is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
V&#775;<sub>clo</sub> = (y-1) V&#775;<sub>clo</sub> + y V&#775;<sub>ope</sub>,
</p>
<p>
where <i>y &isin; [0, 1]</i> is the control signal.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 6, 2020, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1353\">#1353</a>.
</li>
</ul>
</html>"));
end DoorOperable;
