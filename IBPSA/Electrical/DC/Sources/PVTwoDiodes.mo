within IBPSA.Electrical.DC.Sources;
model PVTwoDiodes
  "Photovoltaic module(s) model based on two diodes approach"
  extends IBPSA.Electrical.BaseClasses.PV.PartialPVSystem(
    final ageing=1.0,
    replaceable IBPSA.Electrical.Data.PV.TwoDiodesData data,
    redeclare IBPSA.Electrical.BaseClasses.PV.PVOpticalAbsRat
      partialPVOptical(
        final PVTechType=PVTechType,
        final alt=alt,
        final use_Til_in=use_Til_in,
        final til=til,
        final groRef=groRef,
        final HGloTil0=HGloTil0,
        final glaExtCoe=glaExtCoe,
        final glaThi=glaThi,
        final refInd=refInd),
    redeclare IBPSA.Electrical.BaseClasses.PV.PVElectricalTwoDiodesMPP
      partialPVElectrical(redeclare IBPSA.Electrical.Data.PV.TwoDiodesData
        data=data,
        final n_mod=n_mod),
    replaceable IBPSA.Electrical.BaseClasses.PV.BaseClasses.PartialPVThermalEmp
      partialPVThermal(
      redeclare IBPSA.Electrical.Data.PV.TwoDiodesData data=data),
    final use_MPP_in=false,
    final use_Til_in=false,
    final use_Azi_in=false,
    final use_Sha_in=false,
    final use_age_in=false);

    parameter Integer n_mod(min=1)
      "Amount of modules per system";
    parameter Modelica.Units.SI.Angle til
      "Surface's tilt angle (0:flat)"
      annotation(Dialog(tab="Module mounting and specifications"));
    parameter Modelica.Units.SI.Angle azi
      "Surface's azimut angle (0:South)"
      annotation(Dialog(tab="Module mounting and specifications"));
    parameter Real groRef(unit="1")=0.2
      "Ground reflectance"
      annotation(Dialog(tab="Module mounting and specifications"));
    parameter Real glaExtCoe=4 "Glazing extinction coefficient for glass"
      annotation(Dialog(tab="Module mounting and specifications"));
    parameter Modelica.Units.SI.Length glaThi=0.002
      "Glazing thickness for most PV cell panels it is 0.002 m"
      annotation(Dialog(tab="Module mounting and specifications"));
    parameter Real refInd=1.526
      "Effective index of refraction of the cell cover (glass)"
      annotation(Dialog(tab="Module mounting and specifications"));
    parameter Modelica.Units.SI.Length alt
      "Site altitude in Meters, default= 1"
      annotation(Dialog(tab="Site specifications"));
    constant Modelica.Units.SI.Irradiance HGloTil0=1000
      "Total solar radiation on the horizontal surface under standard conditions"
       annotation(Dialog(tab="Site specifications"));
equation
    connect(partialPVElectrical.eta, partialPVThermal.eta) annotation (Line(
          points={{-23.5,-53},{40,-53},{40,-20},{-72,-20},{-72,8.44},{-36.9231,
          8.44}},
          color={0,0,127}));
    connect(partialPVThermal.TCel, partialPVElectrical.TCel) annotation (Line(
          points={{-24.5385,10},{0,10},{0,-14},{-58,-14},{-58,-47},{-35,-47}},
                          color={0,0,127}));
    connect(partialPVElectrical.P, P) annotation (Line(points={{-23.5,-47},{20,-47},
          {20,-40},{60,-40},{60,10},{106,10}},
                             color={0,0,127}));
    connect(partialPVOptical.absRadRat, partialPVElectrical.absRadRat)
      annotation (Line(points={{-24.4615,70},{20,70},{20,-34},{-64,-34},{-64,
          -51.8},{-35,-51.8}},
                            color={0,0,127}));
    connect(HGloHor, partialPVOptical.HGloHor) annotation (Line(points={{-120,
          132},{-60,132},{-60,80},{-48,80},{-48,68.44},{-35.0769,68.44}},
                                           color={0,0,127}));
    connect(HGloTil, partialPVElectrical.radTil) annotation (Line(points={{-74,158},
          {-100,158},{-100,-54},{-68,-54},{-68,-54.2},{-35,-54.2}},
                                                 color={0,0,127}));
    connect(TDryBul, partialPVThermal.TDryBul) annotation (Line(points={{-120,92},
          {-60,92},{-60,14.68},{-36.9231,14.68}},
                                               color={0,0,127}));
    connect(HGloTil, partialPVThermal.HGloTil) annotation (Line(points={{-74,158},
          {-80,158},{-80,6},{-40,6},{-40,5.32},{-36.9231,5.32}},
                                                             color={0,0,127}));
    connect(vWinSpe, partialPVThermal.winVel) annotation (Line(points={{-120,28},
          {-40,28},{-40,28},{-52,28},{-52,11.56},{-36.9231,11.56}},
                                                            color={0,0,127}));
    connect(zenAngle, partialPVOptical.zenAng) annotation (Line(points={{60,158},
          {-44,158},{-44,74.68},{-35.0769,74.68}},
                                                color={0,0,127}));
    connect(incAngle, partialPVOptical.incAng) annotation (Line(points={{16,158},
          {-88,158},{-88,182},{-54,182},{-54,71.56},{-35.0769,71.56}},
                                                                    color={0,0,127}));
    connect(HDifHor, partialPVOptical.HDifHor) annotation (Line(points={{-28,158},
          {-102,158},{-102,154},{-72,154},{-72,65.32},{-35.0769,65.32}},
                                                                      color={0,0,127}));
    connect(partialPVOptical.tilSet, Til_in_internal);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
                Documentation(info="<html>
<p>This is a photovoltaic generator model based on a two diodes approach with replaceable thermal models accounting for different mountings. </p>
</html>",revisions="<html>
<ul>
<li>
Dec 12, 2022, by Christoph Nytsch-Geusen:<br/>
First implementation.
</li>
</ul>
</html>"));
end PVTwoDiodes;
