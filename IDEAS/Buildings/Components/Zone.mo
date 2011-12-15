within IDEAS.Buildings.Components;
model Zone "thermal building zone"

extends IDEAS.Buildings.Components.Interfaces.StateZone;

parameter Modelica.SIunits.Volume V "Total air volume";
parameter Real n50 = 0.0 "n50 value of airtightness";
parameter Real corrCV = 5 "Multiplication factor for the zone air capacity";

//to be moved from the zone definition to ventilation models
protected
parameter Boolean recuperation = false;
parameter Modelica.SIunits.Efficiency RecupEff = 0.84
    "efficientie on heat recuperation of ventilation air";

//not necessary ?
protected
parameter Modelica.SIunits.Length height = 2.7 "zone height";
parameter Modelica.SIunits.Temperature Tset = 294.15 "setpoint temperature";
parameter Real ACH = 0.5 "ventilation rate";

protected
  IDEAS.Buildings.Components.BaseClasses.ZoneLwGainDistribution radDistr(nSurf=nSurf)
    "distribution of radiative internal gains"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-54,-44})));
  IDEAS.Buildings.Components.BaseClasses.MixedAir conDistr(
    nSurf=nSurf,
    V=V,
    corrCV=corrCV) "convective part of the zone"
    annotation (Placement(transformation(extent={{-2,10},{-22,30}})));
  IDEAS.Buildings.Components.BaseClasses.Ventilation vent(
    n50=n50,
    V=V,
    ACH=ACH,
    RecupEff=RecupEff,
    recuperation=recuperation) "zone ventilation"                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,42})));
  IDEAS.Buildings.Components.BaseClasses.ZoneLwDistribution radDistrLw(nSurf=
        nSurf) "internal longwave radiative heat exchange"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-54,-10})));

  Modelica.Blocks.Math.Sum sum(nin=2, k={0.5,0.5})
    annotation (Placement(transformation(extent={{0,-66},{12,-54}})));
equation
  connect(surfRad, radDistr.radSurfTot) annotation (Line(
      points={{-100,-60},{-74,-60},{-74,-26},{-54,-26},{-54,-34}},
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
      points={{-100,-30},{-30,-30},{-30,20},{-22,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conDistr.conGain, gainCon) annotation (Line(
      points={{-2,20},{49,20},{49,-30},{100,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radDistr.radGain, gainRad) annotation (Line(
      points={{-50.2,-54},{-50,-54},{-50,-72},{80,-72},{80,-60},{100,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vent.port_a, conDistr.conGain) annotation (Line(
      points={{10,32},{10,20},{-2,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(surfRad, radDistrLw.port_a) annotation (Line(
      points={{-100,-60},{-74,-60},{-74,-26},{-54,-26},{-54,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(epsLw, radDistr.epsLw) annotation (Line(
      points={{-104,30},{-104,30},{-82,30},{-82,-44},{-64,-44}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(epsSw, radDistr.epsSw) annotation (Line(
      points={{-104,0},{-86,0},{-86,-48},{-64,-48}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(epsLw, radDistrLw.epsLw) annotation (Line(
      points={{-104,30},{-82,30},{-82,-10},{-64,-10}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(sum.y, TSensor) annotation (Line(
      points={{12.6,-60},{59.3,-60},{59.3,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radDistr.TRad, sum.u[1]) annotation (Line(
      points={{-44,-44},{-22,-44},{-22,-60.6},{-1.2,-60.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conDistr.TCon, sum.u[2]) annotation (Line(
      points={{-12,10},{-12,-62},{-1.2,-62},{-1.2,-59.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radDistrLw.A, area) annotation (Line(
      points={{-64,-14},{-72,-14},{-72,-14},{-78,-14},{-78,60},{-104,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radDistr.area, area) annotation (Line(
      points={{-64,-40},{-78,-40},{-78,60},{-104,60}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (Icon(graphics));
end Zone;
