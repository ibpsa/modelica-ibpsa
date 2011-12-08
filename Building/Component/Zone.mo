within IDEAS.Building.Component;
model Zone "thermal building zone"

extends IDEAS.Building.Elements.StateZone;

parameter Real[nSurf] weightFactor "solar radiation weight factor per are";
parameter Modelica.SIunits.Volume V "air volume";
parameter Modelica.SIunits.Temperature Tset = 294.15 "setpoint temperature";
parameter Modelica.SIunits.Length height = 2.7 "zone height";
parameter Real ACH "ventilation rate";

parameter Real n50 = 0.0 "n50-value of airtightness";
parameter Modelica.SIunits.Efficiency RecupEff = 0.84
    "efficientie on heat recuperation of ventilation air";

parameter Boolean recuperation = false;

parameter Real corrCV = 5 "correction factor for the zone air capacity";

protected
  IDEAS.Building.Component.Elements.ZoneLwGainDistribution radDistr(nSurf=
        nSurf, weightFactor=weightFactor)
    "distribution of radiative internal gains"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-54,-44})));
  IDEAS.Building.Component.Elements.MixedAir conDistr(
    nSurf=nSurf,
    V=V,
    corrCV=corrCV) "convective part of the zone"
    annotation (Placement(transformation(extent={{-2,10},{-22,30}})));
  IDEAS.Building.Component.Elements.Ventilation vent(
    n50=n50,
    V=V,
    ACH=ACH,
    RecupEff=RecupEff,
    recuperation=recuperation) "zone ventilation"                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,42})));
  IDEAS.Building.Component.Elements.ZoneLwDistribution radDistrLw(nSurf=
        nSurf) "internal longwave radiative heat exchange"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-54,4})));

public
IDEAS.Building.Component.Elements.SummaryZone  summary(
    Top=conDistr.TCon/2 + radDistr.TRad/2,
    Tair=conDistr.TCon,
    Tstar=radDistr.TRad,
    PPD=0,
    PMV=0);

  Modelica.Blocks.Interfaces.RealInput[nSurf] area
    "output of the surface areas for radiative heat losses"
    annotation (Placement(transformation(extent={{20,20},{-20,-20}},
        rotation=90,
        origin={-60,100})));
equation
  connect(surfRad, radDistr.radSurfTot) annotation (Line(
      points={{-100,-20},{-54,-20},{-54,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radDistr.iSolDir, iSolDir) annotation (Line(
      points={{-58,-54},{-58,-80},{-20,-80},{-20,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radDistr.iSolDif, iSolDif) annotation (Line(
      points={{-54,-54},{-54,-76},{20,-76},{20,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(surfCon, conDistr.conSurf) annotation (Line(
      points={{-100,20},{-22,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conDistr.conGain, gainCon) annotation (Line(
      points={{-2,20},{100,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radDistr.radGain, gainRad) annotation (Line(
      points={{-50.2,-54},{-50,-54},{-50,-72},{40,-72},{40,-20},{100,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vent.port_a, conDistr.conGain) annotation (Line(
      points={{10,32},{10,20},{-2,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(surfRad, radDistrLw.port_a) annotation (Line(
      points={{-100,-20},{-54,-20},{-54,-6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(area, radDistr.area) annotation (Line(
      points={{-60,100},{-60,62},{-86,62},{-86,-40},{-64,-40}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(epsLw, radDistr.epsLw) annotation (Line(
      points={{-20,100},{-20,66},{-82,66},{-82,-44},{-64,-44}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(epsSw, radDistr.epsSw) annotation (Line(
      points={{20,100},{20,70},{-76,70},{-76,-48},{-64,-48}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(area, radDistrLw.A) annotation (Line(
      points={{-60,100},{-60,62},{-86,62},{-86,4.44089e-016},{-64,4.44089e-016}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(epsLw, radDistrLw.epsLw) annotation (Line(
      points={{-20,100},{-20,66},{-82,66},{-82,4},{-64,4}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));

end Zone;
