within IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem;
model PVElectrical1DiodeMPP "Analytical 5-p model for PV I-V 
  characteristics with temp. dependency based on 5 parameters with automatic MPP control"
  extends
    IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVElectrical1Diode;

  // Main parameters under standard conditions

  Modelica.Units.SI.ElectricCurrent I_ph0
    "Photo current under standard conditions";
  Modelica.Units.SI.ElectricCurrent I_s0
    "Saturation current under standard conditions";
  Modelica.Units.SI.Resistance R_s0
    "Series resistance under standard conditions";
  Modelica.Units.SI.Resistance R_sh0
    "Shunt resistance under standard conditions";
 Real a_0(unit = "V")
    "Modified diode ideality factor under standard conditions";
 Real w_0(final unit = "1")
    "MPP auxiliary correlation coefficient under standard conditions";

// Additional parameters and constants

 constant Real e=Modelica.Math.exp(1.0)
   "Euler's constant";
 constant Real pi=Modelica.Constants.pi
   "Pi";
 constant Real k(final unit="J/K") = 1.3806503e-23
   "Boltzmann's constant";
 constant Real q( unit = "A.s")= 1.602176620924561e-19
   "Electron charge";
 parameter Modelica.Units.SI.Energy E_g0=1.79604e-19
    "Band gap energy under standard conditions for Si";
 parameter Real C=0.0002677
    "Band gap temperature coefficient for Si";

  Modelica.Units.SI.ElectricCurrent I_mp(start=0.5*I_mp0) "MPP current";

  Modelica.Units.SI.Voltage V_mp "MPP voltage";

  Modelica.Units.SI.Energy E_g "Band gap energy";

  Modelica.Units.SI.ElectricCurrent I_s "Saturation current";

  Modelica.Units.SI.ElectricCurrent I_ph "Photo current";

  Modelica.Units.SI.Resistance R_s "Series resistance";

  Modelica.Units.SI.Resistance R_sh "Shunt resistance";

  Real a(final unit = "V", start = 1.3)
    "Modified diode ideality factor";

  Modelica.Units.SI.Power P_mod "Output power of one PV module";

  Real w(final unit = "1", start = 0)
   "MPP auxiliary correlation coefficient";

  Modelica.Units.SI.Voltage V_oc
    "Open circuit voltage under operating conditions";

equation

  // Analytical parameter extraction equations under standard conditions (Batzelis et al., 2016)

 a_0 = V_oc0*(1-TCel0*beta_Voc)/(50.1-TCel0*alpha_Isc);

  w_0 =
    IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.lambertWSimple(
    exp(1/(a_0/V_oc0) + 1));

 R_s0 = (a_0*(w_0-1)-V_mp0)/I_mp0;

 R_sh0 = a_0*(w_0-1)/(I_sc0*(1-1/w_0)-I_mp0);

 I_ph0 = (1+R_s0/R_sh0)*I_sc0;

 I_s0 = I_ph0*exp(-1/(a_0/V_oc0));

// Parameter extrapolation equations to operating conditions (DeSoto et al.,2006)

 a/a_0 = TCel/TCel0;

 I_s/I_s0 = (TCel/TCel0)^3*exp(1/k*(E_g0/TCel0-E_g/TCel));

 E_g/E_g0 = 1-C*(TCel-TCel0);

 R_s = R_s0;

 I_ph = if absRadRat > 0 then absRadRat*(I_ph0+TCoeff_Isc*(TCel-TCel0))
 else
  0;

 R_sh/R_sh0 = if noEvent(absRadRat > Modelica.Constants.eps) then 1/absRadRat
 else
  0;

//Simplified Power correlations at MPP using lambert W function (Batzelis et al., 2016)

 I_mp = if noEvent(absRadRat <= Modelica.Constants.eps or w<=Modelica.Constants.eps) then 0
 else
 I_ph*(1-1/w)-a*(w-1)/R_sh;

 V_mp = if absRadRat <= 0 then 0
 else
 a*(w-1)-R_s*I_mp;

 V_oc = if I_ph >= Modelica.Constants.eps*10  then
 a*log(abs((I_ph/I_s+1)))
 else
 0;

  w = if noEvent(V_oc >= Modelica.Constants.eps) then
    IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.lambertWSimple(
    exp(1/(a/V_oc) + 1)) else 0;

//I-V curve equation - use if P at a given V is needed (e.g. battery loading scenarios without MPP tracker)
//I = I_ph - I_s*(exp((V+I*R_s)/(a))-1) - (V + I*R_s)/(R_sh);

// Efficiency and Performance

 eta= if noEvent(radTil <= Modelica.Constants.eps*10) then 0
 else
 P_mod/(radTil*A_pan);

 P_mod = V_mp*I_mp;

 P=max(0, min(P_Max*n_mod, P_mod*n_mod));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html><h4>
  <span style=\"color: #008000\">Overview</span>
</h4>
<p>
  <br/>
  Analytical 5-p model for determining the I-V characteristics of a PV
  array (Batzelis et al.,2016) with temp. dependency of the 5
  parameters after (DeSoto et al.,2006). The final output of this model
  is the DC performance of the PV array.
</p>
<p>
  <br/>
  Validated with experimental data from NIST (Boyd, 2017).
</p>
<p>
  Module calibration is based on manufactory data.
</p>
<p>
  <br/>
</p>
<h4>
  <span style=\"color: #008000\">References</span>
</h4>
<p>
  A Method for the analytical extraction of the Single-Diode PV model
  parameters. by Batzelis, Efstratios I. ; Papathanassiou, Stavros A.
</p>
<p>
  Improvement and validation of a model for photovoltaic array
  performance. by De Soto, W. ; Klein, S. A. ; Beckman, W. A.
</p>
<p>
  Performance Data from the NIST Photovoltaic Arrays and Weather
  Station. by Boyd, M.:
</p>

</html>",revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVElectrical1DiodeMPP;
