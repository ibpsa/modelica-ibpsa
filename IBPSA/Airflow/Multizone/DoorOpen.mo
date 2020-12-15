within IBPSA.Airflow.Multizone;
model DoorOpen
  "Door model for bi-directional air flow between rooms"
  extends IBPSA.Airflow.Multizone.BaseClasses.Door(
    final vAB = VAB_flow/AOpe,
    final vBA = VBA_flow/AOpe);

  parameter Real CD=0.65 "Discharge coefficient"
    annotation (Dialog(group="Orifice characteristics"));

  parameter Real m = 0.5 "Flow coefficient"
    annotation (Dialog(group="Orifice characteristics"));

protected
  parameter Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  parameter Real a = gamma
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b = 1/8*m^2 - 3*gamma - 3/2*m + 35.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real c = -1/4*m^2 + 3*gamma + 5/2*m - 21.0/4
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real d = 1/8*m^2 - gamma - m + 15.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";

  parameter Real kVal=CD*AOpe*sqrt(2/rho_default) "Flow coefficient, k = V_flow/ dp^m";
  parameter Real kT = CD*wOpe*hOpe/2*sqrt(2/rho_default)
    *(Modelica.Constants.g_n*rho_default*(2*hOpe/9)/Medium.T_default)^m
    / conTP^m
    "Constant coefficient for buoyancy driven air flow rate";
  parameter Real conTP = IBPSA.Media.Air.dStp*Modelica.Media.IdealGases.Common.SingleGasesData.Air.R
    "Conversion factor for converting temperature difference to pressure difference";

  Modelica.SIunits.VolumeFlowRate VABp_flow(nominal=0.001)
    "Volume flow rate from A to B if positive due to static pressure difference";
  Modelica.SIunits.VolumeFlowRate VABt_flow(nominal=0.001)
    "Volume flow rate from A to B if positive due to buoyancy";

