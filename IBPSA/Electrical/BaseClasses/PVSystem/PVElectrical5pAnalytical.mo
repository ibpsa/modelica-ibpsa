within IBPSA.Electrical.BaseClasses.PVSystem;
model PVElectrical5pAnalytical "Analytical 5-p model for PV I-V 
  characteristics with temp. dependency based on 5 parameters"
  extends IBPSA.Electrical.BaseClasses.PVSystem.BaseClasses.PartialPVElectrical;


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

 a_0 = V_oc0*(1-T_c0*beta_Voc)/(50.1-T_c0*alpha_Isc);

 w_0 = IBPSA.Electrical.BaseClasses.PVSystem.BaseClasses.LambertWSimple(exp(1/(a_0/V_oc0)+1));

 R_s0 = (a_0*(w_0-1)-V_mp0)/I_mp0;

 R_sh0 = a_0*(w_0-1)/(I_sc0*(1-1/w_0)-I_mp0);

 I_ph0 = (1+R_s0/R_sh0)*I_sc0;

 I_s0 = I_ph0*exp(-1/(a_0/V_oc0));

// Parameter extrapolation equations to operating conditions (DeSoto et al.,2006)

 a/a_0 = T_c/T_c0;

 I_s/I_s0 = (T_c/T_c0)^3*exp(1/k*(E_g0/T_c0-E_g/T_c));

 E_g/E_g0 = 1-C*(T_c-T_c0);

 R_s = R_s0;

 I_ph = if absRadRat > 0 then absRadRat*(I_ph0+TCoeff_Isc*(T_c-T_c0))
 else
  0;

 R_sh/R_sh0 = if noEvent(absRadRat > 0.001) then 1/absRadRat
 else
  0;

//Simplified Power correlations at MPP using lambert W function (Batzelis et al., 2016)

 I_mp = if noEvent(absRadRat <= 0.0011 or w<=0.001) then 0
 else
 I_ph*(1-1/w)-a*(w-1)/R_sh;

 V_mp = if absRadRat <= 0 then 0
 else
 a*(w-1)-R_s*I_mp;

 V_oc = if I_ph >= 0.01  then
 a*log(abs((I_ph/I_s+1)))
 else
 0;

 w = if noEvent(V_oc >= 0.001) then
 IBPSA.Electrical.BaseClasses.PVSystem.BaseClasses.LambertWSimple(exp(1/(a/V_oc)+1))
 else
 0;

//I-V curve equation - use if P at a given V is needed (e.g. battery loading scenarios without MPP tracker)
//I = I_ph - I_s*(exp((V+I*R_s)/(a))-1) - (V + I*R_s)/(R_sh);

// Efficiency and Performance

 eta= if noEvent(radTil <= 0.01) then 0
 else
 P_mod/(radTil*A_pan);

 P_mod = V_mp*I_mp;

 DCOutputPower=max(0, min(P_Max*n_mod, P_mod*n_mod));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PVElectrical5pAnalytical;
