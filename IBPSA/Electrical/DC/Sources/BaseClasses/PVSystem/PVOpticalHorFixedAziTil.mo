within IBPSA.Electrical.DC.Sources.BaseClasses.PVSystem;
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

  parameter Real HGloTil0(unit="W/m2")=1000
 "Total solar radiation on the horizontal surface under standard conditions"
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

  IBPSA.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  IBPSA.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle solHouAng
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  IBPSA.BoundaryConditions.WeatherData.BaseClasses.LocalCivilTime locTim(timZon=
        timZon, lon=lon)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  IBPSA.BoundaryConditions.WeatherData.BaseClasses.SolarTime solTim
    annotation (Placement(transformation(extent={{-18,-80},{2,-60}})));
  IBPSA.BoundaryConditions.WeatherData.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  IBPSA.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incAng(azi=azi,
      til=til,lat=lat) annotation (Placement(transformation(extent={{60,40},{80,60}})));
  IBPSA.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zenAng(lat=lat)
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  IBPSA.Utilities.Time.ModelTime modTim
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
  airMasMod*(HGloHorBea/HGloTil0*R_b*incAngMod
  +HGloHorDif/HGloTil0*incAngModDif*(0.5*(1+cos(til)*(1+(1-(HGloHorDif/HGloHor)^2)*sin(til/2)^3)*(1+(1-(HGloHorDif/HGloHor)^2)*(cos(incAng.incAng)^2)*(cos(til)^3))))
  +HGloHor/HGloTil0*groRef*incAngModGro*(1-cos(til))/2);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
This is an optical model to calculate the absorption ratio of a PV cell based on the radiation.
</p>
<p>
For a definition of the parameters, see the
<a href=\"modelica://IBPSA.BoundaryConditions.UsersGuide\">
IBPSA.BoundaryConditions.UsersGuide</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVOpticalHorFixedAziTil;
