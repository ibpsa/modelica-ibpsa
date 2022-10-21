within IBPSA.Electrical.DC.Sources.BaseClasses;
package PVSystem
  partial model PartialPVSystem "Base PV model with internal or external MPP tracking"

    extends
      IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.Icons.partialPVIcon;

    replaceable parameter IBPSA.Electrical.DataBase.PVBaseDataDefinition data
     constrainedby IBPSA.Electrical.DataBase.PVBaseDataDefinition
     "PV Panel data definition" annotation(choicesAllMatching=true);

    parameter Boolean use_MPP_in = false
     "If true then MPP via real interface else internal automatic MPP tracking"
     annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

    parameter Boolean use_Til_in = false
    "If true then tilt via real interface else parameter"
    annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

    parameter Modelica.Units.SI.Angle til if not use_Til_in
    "Prescribed tilt angle (used if til=Parameter)" annotation(Dialog(enable=not use_Til_in, tab="Module mounting and specifications"));

    parameter Boolean use_Azi_in = false
    "If true then azimuth angle is controlled via real interface else parameter"
    annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

    parameter Modelica.Units.SI.Angle azi if not use_Azi_in
    "Prescribed azimuth angle (used if azi=Parameter)"
    annotation(Dialog(enable=not use_Azi_in, tab="Module mounting and specifications"));

    parameter Boolean use_Sha_in = false
    "If true then shading is real interface else neglected"
    annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

    parameter Boolean use_age_in = false
    "If true then ageing is real interface else parameter"
    annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

    parameter Real ageing if not use_age_in
    "Prescribed ageing factor [0,1] (used if ageig=Parameter)" annotation(Dialog(enable=not use_age_in, tab="Advanced"));

    parameter Boolean use_heat_port = false
    "If true then heat port is enables as interface"
    annotation(Dialog(tab="Advanced"), Evaluate=true, HideResult=true);

    Modelica.Blocks.Interfaces.RealInput HGloHor "Horizontal global irradiation"
      annotation (Placement(transformation(extent={{-110,80},{-88,102}}),
          iconTransformation(extent={{-110,80},{-88,102}})));
    Modelica.Blocks.Interfaces.RealInput TDryBul "Ambient dry bulb temperature"
      annotation (Placement(transformation(extent={{-110,52},{-88,74}}),
          iconTransformation(extent={{-110,52},{-88,74}})));
    Modelica.Blocks.Interfaces.RealInput vWinSpe "Wind speed" annotation (
        Placement(transformation(extent={{-110,26},{-88,48}}), iconTransformation(
            extent={{-110,26},{-88,48}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if use_heat_port
      "Heat port for connection with e.g. building facade or mass"
      annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

    //Conditional connectors
    Modelica.Blocks.Interfaces.RealInput MPPTraSet if use_MPP_in
      "Conditional input for MPP tracking" annotation (Placement(transformation(
            extent={{-110,-2},{-88,20}}), iconTransformation(extent={{-110,-2},{-88,
              20}})));
    Modelica.Blocks.Interfaces.RealInput tilSet if use_Til_in
      "Conditional input for tilt angle control" annotation (Placement(
          transformation(extent={{-110,-24},{-88,-2}}),  iconTransformation(
            extent={{-110,-24},{-88,-2}})));
    Modelica.Blocks.Interfaces.RealInput aziSet if use_Azi_in
      "Conditional input for azimuth angle control" annotation (Placement(
          transformation(extent={{-110,-50},{-88,-28}}), iconTransformation(
            extent={{-110,-50},{-88,-28}})));
    Modelica.Blocks.Interfaces.RealInput shaSet if use_Sha_in
      "Conditional input for shading [0,1]" annotation (Placement(transformation(
            extent={{-110,-76},{-88,-54}}), iconTransformation(extent={{-106,-72},
              {-88,-54}})));

    Modelica.Blocks.Interfaces.RealInput ageSet if use_age_in
      "Conditional input for ageing [0,1]" annotation (Placement(transformation(
            extent={{-110,-104},{-88,-82}}), iconTransformation(extent={{-106,-72},
              {-88,-54}})));

    Modelica.Blocks.Interfaces.RealOutput P "DC Power output"
      annotation (Placement(transformation(extent={{94,-10},{114,10}})));
    replaceable IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVOptical partialPVOptical
    "Model with optical characteristics"
      annotation (Placement(transformation(extent={{-36,64},{-24,76}})));
    replaceable IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVThermal partialPVThermal "Test"
      annotation (choicesAllMatching=true,Dialog(tab="Module mounting and specifications"),Placement(transformation(extent={{-38,4},{-24,16}})));

    replaceable IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVElectrical partialPVElectrical
      annotation (Placement(transformation(extent={{-36,-56},{-24,-44}})));
  protected
    Modelica.Blocks.Interfaces.RealInput MPP_in_internal
    "Needed to connect to conditional MPP tracking connector";

    parameter Real MPP = 1 "Dummy MPP parameter";

    Modelica.Blocks.Interfaces.RealInput Til_in_internal
    "Needed to connect to conditional tilt connector";

    Modelica.Blocks.Interfaces.RealInput Azi_in_internal
    "Needed to connect to conditional azimuth connector";

    Modelica.Blocks.Interfaces.RealInput Sha_in_internal
    "Needed to connect to conditional shading connector";

    Modelica.Blocks.Interfaces.RealInput Age_in_internal
    "Needed to connect to conditional ageing connector";

    parameter Real Sha = 1 "Dummy Shading parameter";

  equation
    connect(MPPTraSet, MPP_in_internal);
    connect(tilSet, Til_in_internal);
    connect(aziSet, Azi_in_internal);
    connect(shaSet, Sha_in_internal);
    connect(ageSet, Age_in_internal);

    if not use_MPP_in then
      MPP_in_internal = MPP;
    end if;

    if not use_Til_in then
      Til_in_internal = til;
    end if;

    if not use_Azi_in then
      Azi_in_internal = azi;
    end if;

    if not use_Sha_in then
      Sha_in_internal = Sha;
    end if;

    if not use_age_in then
      Age_in_internal = ageing;
    end if;

  end PartialPVSystem;

  model PVOpticalHorFixedAziTil
    "PV radiation and absorptance model - input: total irradiance on horizontal
  surface with tilt and azimuth angle as parameters"
    extends
      IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVOptical;

   parameter Real lat(unit="rad", displayUnit="deg")
                          "Latitude"
     annotation(Dialog(group="Location"));

   parameter Real lon(unit="rad", displayUnit="deg")
                          "Longitude"
     annotation(Dialog(group="Location"));

   parameter Real  alt(unit="m")
     "Site altitude in Meters, default= 1"
     annotation(Dialog(group="Location"));

   parameter Real til(unit="rad", displayUnit="deg")
     "Surface tilt. til=90 degree for walls; til=0 for ceilings; til=180 for roof"
     annotation ();

   parameter Real  azi(unit="rad", displayUnit="deg")
     "Module surface azimuth. azi=-90 degree if normal of surface outward unit
   points towards east; azi=0 if it points towards south"
     annotation ();

   parameter Real timZon(unit="s", displayUnit="h")
     "Time zone in seconds relative to GMT"
     annotation(Dialog(group="Location"));

   parameter Real groRef(unit="1")       "Ground reflectance"
     annotation ();

   // Air mass parameters. For mono-SI, use default values
    parameter Real b_0=0.935823 annotation(Dialog(tab="Module specifications"));
    parameter Real b_1=0.054289 annotation(Dialog(tab="Module specifications"));
    parameter Real b_2=-0.008677 annotation(Dialog(tab="Module specifications"));
    parameter Real b_3=0.000527 annotation(Dialog(tab="Module specifications"));
    parameter Real b_4=-0.000011 annotation(Dialog(tab="Module specifications"));

    parameter Real radTil0(unit="W/m2")=1000
                               "Total solar radiation on the horizontal surface 
  under standard conditions"
    annotation(Dialog(group="Location"));

    constant Real G_sc(final quantity="Irradiance",
    final unit = "W/m2") = 1376 "Solar constant";

    parameter Real glaExtCoe(unit="1/m")=4
    "Glazing extinction coefficient for glass";

    parameter Real glaThi(unit="m")=0.002
    "Glazing thickness for most PV cell panels it is 0.002 m";

    parameter Real refInd(unit="1")=1.526
    "Effective index of refraction of the cell cover (glass)";

    parameter Real tau_0(unit="1")=exp(-(glaExtCoe*glaThi))*(1 - ((refInd - 1)/(
      refInd + 1))^2)
        "Transmittance at standard conditions (incAng=refAng=0)";

    Real cloTim(final quantity="Time",
     final unit="s", displayUnit="h")
     "Local clock time";

    Real nDay(final quantity="Time",final unit="s")
      "Day number with units of seconds";

    Real HGloHorBea(final quantity="Irradiance",
     final unit= "W/m2")
     "Beam solar radiation on the horizontal surface";

    Real HGloHorDif(final quantity="Irradiance",
     final unit= "W/m2")
     "Diffuse solar radiation on the horizontal surface";

    Real k_t(final unit="1", start=0.5) "Clearness index";

    Real airMas(final unit="1", min=0) "Air mass";

    Real airMasMod(final unit="1", min=0) "Air mass modifier";

    Modelica.Units.SI.Angle incAngGro "Incidence angle for ground reflection";

    Modelica.Units.SI.Angle incAngDif "Incidence angle for diffuse radiation";

    Real incAngMod(final unit="1", min=0) "Incidence angle modifier";

    Real incAngModGro(final unit="1", min=0) "Incidence angle modifier for 
  ground refelction";

    Real incAngModDif(final unit="1", min=0)
    "Incidence angle modifier for diffuse radiation";

    Modelica.Units.SI.Angle refAng "Angle of refraction";

    Modelica.Units.SI.Angle refAngGro "Angle of refraction for ground reflection";

    Modelica.Units.SI.Angle refAngDif
      "Angle of refraction for diffuse irradiation";

    Real tau(final unit="1", min=0)
    "Transmittance of the cover system";

    Real tau_gro(final unit="1", min=0)
    "Transmittance of the cover system for ground reflection";

    Real tau_diff(final unit="1", min=0)
    "Transmittance of the cover system for diffuse radiation";

    Real R_b(final unit="1", min=0)
     "Ratio of irradiance on tilted surface to horizontal surface";

    Modelica.Units.SI.Angle zen "Zenith angle";

    BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
      annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
    BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle solHouAng
      annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
    BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(timZon=
          timZon, lon=lon)
      annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
    BoundaryConditions.WeatherData.BaseClasses.SolarTime solTim
      annotation (Placement(transformation(extent={{-18,-80},{2,-60}})));
    BoundaryConditions.WeatherData.BaseClasses.EquationOfTime eqnTim
      annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
    BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incAng(azi=azi,
        til=til,lat=lat) annotation (Placement(transformation(extent={{60,40},{80,60}})));
    BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zenAng(lat=lat)
      annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
    Utilities.Time.ModelTime modTim
      annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  equation
    connect(solTim.solTim, solHouAng.solTim) annotation (Line(points={{3,-70},{18,
            -70}},                    color={0,0,127}));
    connect(locTim.locTim, solTim.locTim) annotation (Line(points={{-39,-70},{-26,
            -70},{-26,-75.4},{-20,-75.4}}, color={0,0,127}));
    connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(points={{1,-30},{6,-30},
            {6,-52},{-26,-52},{-26,-64},{-20,-64}},        color={0,0,127}));
    connect(decAng.decAng, incAng.decAng) annotation (Line(points={{-19,50},{32,50},
            {32,55.4},{57.8,55.4}}, color={0,0,127}));
    connect(solHouAng.solHouAng, incAng.solHouAng) annotation (Line(points={{41,-70},
            {48,-70},{48,45.2},{58,45.2}}, color={0,0,127}));
    connect(decAng.decAng, zenAng.decAng) annotation (Line(points={{-19,50},{32,50},
            {32,-44.6},{58,-44.6}}, color={0,0,127}));
    connect(solHouAng.solHouAng, zenAng.solHouAng) annotation (Line(points={{41,-70},
            {48,-70},{48,-54.8},{58,-54.8}}, color={0,0,127}));

   nDay = floor(modTim.y/86400)*86400
    "Zero-based day number in seconds (January 1=0, January 2=86400)";
   cloTim= modTim.y-nDay;

   eqnTim.nDay= nDay;

   locTim.cloTim=cloTim;

   decAng.nDay= nDay;

   zen = if zenAng.zen <= Modelica.Constants.pi/2 then
   zenAng.zen
   else
   Modelica.Constants.pi/2
   "Restriction for zenith angle";

    refAng = if noEvent(incAng.incAng >= Modelica.Constants.eps and incAng.incAng <= Modelica.Constants.pi
    /2*0.999) then asin(sin(incAng.incAng)/refInd) else
    0;

    refAngGro = if noEvent(incAngGro >= Modelica.Constants.eps and incAngGro <= Modelica.Constants.pi/2*
    0.999) then asin(sin(incAngGro)/refInd) else
    0;

    refAngDif = if noEvent(incAngDif >= Modelica.Constants.eps and incAngDif <= Modelica.Constants.pi/2*
    0.999) then asin(sin(incAngDif)/refInd) else
    0;

    tau = if noEvent(incAng.incAng >= Modelica.Constants.eps and incAng.incAng <= Modelica.Constants.pi/
    2*0.999 and refAng >= Modelica.Constants.eps) then exp(-(glaExtCoe*glaThi/cos(refAng)))*(1
    - 0.5*((sin(refAng - incAng.incAng)^2)/(sin(refAng + incAng.incAng)^2) + (
    tan(refAng - incAng.incAng)^2)/(tan(refAng + incAng.incAng)^2))) else
    0;

    tau_gro = if noEvent(incAngGro >= Modelica.Constants.eps and refAngGro >= Modelica.Constants.eps) then exp(-(
    glaExtCoe*glaThi/cos(refAngGro)))*(1 - 0.5*((sin(refAngGro - incAngGro)^2)/
    (sin(refAngGro + incAngGro)^2) + (tan(refAngGro - incAngGro)^2)/(tan(
    refAngGro + incAngGro)^2))) else
    0;

    tau_diff = if noEvent(incAngDif >= Modelica.Constants.eps and refAngDif >= Modelica.Constants.eps) then exp(-(
    glaExtCoe*glaThi/cos(refAngDif)))*(1 - 0.5*((sin(refAngDif - incAngDif)^2)/
    (sin(refAngDif + incAngDif)^2) + (tan(refAngDif - incAngDif)^2)/(tan(
    refAngDif + incAngDif)^2))) else
    0;

    incAngMod = tau/tau_0;

    incAngModGro = tau_gro/tau_0;

    incAngModDif = tau_diff/tau_0;

    airMasMod = if (b_0 + b_1*(airMas^1) + b_2*(airMas^2) + b_3*(
    airMas^3) + b_4*(airMas^4)) <= 0 then
    0 else
    b_0 + b_1*(airMas^1) + b_2*(airMas^2) + b_3*(airMas^3) + b_4*(airMas^4);

    airMas = exp(-0.0001184*alt)/(cos(zen) + 0.5057*(96.080 - zen*
    180/Modelica.Constants.pi)^(-1.634));

    incAngGro = (90 - 0.5788*til*180/Modelica.Constants.pi + 0.002693*(til*180/
    Modelica.Constants.pi)^2)*Modelica.Constants.pi/180;

    incAngDif = (59.7 - 0.1388*til*180/Modelica.Constants.pi + 0.001497*(til*180/
    Modelica.Constants.pi)^2)*Modelica.Constants.pi/180;

    R_b = if noEvent((zen >= Modelica.Constants.pi/2*0.999) or (cos(incAng.incAng)
    > cos(zen)*4)) then 4 else (cos(incAng.incAng)/cos(zen));

    HGloHor = HGloHorBea + HGloHorDif;

    radTil = if noEvent(HGloHor <= 0.1) then 0 else HGloHorBea*R_b + HGloHorDif*(0.5*(1 + cos(
    til)*(1 + (1 - (HGloHorDif/HGloHor)^2)*sin(til/2)^3)*(1 + (1 - (HGloHorDif/
    HGloHor)^2)*(cos(incAng.incAng)^2)*(cos(til)^3)))) + HGloHor*groRef*(1 - cos(
    til))/2;

    k_t = if noEvent(HGloHor <=0.001) then 0
    else
    min(1,max(0,(HGloHor)/(G_sc*(1.00011+0.034221*cos(2*Modelica.Constants.pi*nDay/24/60/60/365)+0.00128*sin(2*Modelica.Constants.pi*nDay/24/60/60/365)
    +0.000719*cos(2*2*Modelica.Constants.pi*nDay/24/60/60/365)+0.000077*sin(2*2*Modelica.Constants.pi*nDay/24/60/60/365))*cos(zenAng.zen)))) "after (Iqbal,1983)";

  // Erb´s diffuse fraction relation
    HGloHorDif = if HGloHor <=0.001 then 0
    elseif
         k_t <= 0.22 then
    (HGloHor)*(1.0-0.09*k_t)
     elseif
         k_t > 0.8 then
    (HGloHor)*0.165
     else
    (HGloHor)*(0.9511-0.1604*k_t+4.388*k_t^2-16.638*k_t^3+12.336*k_t^4);

    absRadRat = if noEvent(HGloHor <=0.1) then 0
    else
    airMasMod*(HGloHorBea/radTil0*R_b*incAngMod
    +HGloHorDif/radTil0*incAngModDif*(0.5*(1+cos(til)*(1+(1-(HGloHorDif/HGloHor)^2)*sin(til/2)^3)*(1+(1-(HGloHorDif/HGloHor)^2)*(cos(incAng.incAng)^2)*(cos(til)^3))))
    +HGloHor/radTil0*groRef*incAngModGro*(1-cos(til))/2);

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PVOpticalHorFixedAziTil;

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

</html>"));
  end PVElectrical1DiodeMPP;

  model PVElectrical2Diodes
    "2 diodes model for PV I-V characteristics with temp. dependency based on 9 parameters"
    extends
      IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVElectrical2Diodes;
    input Modelica.Blocks.Interfaces.RealInput U(unit="V")
      "Module voltage"
      annotation (Placement(transformation(extent={{-138,-20},{-100,18}}),
                                                                        iconTransformation(extent={{-10,-10},{10,10}},origin={-110,8})));
  equation
    0 = IPho - ISat1 * (Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer)/(1.0 * Ut)) - 1.0)
      - ISat2 * (Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer)/(2.0 * Ut)) - 1.0)
      - (U / nCelSer + (I / nCelPar) * RSer) / RPar - I / nCelPar;
    P = I * U;
    annotation (
  Documentation(info="<html>
<p>
This is a 2 diodes electrical model of a PV module.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 11, 2022 by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"));
  end PVElectrical2Diodes;

  model PVElectrical2DiodesMPP
    "MPP controlled 2 diodes model for PV I-V characteristics with temp. dependency based on 9 parameters"
    extends
      IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVElectrical2Diodes;
    output Modelica.Blocks.Interfaces.RealOutput U(
      unit="V",
      start = 0.0)
      "Module voltage"
      annotation (Placement(transformation(extent={{60,-10},{80,10}}), iconTransformation(extent={{60,-10},{80,10}})));
    Real lambda(start = 0.0)
      "Lagrange multiplier";

  equation
    // Calculation of I_MPP and U_MPP with the calculation method extremes under constraints with Lagrange multiplier
    0 = IPho - ISat1 * (Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer)/(1.0 * Ut)) - 1.0)
      - ISat2 * (Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer)/(2.0 * Ut)) - 1.0)
      - (U / nCelSer + (I / nCelPar) * RSer) / RPar - I / nCelPar;

    0 = I / nCelPar - lambda * ((ISat1 / (1.0 * Ut)) * Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer) / (1.0 * Ut))
      + (ISat2 / (2.0 * Ut))* Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer) / (2.0 * Ut)) + 1.0 / RPar);

    0 = U / nCelSer - lambda * (( RSer * ISat1) / (1.0 * Ut) * Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer) / (1.0 * Ut))
      + (RSer * ISat2) / (2.0 * Ut) * Modelica.Math.exp((U / nCelSer + (I / nCelPar) * RSer) / (2.0 * Ut)) + RSer / RPar + 1.0);

    P = I * U;
    annotation (
  Documentation(info="<html>
<p>
This is a 2 diodes MPP controlled electrical model of a PV module.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 11, 2022 by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"));
  end PVElectrical2DiodesMPP;

  model PVThermalEmpMountOpenRack
    "Empirical thermal model for PV cell with open rack mounting (tilt > 10 °)"
    extends
      IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVThermalEmp;

   final parameter Modelica.Units.SI.Temperature T_a_0=293.15
      "Reference ambient temperature";
   final parameter Real coeff_trans_abs = 0.9
   "Module specific coefficient as a product of transmission and absorption.
 It is usually unknown and set to 0.9 in literature";

  equation

   TCel =if noEvent(radTil >= Modelica.Constants.eps) then (TDryBul) + (T_NOCT
       - T_a_0)*radTil/radNOCT*9.5/(5.7 + 3.8*winVel)*(1 - eta/coeff_trans_abs)
       else (TDryBul);
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html><h4>
  <span style=\"color: #008000\">Overview</span>
</h4>
<p>
  Model for determining the cell temperature of a PV module mounted on
  an open rack under operating conditions and under consideration of
  the wind velocity.
</p>
<p>
  <br/>
</p>
<h4>
  <span style=\"color: #008000\">References</span>
</h4>
<p>
  <q>Solar engineering of thermal processes.</q> by Duffie, John A. ;
  Beckman, W. A.
</p>
</html>"));
  end PVThermalEmpMountOpenRack;

  package BaseClasses "Package with base classes for IBPSA.Electrical"
    extends Modelica.Icons.BasesPackage;
    function lambertWSimple
      "Simple approximation for Lambert W function for x >= 2, should only
be used for large input values as error decreases for increasing input values"

       input Real x(min=2);
       output Real W;

    algorithm
      W:= log(x)*(1-log(log(x))/(log(x)+1));
      annotation (Documentation(info="<html>
<p><span style=\"font-family: Roboto; color: #202124; background-color: #ffffff;\">The Lambert W function solves mathematical equations in which the unknown is both inside and outside of an exponential function or a logarithm.</span></p>
<p>This function is a simple approximation for Lambert W function following Baetzelis, 2016:</p>
</html>"));
    end lambertWSimple;

    package Icons
      partial model partialPVIcon "Partial model for basic PV model icon"
        annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                   Text(extent={{-38,-64},{46,-98}},lineColor={0,0,255},textString= "%name"),
          Rectangle(extent={{-50,90},{50,-68}},lineColor={215,215,215},fillColor={215,215,215},
                  fillPattern =                                                                              FillPattern.Solid),
          Rectangle(extent={{-46,28},{-18,0}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                     FillPattern.Solid),
          Rectangle(extent={{-14,28},{14,0}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                    FillPattern.Solid),
          Rectangle(extent={{18,28},{46,0}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                   FillPattern.Solid),
          Rectangle(extent={{-46,-4},{-18,-32}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                       FillPattern.Solid),
          Rectangle(extent={{-14,-4},{14,-32}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                      FillPattern.Solid),
          Rectangle(extent={{18,-4},{46,-32}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                     FillPattern.Solid),
          Rectangle(extent={{-46,-36},{-18,-64}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                        FillPattern.Solid),
          Rectangle(extent={{-14,60},{14,32}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                     FillPattern.Solid),
          Rectangle(extent={{18,60},{46,32}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                    FillPattern.Solid),
          Rectangle(extent={{-46,60},{-18,32}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                      FillPattern.Solid),
          Rectangle(extent={{-14,-36},{14,-64}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                       FillPattern.Solid),
          Rectangle(extent={{18,-36},{46,-64}},lineColor={0,0,255},fillColor={0,0,255},
                  fillPattern =                                                                      FillPattern.Solid)}),
            Diagram(coordinateSystem(preserveAspectRatio=false)));
      end partialPVIcon;
    end Icons;

    partial model PartialPVElectrical
      "Partial electrical model for PV module model"

     replaceable parameter IBPSA.Electrical.DataBase.PVBaseDataDefinition data
     constrainedby IBPSA.Electrical.DataBase.PVBaseDataDefinition
        "PV Panel data definition" annotation (choicesAllMatching);
      Modelica.Blocks.Interfaces.RealInput TCel "Cell temperature"
        annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
         Rectangle(
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,100},{100,-100}}),
            Line(
              points={{-66,-64},{-66,88}},
              color={0,0,0},
              arrow={Arrow.None,Arrow.Filled},
              thickness=0.5),
            Line(
              points={{-66,-64},{64,-64}},
              color={0,0,0},
              arrow={Arrow.None,Arrow.Filled},
              thickness=0.5),
            Text(
              extent={{-72,80},{-102,68}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              textString="I"),
            Text(
              extent={{80,-80},{50,-92}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              textString="U"),
            Line(
              points={{-66,54},{-66,54},{-6,54},{12,50},{22,42},{32,28},{38,8},{
                  42,-14},{44,-44},{44,-64}},
              color={0,0,0},
              thickness=0.5,
              smooth=Smooth.Bezier)}),                               Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end PartialPVElectrical;

    partial model PartialPVElectrical1Diode
      "Partial electrical model for PV module model following the 1 diode approach"
      extends
        IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVElectrical(
        redeclare IBPSA.Electrical.DataBase.PV1DiodeBaseDataDefinition data);

      replaceable parameter IBPSA.Electrical.DataBase.PV1DiodeBaseDataDefinition
        data constrainedby IBPSA.Electrical.DataBase.PV1DiodeBaseDataDefinition
        "PV Panel data definition" annotation (choicesAllMatching);

    // Adjustable input parameters

     parameter Real n_mod(final quantity=
        "NumberOfModules", final unit="1") "Number of connected PV modules"
        annotation ();


    // Parameters from module data sheet

    final parameter Modelica.Units.SI.Efficiency eta_0=data.eta_0
      "Efficiency under standard conditions";

     final parameter Real n_ser=data.n_ser
        "Number of cells connected in series on the PV panel";

    final parameter Modelica.Units.SI.Area A_pan=data.A_pan
      "Area of one Panel, must not be confused with area of the whole module";

    final parameter Modelica.Units.SI.Area A_mod=data.A_mod
      "Area of one module (housing)";

    final parameter Modelica.Units.SI.Voltage V_oc0=data.V_oc0
      "Open circuit voltage under standard conditions";

    final parameter Modelica.Units.SI.ElectricCurrent I_sc0=data.I_sc0
      "Short circuit current under standard conditions";

    final parameter Modelica.Units.SI.Voltage V_mp0=data.V_mp0
      "MPP voltage under standard conditions";

    final parameter Modelica.Units.SI.ElectricCurrent I_mp0=data.I_mp0
      "MPP current under standard conditions";

    final parameter Modelica.Units.SI.Power P_Max=data.P_mp0*1.05
      "Maximal power of one PV module under standard conditions. P_MPP with 5 % tolerance. This is used to limit DCOutputPower.";

     final parameter Real TCoeff_Isc(unit = "A/K")=data.TCoeff_Isc
        "Temperature coefficient for short circuit current, >0";

     final parameter Real TCoeff_Voc(unit = "V/K")=data.TCoeff_Voc
        "Temperature coefficient for open circuit voltage, <0";

    final parameter Modelica.Units.SI.LinearTemperatureCoefficient alpha_Isc=data.alpha_Isc
      "Normalized temperature coefficient for short circuit current, >0";

    final parameter Modelica.Units.SI.LinearTemperatureCoefficient beta_Voc=data.beta_Voc
      "Normalized temperature coefficient for open circuit voltage, <0";

    final parameter Modelica.Units.SI.LinearTemperatureCoefficient gamma_Pmp=data.gamma_Pmp
      "Normalized temperature coefficient for power at MPP";

    final parameter Modelica.Units.SI.Temperature TCel0= 25 + 273.15
      "Thermodynamic cell temperature under standard conditions";

      Modelica.Blocks.Interfaces.RealInput absRadRat
        "Ratio of absorbed radiation under operating conditions to standard conditions"
        annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
      Modelica.Blocks.Interfaces.RealInput radTil
        "Total solar irradiance on the tilted surface"
        annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
      Modelica.Blocks.Interfaces.RealOutput P "DC power output"
        annotation (Placement(transformation(extent={{100,40},{120,60}})));
      Modelica.Blocks.Interfaces.RealOutput eta
        "Efficiency of the PV module under operating conditions"
        annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
         Rectangle(
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,100},{100,-100}}),
            Line(
              points={{-66,-64},{-66,88}},
              color={0,0,0},
              arrow={Arrow.None,Arrow.Filled},
              thickness=0.5),
            Line(
              points={{-66,-64},{64,-64}},
              color={0,0,0},
              arrow={Arrow.None,Arrow.Filled},
              thickness=0.5),
            Text(
              extent={{-72,80},{-102,68}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              textString="I"),
            Text(
              extent={{80,-80},{50,-92}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              textString="U"),
            Line(
              points={{-66,54},{-66,54},{-6,54},{12,50},{22,42},{32,28},{38,8},{
                  42,-14},{44,-44},{44,-64}},
              color={0,0,0},
              thickness=0.5,
              smooth=Smooth.Bezier)}),                               Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end PartialPVElectrical1Diode;

    partial model PartialPVElectrical2Diodes
      "2 diodes model for PV I-V characteristics with temp. dependency based on 9 parameters"
      extends
        IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVElectrical;
      parameter Integer nCelPar
          "Number of parallel connected cells within the PV module";
      parameter Integer nCelSer
        "Number of serial connected cells within the PV module";
      parameter Real Eg(unit = "eV")
        "Band gap";
      parameter Real c1(unit = "m2/V")
        "1st coefficient IPho";
      parameter Real c2(unit = "m2/(kV.K)")
        "2nd coefficient IPho";
      parameter Real cs1(unit = "A/K3")
        "1st coefficient ISat1";
      parameter Real cs2(unit = "A/K5")
        "2nd coefficient ISat2";
      parameter Real RPar(unit = "V/A")
        "Parallel resistance";
      parameter Real RSer(unit = "V/A")
        "Serial resistance";
      Modelica.Units.SI.ElectricCurrent IPho
        "Photo current";
      Modelica.Units.SI.ElectricCurrent ISat1
        "Saturation current diode 1";
      Modelica.Units.SI.ElectricCurrent ISat2
        "Saturation current diode 2";

      input Modelica.Blocks.Interfaces.RealInput ITot(
        final quantity="RadiantEnergyFluenceRate",
        final unit="W/m2",
        displayUnit="W/m2")
        "Effective total solar irradiation on solar cell"
        annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
                                                                            iconTransformation(extent={{-120,
                -50},{-100,-30}})));
      output Modelica.Blocks.Interfaces.RealOutput P(
        final quantity="Power",
        final unit="W",
        displayUnit="W")
        "Module power"
        annotation (Placement(transformation(extent={{100,40},{120,60}}),
                                                                        iconTransformation(extent={{100,40},
                {120,60}})));
      output Modelica.Blocks.Interfaces.RealOutput I(unit="A", start = 0.0)
        "Module current"
        annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
                                                                          iconTransformation(extent={{100,-60},
                {120,-40}})));
      Modelica.Units.SI.Voltage Ut "Temperature voltage";
    protected
      final constant Real e(unit = "A.s") = Modelica.Constants.F/Modelica.Constants.N_A
        "Elementary charge";
      final constant Real k(unit = "J/K") = Modelica.Constants.R/Modelica.Constants.N_A
        "Boltzmann constant";
    equation
      Ut =k*TCel/e;

      IPho =(c1 + c2*0.001*TCel)*ITot;

      ISat1 =cs1*TCel*TCel*TCel*Modelica.Math.exp(-(Eg*e)/(k*T));

      ISat2 =cs2*sqrt(TCel*TCel*TCel*TCel*TCel)*Modelica.Math.exp(-(Eg*e)/(2.0*
        k*TCel));

        annotation (
      Documentation(info="<html>
  <p>
  This is a partial 2 diodes electrical model of a PV module.
  </p>
  </html>",     revisions="<html>
  <ul>
  <li>
  October 11, 2022 by Christoph Nytsch-Geusen:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
    end PartialPVElectrical2Diodes;

    partial model PartialPVThermal
     "Partial model for determining the cell temperature of a PV moduleConnector 
  for PV record data"
     replaceable parameter IBPSA.Electrical.DataBase.PVBaseDataDefinition data
     constrainedby IBPSA.Electrical.DataBase.PVBaseDataDefinition
        "PV Panel data definition" annotation (choicesAllMatching);
      Modelica.Blocks.Interfaces.RealOutput TCel "Cell temperature"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                 Text(extent={{-40,-68},{44,-102}},
                                                                  lineColor={0,0,255},textString= "%name"),
        Rectangle(extent={{-94,86},{6,-72}}, lineColor={215,215,215},fillColor={215,215,215},
                fillPattern =                                                                              FillPattern.Solid),
        Rectangle(extent={{-90,24},{-62,-4}},
                                            lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                     FillPattern.Solid),
        Rectangle(extent={{-58,24},{-30,-4}},
                                           lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                    FillPattern.Solid),
        Rectangle(extent={{-26,24},{2,-4}},
                                          lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                   FillPattern.Solid),
        Rectangle(extent={{-90,-8},{-62,-36}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                       FillPattern.Solid),
        Rectangle(extent={{-58,-8},{-30,-36}},
                                             lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                      FillPattern.Solid),
        Rectangle(extent={{-26,-8},{2,-36}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                     FillPattern.Solid),
        Rectangle(extent={{-90,-40},{-62,-68}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                        FillPattern.Solid),
        Rectangle(extent={{-58,56},{-30,28}},
                                            lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                     FillPattern.Solid),
        Rectangle(extent={{-26,56},{2,28}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                    FillPattern.Solid),
        Rectangle(extent={{-90,56},{-62,28}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                      FillPattern.Solid),
        Rectangle(extent={{-58,-40},{-30,-68}},
                                              lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                       FillPattern.Solid),
        Rectangle(extent={{-26,-40},{2,-68}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                      FillPattern.Solid),
            Ellipse(
              extent={{46,-90},{86,-52}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={191,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{54,48},{78,-60}},
              lineColor={191,0,0},
              fillColor={191,0,0},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{54,48},{54,88},{56,94},{60,96},{66,98},{72,96},{76,94},{78,
                  88},{78,48},{54,48}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(
              points={{54,48},{54,-56}},
              thickness=0.5),
            Line(
              points={{78,48},{78,-56}},
              thickness=0.5),
            Text(
              extent={{92,4},{-28,-26}},
              lineColor={0,0,0},
              textString="T")}),                                     Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end PartialPVThermal;

    partial model PartialPVThermalEmp
      "Empirical thermal models for PV cells to calculate cell temperature"
      extends
        IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem.BaseClasses.PartialPVThermal;

      final parameter Modelica.Units.SI.Efficiency eta_0=data.eta_0
        "Efficiency under standard conditions";

      final parameter Modelica.Units.SI.Temperature T_NOCT=data.T_NOCT
        "Cell temperature under NOCT conditions";

     final parameter Real radNOCT(final quantity="Irradiance",
        final unit="W/m2")= 800
        "Irradiance under NOCT conditions";

      Modelica.Blocks.Interfaces.RealInput TDryBul "Ambient temperature (dry bulb)"
        annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
      Modelica.Blocks.Interfaces.RealInput winVel "Wind velocity"
        annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
      Modelica.Blocks.Interfaces.RealInput eta
        "Efficiency of the PV module under operating conditions"
        annotation (Placement(transformation(extent={{-140,-30},{-100,10}})));
      Modelica.Blocks.Interfaces.RealInput radTil
        "Total solar irradiance on the tilted surface"
        annotation (Placement(transformation(extent={{-142,-90},{-102,-50}})));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                 Text(extent={{-40,-68},{44,-102}},
                                                                  lineColor={0,0,255},textString= "%name"),
        Rectangle(extent={{-94,86},{6,-72}}, lineColor={215,215,215},fillColor={215,215,215},
                fillPattern =                                                                              FillPattern.Solid),
        Rectangle(extent={{-90,24},{-62,-4}},
                                            lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                     FillPattern.Solid),
        Rectangle(extent={{-58,24},{-30,-4}},
                                           lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                    FillPattern.Solid),
        Rectangle(extent={{-26,24},{2,-4}},
                                          lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                   FillPattern.Solid),
        Rectangle(extent={{-90,-8},{-62,-36}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                       FillPattern.Solid),
        Rectangle(extent={{-58,-8},{-30,-36}},
                                             lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                      FillPattern.Solid),
        Rectangle(extent={{-26,-8},{2,-36}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                     FillPattern.Solid),
        Rectangle(extent={{-90,-40},{-62,-68}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                        FillPattern.Solid),
        Rectangle(extent={{-58,56},{-30,28}},
                                            lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                     FillPattern.Solid),
        Rectangle(extent={{-26,56},{2,28}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                    FillPattern.Solid),
        Rectangle(extent={{-90,56},{-62,28}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                      FillPattern.Solid),
        Rectangle(extent={{-58,-40},{-30,-68}},
                                              lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                       FillPattern.Solid),
        Rectangle(extent={{-26,-40},{2,-68}},lineColor={0,0,255},fillColor={0,0,255},
                fillPattern =                                                                      FillPattern.Solid),
            Ellipse(
              extent={{46,-90},{86,-52}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={191,0,0},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{54,48},{78,-60}},
              lineColor={191,0,0},
              fillColor={191,0,0},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{54,48},{54,88},{56,94},{60,96},{66,98},{72,96},{76,94},{78,
                  88},{78,48},{54,48}},
              lineColor={0,0,0},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(
              points={{54,48},{54,-56}},
              thickness=0.5),
            Line(
              points={{78,48},{78,-56}},
              thickness=0.5),
            Text(
              extent={{92,4},{-28,-26}},
              lineColor={0,0,0},
              textString="T")}),                                     Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end PartialPVThermalEmp;

    partial model PartialPVOptical
      Modelica.Blocks.Interfaces.RealInput HGloHor annotation (Placement(
            transformation(extent={{-132,-16},{-100,16}}),iconTransformation(
              extent={{-132,-16},{-100,16}})));
      Modelica.Blocks.Interfaces.RealOutput absRadRat
        "Ratio of absorbed radiation under operating conditions to standard conditions"
        annotation (Placement(transformation(extent={{100,42},{120,62}})));
      Modelica.Blocks.Interfaces.RealOutput radTil
        "Total solar radiation on the tilted surface"
        annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Ellipse(
              extent={{-78,76},{-22,24}},
              lineColor={0,0,0},
              fillColor={244,125,35},
              fillPattern=FillPattern.Solid),
            Polygon(
              points={{12,-34},{42,22},{96,10},{68,-48},{12,-34}},
              lineColor={0,0,0},
              fillColor={135,135,135},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-26,32},{44,-14},{-34,-56}},
              color={0,0,0},
              arrow={Arrow.None,Arrow.Filled})}),                    Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end PartialPVOptical;
  end BaseClasses;
end PVSystem;
