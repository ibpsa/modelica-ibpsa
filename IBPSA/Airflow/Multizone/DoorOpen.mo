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
<p>Model for bi-directional air flow through a large opening such as a door. </p>
<p>The air flow is composed of two components, a one-directional bulk air flow due to static pressure difference in the adjoining two thermal zones, and a two-directional airflow due to temperature-induced differences in density of the air in the two thermal zones. Although turbulent air flow is a nonlinear phenomenon, the model is based on the simplifying assumption that these two air flow rates can be superposed. (Superposition is only exact for laminar flow.) This assumption is made because it leads to a simple model and because there is significant uncertainty and assumptions anyway in such simplified a model for bidirectional flow through a door. </p>
<p><b>Main equations</b></p>
<p>The air flow rate due to static pressure difference is </p>
<p align=\"center\"><i>V̇<sub>ab,p</sub> = C<sub>D</sub> w h (2/&rho;<sub>0</sub>)<sup>0.5</sup> &Delta;p<sup>m</sup>, </i></p>
<p>where <i>V̇</i> is the volumetric air flow rate, <i>C<sub>D</i></sub> is the discharge coefficient, <i>w</i> and <i>h</i> are the width and height of the opening <i>&rho;<sub>0</i></sub> is the mass density at the medium default pressure, temperature and humidity, <i>m</i> is the flow exponent and <i>&Delta;p = p<sub>a</sub> - p<sub>b</i></sub> is the static pressure difference between the thermal zones. For this model explanation, we will assume <i>p<sub>a</sub> &gt; p<sub>b</i></sub>. For turbulent flow, <i>m=1/2</i> and for laminar flow <i>m=1</i>. </p>
<p>The air flow rate due to temperature difference in the thermal zones is <i>V̇<sub>ab,t</i></sub> for flow from thermal zone <i>a</i> to <i>b</i>, and <i>V̇<sub>ba,t</i></sub> for air flow rate from thermal zone <i>b</i> to <i>a</i>. The model has two air flow paths to allow bi-directional air flow. The mass flow rates at these two air flow paths are </p>
<p align=\"center\"><i>ṁ<sub>a1</sub> = &rho;<sub>0</sub> &nbsp; (+V̇<sub>ab,p</sub>/2 + &nbsp; V̇<sub>ab,t</sub>), </i></p>
<p>and, similarly, </p>
<p align=\"center\"><i>V̇<sub>ba</sub> = &rho;<sub>0</sub> &nbsp; (-V̇<sub>ab,p</sub>/2 + &nbsp; V̇<sub>ba,t</sub>), </i></p>
<p>where we simplified the calculation by using the density <i>&rho;<sub>0</i></sub>. To calculate <i>V̇<sub>ba,t</i></sub>, we again use the density <i>&rho;<sub>0</i></sub> and because of this simplification, we can write </p>
<p align=\"center\"><i>ṁ<sub>ab,t</sub> = -ṁ<sub>ba,t</sub> = &rho;<sub>0</sub> &nbsp; V̇<sub>ab,t</sub> = -&rho;<sub>0</sub> &nbsp; V̇<sub>ba,t</sub>, </i></p>
<p>from which follows that the neutral height, e.g., the height where the air flow rate due to flow induced by temperature difference is zero, is at <i>h/2</i>. Hence, </p>
<p align=\"center\"><i>V̇<sub>ab,t</sub> = &int;<sub>0</sub><sup>h/2</sup> (&part; &frasl; &part; z) V̇ab,t(z) &nbsp; dz, </i>></p>
<p>and with </p>
<p align=\"center\"><i>V̇<sub>ab,t</sub> (z)= C<sub>D</sub> w h (2/&rho;<sub>0</sub>)<sup>0.5</sup> &Delta;p<sub>ab,t</sub><sup>m</sup>(z) </i> </p>
<p>and </p>
<p align=\"center\"><i>&Delta;p<sub>ab,t</sub>(z) = g z (&rho;a-&rho;b) &asymp; g z &rho;0 (Tb - Ta) &frasl; T0, </i></p>
<p>where we used <i>&rho;<sub>a</sub> = p<sub>0</sub> /(R T<sub>a</sub>)</i> and <i>T<sub>a</sub> T<sub>b</sub> &asymp; T<sub>0<sup>2, </i></sup>. Substituting this expression into the integral yields </p>
<p align=\"center\"><i>V̇<sub>ab,t</sub> (z)= C<sub>D</sub> w h (2/&rho;<sub>0</sub>)<sup>0.5</sup> g<sup>m</sup> &rho;0<sup>m</sup> z<sup>m</sup> (Tb-Ta)<sup>m</sup> &frasl; T0<sup>m</sup>. </i></p>
<p>Assuming one airflow paths to represent the top half of the opening and one airflow path to represent the bottom half, with the flow path placed at a height of 2H/9 and -2H/9 from the centerline respectively.</p>
<p align=\"center\"><i>V̇<sub>ab,t</sub> = C<sub>D</sub> w h/2 (2/&rho;<sub>0</sub>)<sup>0.5</sup> g<sup>m</sup> &rho;0<sup>m</sup> 2h/9 <sup>m</sup> (Tb-Ta)<sup>m</sup> &frasl; T0<sup>m</sup>. </i></p>
<p><br><b>Main assumptions</b> </p>
<p>The main assumptions are as follows: </p>
<ul>
<li>The air flow rates due to static pressure difference and due to temperature-difference can be superposed. </li>
<li>For computing the neutral height, we assume <i>ṁ<sub>ab,t</sub> = &rho;<sub>0</sub> &nbsp; V̇<sub>ab,t</i></sub>. </li>
<li>For buoyancy-driven air flow, the air density can be approximated as <i>&rho; = p<sub>0</sub> /(R T<sub>0</sub>)</i>, </li>
</ul>
<p><b>Notes</b></p>
<p>For a more detailed model, use <a href=\"modelica://IBPSA.Airflow.Multizone.DoorDiscretizedOpen\">IBPSA.Airflow.Multizone.DoorDiscretizedOpen</a>. </p>
<h4>References</h4>
<ul>
<li>
<li>

<b>W. S. Dols and B. J. Polidoro</b>,  <i> CONTAM User Guide and Program Documentation Version 3.4</i>, National Institute of Standards and Technology, Aug. 2020. doi: 10.6028/NIST.TN.1887r1.


</li>
</ul></html>",
revisions="<html>
<ul>
<li>
January 19, 2020, by Klaas De Jonge:<br/>
Revised influence of stack effect.
</li>
<li>
October 6, 2020, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1353\">#1353</a>.
</li>
</ul>
</html>"));
end DoorOpen;
