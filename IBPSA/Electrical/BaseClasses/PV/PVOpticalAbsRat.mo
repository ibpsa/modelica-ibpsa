within IBPSA.Electrical.BaseClasses.PV;
model PVOpticalAbsRat
  "Model to calculate absorptance ratio for PV module"

  extends IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVOptical;

 parameter Modelica.Units.SI.Height alt
   "Site altitude in Meters, default= 1"
   annotation(Dialog(group="Location"));

 parameter Real groRef(unit="1")       "Ground reflectance"
   annotation ();

  constant Modelica.Units.SI.Irradiance HGloHor0=1000
 "Total solar radiation on the horizontal surface under standard conditions"
  annotation(Dialog(group="Location"));

  constant Modelica.Units.SI.Irradiance G_sc=1376 "Solar constant";

  parameter Real glaExtCoe(unit="1/m")=4
  "Glazing extinction coefficient for glass";

  parameter Modelica.Units.SI.Length glaThi=0.002
  "Glazing thickness for most PV cell panels it is 0.002 m";

  parameter Real refInd(unit="1")=1.526
  "Effective index of refraction of the cell cover (glass)";

  Modelica.Units.SI.Irradiance HDirHor
   "Beam solar radiation on the horizontal surface";

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

  BaseClasses.PVOptical.AirMass airMass(final alt=alt) "Air mass computation"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  BaseClasses.PVOptical.AirMassModifier airMassModifier(final PVTechType=
        PVTechType) "Air mass modifier computation depending on PV type"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Interfaces.RealOutput absRadRat(final unit="1")
    "Ratio of absorbed radiation under operating conditions to standard conditions"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  //Conditional connectors

protected
parameter Real tau_0(final unit="1")=exp(-(glaExtCoe*glaThi))*(1 - ((refInd - 1)/(
    refInd + 1))^2)
      "Transmittance at standard conditions (incAng=refAng=0)";


equation

zen = if zenAng <= Modelica.Constants.pi/2 then
zenAng
 else
Modelica.Constants.pi/2
"Restriction for zenith angle";

//Refraction angle that the incoming irradiation is refracted by due to the glazing
refAng = if noEvent(incAng >= Modelica.Constants.eps and incAng <=
Modelica.Constants.pi/2*0.999) then asin(sin(incAng)/refInd) else
0;

//Refraction angle that the ground-reflected irradiation is refracted by due to the glazing
refAngGro = if noEvent(incAngGro >= Modelica.Constants.eps and incAngGro <= Modelica.Constants.pi/2*
0.999) then asin(sin(incAngGro)/refInd) else
0;

//Refraction angle that the diffuse irradiation is refracted by due to the glazing
refAngDif = if noEvent(airMassModifier.airMasMod >= Modelica.Constants.eps and incAngDif <= Modelica.Constants.pi/2*
0.999) then asin(sin(incAngDif)/refInd) else
0;

//Transmission coefficient calculated based on the incidence angle
tau = if noEvent(incAng >= Modelica.Constants.eps and incAng <= Modelica.Constants.pi/
2*0.999 and refAng >= Modelica.Constants.eps) then exp(-(glaExtCoe*glaThi/cos(refAng)))*(1
- 0.5*((sin(refAng - incAng)^2)/(sin(refAng + incAng)^2) + (
tan(refAng - incAng)^2)/(tan(refAng + incAng)^2))) else
0;

//Transmission coefficient for the ground-reflected irradiation calculated based on the incidence angle
//of the ground-reflected irradiation
tau_gro = if noEvent(incAngGro >= Modelica.Constants.eps and refAngGro >= Modelica.Constants.eps) then exp(-(
glaExtCoe*glaThi/cos(refAngGro)))*(1 - 0.5*((sin(refAngGro - incAngGro)^2)/
(sin(refAngGro + incAngGro)^2) + (tan(refAngGro - incAngGro)^2)/(tan(
refAngGro + incAngGro)^2))) else
0;

//Transmission coefficient for the diffuse irradiation calculated based on the incidence angle
//of the diffuse irradiation
tau_diff = if noEvent(incAngDif >= Modelica.Constants.eps and refAngDif >= Modelica.Constants.eps) then exp(-(
glaExtCoe*glaThi/cos(refAngDif)))*(1 - 0.5*((sin(refAngDif - incAngDif)^2)/
(sin(refAngDif + incAngDif)^2) + (tan(refAngDif - incAngDif)^2)/(tan(
refAngDif + incAngDif)^2))) else
0;

//Incidence angle modifier to account for relation of transmitted irradiation
//at operating conditions compared to standard conditions
incAngMod = tau/tau_0;

//For the ground-reflected irradiation
incAngModGro = tau_gro/tau_0;

//For the diffuse irradiation
incAngModDif = tau_diff/tau_0;

//Incidence angle of the ground-reflected irradiation
incAngGro = (90 - 0.5788*Til_in_internal*180/Modelica.Constants.pi + 0.002693*(Til_in_internal*180/
Modelica.Constants.pi)^2)*Modelica.Constants.pi/180;

//Incidence angle of the diffuse irradiation
incAngDif = (59.7 - 0.1388*Til_in_internal*180/Modelica.Constants.pi + 0.001497*(Til_in_internal*180/
Modelica.Constants.pi)^2)*Modelica.Constants.pi/180;

//Geometrical relation of normal to horizontal irradiation
R_b = if noEvent((zen >= Modelica.Constants.pi/2*0.999) or (cos(incAng)
> cos(zen)*4)) then 4 else (cos(incAng)/cos(zen));

HGloHor = HDirHor + HDifHor;


//Computes the absorption irradiation ratio for operating conditions following De Soto et al.
absRadRat = if noEvent(HGloHor <=0.1) then 0
  else
  airMassModifier.airMasMod*(HDirHor/HGloHor0*R_b*incAngMod
  +HDifHor/HGloHor0*incAngModDif*(0.5*(1+cos(Til_in_internal)))
  +HGloHor/HGloHor0*groRef*incAngModGro*(1-cos(Til_in_internal))/2);

  connect(airMass.airMas, airMassModifier.airMas) annotation (Line(points={{-39,70},
          {18,70}},                        color={0,0,127}));
  connect(zenAng, airMass.zenAng)
    annotation (Line(points={{-120,70},{-92,70},{-92,70},{-62,70}},
                                                  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
This is an optical model to calculate the absorption ratio of a PV cell based on the radiation.
The model computes the air mass AM = 
</p>
<p>
For a definition of the parameters, see the
<a href=\"modelica://IBPSA.BoundaryConditions.UsersGuide\">
IBPSA.BoundaryConditions.UsersGuide</a>.
</p>
<h4>
  <span style=\"color: #008000\">References</span>
  </h4>
<p>
De Soto, W., Klein, S. A., &amp; Beckman, W. A. (2006). Improvement and validation 
of a model for photovoltaic array performance. Solar energy, 80(1), 78-88.
<a href=\"https://doi.org/10.1016/j.solener.2005.06.010\">
https://doi.org/10.1016/j.solener.2005.06.010</a>
</p>
<p>
De Soto, W., Klein, S. A., &amp; Beckman, W. A. (2006). Improvement and validation 
of a model for photovoltaic array performance. Solar energy, 80(1), 78-88.
<a href=\"https://doi.org/10.1016/j.solener.2005.06.010\">
https://doi.org/10.1016/j.solener.2005.06.010</a>
</p>
</html>", revisions="<html>
<ul>
<li>
Jan 11, 2023, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StartTime=28684800,
      StopTime=28771200,
      Interval=360,
      __Dymola_Algorithm="Dassl"));
end PVOpticalAbsRat;