equation
  // Air flow rate due to static pressure difference
  VABp_flow = IBPSA.Airflow.Multizone.BaseClasses.powerLawFixedM(
      k=kVal,
      dp=port_a1.p-port_a2.p,
      m=m,
      a=a,
      b=b,
      c=c,
      d=d,
      dp_turbulent=dp_turbulent);
  // Air flow rate due to buoyancy
  // Because powerLawFixedM requires as an input a pressure difference pa-pb,
  // we convert Ta-Tb by multiplying it with rho*R, and we divide
  // above the constant expression by (rho*R)^m on the right hand-side of kT.
  VABt_flow = IBPSA.Airflow.Multizone.BaseClasses.powerLawFixedM(
      k=kT,
      dp=conTP*(Medium.temperature(state_a1_inflow)-Medium.temperature(state_a2_inflow)),
      m=m,
      a=a,
      b=b,
      c=c,
      d=d,
      dp_turbulent=dp_turbulent);

  // Net flow rate
  port_a1.m_flow = rho_default * (+VABp_flow/2 + VABt_flow);
  port_b2.m_flow = rho_default * (+VABp_flow/2 - VABt_flow);

  annotation (defaultComponentName="doo",
Documentation(info="<html>
<p>
Model for bi-directional air flow through a large opening such as a door.
</p>
<p>
The air flow is composed of two components, a one-directional bulk air flow
due to static pressure difference in the adjoining two thermal zones, and
a two-directional airflow due to temperature-induced differences in density
of the air in the two thermal zones.
Although turbulent air flow is a nonlinear phenomenon,
the model is based on the simplifying assumption that these two
air flow rates can be superposed.
(Superposition is only exact for laminar flow.)
This assumption is made because
it leads to a simple model and because there is significant uncertainty
and assumptions anyway in such simplified a model for bidirectional flow through a door.
</p>
<h4>Main equations</h4>
<p>
The air flow rate due to static pressure difference is
</p>
<p align=\"center\" style=\"font-style:italic;\">
    V&#775;<sub>ab,p</sub> =  C<sub>D</sub> w h (2/&rho;<sub>0</sub>)<sup>0.5</sup>  &Delta;p<sup>m</sup>,
</p>
<p>
where
<i>V&#775;</i> is the volumetric air flow rate,
<i>C<sub>D</sub></i> is the discharge coefficient,
<i>w</i> and <i>h</i> are the width and height of the opening
<i>&rho;<sub>0</sub></i> is the mass density at the medium default pressure, temperature and humidity,
<i>m</i> is the flow exponent and
<i>&Delta;p = p<sub>a</sub> - p<sub>b</sub></i> is the static pressure difference between
the thermal zones.
For this model explanation, we will assume <i>p<sub>a</sub> &gt; p<sub>b</sub></i>.
For turbulent flow, <i>m=1/2</i> and for laminar flow <i>m=1</i>.
</p>
<p>
The air flow rate due to temperature difference in the thermal zones is
<i>V&#775;<sub>ab,t</sub></i> for flow from thermal zone <i>a</i> to <i>b</i>,
and
<i>V&#775;<sub>ba,t</sub></i> for air flow rate from thermal zone <i>b</i> to <i>a</i>.
The model has two air flow paths to allow bi-directional air flow.
The mass flow rates at these two air flow paths are
</p>
<p align=\"center\" style=\"font-style:italic;\">
    m&#775;<sub>a1</sub> = &rho;<sub>0</sub> &nbsp; (+V&#775;<sub>ab,p</sub>/2 + &nbsp; V&#775;<sub>ab,t</sub>),
</p>
<p>
and, similarly,
</p>
<p align=\"center\" style=\"font-style:italic;\">
    V&#775;<sub>ba</sub> = &rho;<sub>0</sub> &nbsp; (-V&#775;<sub>ab,p</sub>/2 + &nbsp; V&#775;<sub>ba,t</sub>),
</p>
<p>
where we simplified the calculation by using the density <i>&rho;<sub>0</sub></i>.
To calculate <i>V&#775;<sub>ba,t</sub></i>, we again use the density <i>&rho;<sub>0</sub></i>
and because of this simplification, we can write
</p>
<p align=\"center\" style=\"font-style:italic;\">
    m&#775;<sub>ab,t</sub> =  -m&#775;<sub>ba,t</sub> = &rho;<sub>0</sub> &nbsp; V&#775;<sub>ab,t</sub>
  =  -&rho;<sub>0</sub> &nbsp; V&#775;<sub>ba,t</sub>,
</p>
<p>
from which follows that the neutral height, e.g., the height where the air flow rate due to flow
induced by temperature difference is zero, is at <i>h/2</i>.
Hence,
</p>
<p align=\"center\" style=\"font-style:italic;\">
    V&#775;<sub>ab,t</sub> =  &int;<sub>0</sub><sup>h/2</sup> (&part; &frasl; &part; z) V&#775;<sub>ab,t</sub>(z) &nbsp; dz,
</p>
<p>
and with
</p>
<p align=\"center\" style=\"font-style:italic;\">
    V&#775;<sub>ab,t</sub> =  C<sub>D</sub> w h (2/&rho;<sub>0</sub>)<sup>0.5</sup>  &Delta;p<sub>ab,t</sub><sup>m</sup>(z),
</p>
and
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p<sub>ab,t</sub><sup>m</sup>(z) = g z (&rho;<sub>a</sub>-&rho;<sub>b</sub>)
  &asymp; g z &rho;<sub>0</sub> (T<sub>b</sub> - T<sub>a</sub>) &frasl; T<sub>0</sub>,
</p>
<p>
where we used
<i>&rho;<sub>a</sub> = p<sub>0</sub> /(R T<sub>a</sub>)</i> and
<i>T<sub>a</sub> T<sub>b</sub> &asymp; T<sub>0</sub><sup>2</sup></i>.
Substituting this expression into the integral yields
</p>
<p align=\"center\" style=\"font-style:italic;\">
    V&#775;<sub>ab,t</sub> =  C<sub>D</sub> w (2/&rho;<sub>0</sub>)<sup>0.5</sup> g<sup>m</sup> &rho;<sub>0</sub><sup>m</sup>
      (h/2)<sup>m+1</sup> (T<sub>b</sub>-T<sub>a</sub>)<sup>m</sup> &frasl; T<sub>0</sub><sup>m</sup>.
</p>
<h4>Main assumptions</h4>
<p>
The main assumptions are as follows:
</p>
<ul>
<li>
<p>
The air flow rates due to static pressure difference and due to temperature-difference can be superposed.
</p>
</li>
<li>
<p>
For computing the neutral height, we assume <i>m&#775;<sub>ab,t</sub> =  &rho;<sub>0</sub> &nbsp; V&#775;<sub>ab,t</sub></i>.
</p>
</li>
<li>
<p>
For buoyancy-driven air flow, the air density can be approximated as <i>&rho; = p<sub>0</sub> /(R T<sub>0</sub>)</i>,
</p>
</li>
</ul>
<h4>Notes</h4>
<p>
For a more detailed model, use
<a href=\"modelica://IBPSA.Airflow.Multizone.DoorDiscretizedOpen\">
IBPSA.Airflow.Multizone.DoorDiscretizedOpen</a>.
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
end DoorOpen;
