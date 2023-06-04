within IBPSA.Electrical.DC.Sources;
model PVTwoDiodes
  "Photovoltaic module(s) model based on two diodes approach"
  extends IBPSA.Electrical.BaseClasses.PV.PartialPVSystem(
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
    final use_Sha_in=false);

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
        points={{16.5,-33},{40,-33},{40,-20},{-72,-20},{-72,8.44},{4.92308,8.44}},
        color={0,0,127}));
  connect(partialPVThermal.TCel, partialPVElectrical.TCel) annotation (Line(
        points={{15.5385,10},{0,10},{0,-14},{-58,-14},{-58,-27},{5,-27}},
                        color={0,0,127}));
  connect(partialPVElectrical.P, P) annotation (Line(points={{16.5,-27},{20,-27},
          {20,-40},{60,-40},{60,0},{130,0}},
                           color={0,0,127}));
  connect(partialPVOptical.absRadRat, partialPVElectrical.absRadRat)
    annotation (Line(points={{15.4545,50},{20,50},{20,-34},{-64,-34},{-64,-31.8},
          {5,-31.8}},     color={0,0,127}));
  connect(HGloHor, partialPVOptical.HGloHor) annotation (Line(points={{-40,100},
          {-60,100},{-60,80},{-48,80},{-48,49.4},{2.90909,49.4}},
                                         color={0,0,127}));
  connect(HGloTil, partialPVElectrical.radTil) annotation (Line(points={{0,100},
          {-100,100},{-100,-54},{-68,-54},{-68,-34.2},{5,-34.2}},
                                               color={0,0,127}));
  connect(TDryBul, partialPVThermal.TDryBul) annotation (Line(points={{-80,100},
          {-60,100},{-60,14.68},{4.92308,14.68}},
                                             color={0,0,127}));
  connect(HGloTil, partialPVThermal.HGloTil) annotation (Line(points={{0,100},{-80,
          100},{-80,6},{-40,6},{-40,5.32},{4.92308,5.32}}, color={0,0,127}));
  connect(vWinSpe, partialPVThermal.winVel) annotation (Line(points={{-120,100},
          {-40,100},{-40,28},{-52,28},{-52,11.56},{4.92308,11.56}},
                                                          color={0,0,127}));
  connect(zenAngle, partialPVOptical.zenAng) annotation (Line(points={{120,100},
          {-44,100},{-44,54.32},{2.90909,54.32}},
                                              color={0,0,127}));
  connect(incAngle, partialPVOptical.incAng) annotation (Line(points={{80,100},{
          80,64},{-22,64},{-22,51.8},{2.90909,51.8}},             color={0,0,127}));
  connect(HDifHor, partialPVOptical.HDifHor) annotation (Line(points={{40,100},{
          40,70},{-72,70},{-72,47},{2.90909,47}},                   color={0,0,127}));
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
