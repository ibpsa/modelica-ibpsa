within IDEAS.HeatingSystems.Examples;
model IdealEmbeddedHeating
  "Example and test for ideal heating with embedded emission"
  import IDEAS;

  extends Modelica.Icons.Example;

  parameter Integer nZones=1 "Number of zones";
  IDEAS.HeatingSystems.IdealEmbeddedHeating heating(
    nZones=nZones,
    VZones={75*2.7 for i in 1:nZones},
    QNom={20000 for i in 1:nZones},
    t=1) annotation (Placement(transformation(extent={{-8,-22},{28,-4}})));
  inner IDEAS.SimInfoManager sim(
    redeclare IDEAS.Climate.Meteo.Files.min15 detail,
    redeclare IDEAS.Climate.Meteo.Locations.Uccle city,
    PV=false,
    occBeh=false)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.Pulse[nZones] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289,
    startTime={3600*7,3600*9})
    annotation (Placement(transformation(extent={{-30,-56},{-18,-44}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,-64})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{80,-102},{100,-82}})));
  IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder dummyInHomeGrid
    annotation (Placement(transformation(extent={{64,-22},{84,-2}})));
  IDEAS.HeatingSystems.Examples.DummyBuilding dummyBuilding(nZones=nZones)
    annotation (Placement(transformation(extent={{-90,46},{-60,66}})));
  IDEAS.Thermal.Components.Emission.NakedTabs[nZones] nakedTabs(
    each n1=3,
    each n2=3,
    FHChars(T=0.2, each A_Floor=10))
    annotation (Placement(transformation(extent={{-26,2},{-44,14}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=-90,
        origin={-35,29})));
equation
  convectionTabs.Gc = 11*nakedTabs.FHChars.A_Floor;

  connect(heating.TSet, TOpSet.y) annotation (Line(
      points={{10,-22.36},{10,-50},{-17.4,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(voltageSource.pin_p, ground.pin) annotation (Line(
      points={{90,-74},{90,-82}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(dummyInHomeGrid.pinSingle, voltageSource.pin_n) annotation (Line(
      points={{84,-12},{88,-12},{88,-18},{90,-18},{90,-54}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.plugLoad, dummyInHomeGrid.nodeSingle) annotation (Line(
      points={{28,-13},{46,-13},{46,-12},{64,-12}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(nakedTabs.port_a, convectionTabs.solid) annotation (Line(
      points={{-35,14},{-35,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convectionTabs.fluid, dummyBuilding.heatPortEmb) annotation (Line(
      points={{-35,36},{-36,36},{-36,62},{-60,62}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{-8,-7.6},{-14,-7.6},{-14,-8},{-18,-8},{-18,8},{-26,8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.TSensor, heating.TSensor) annotation (Line(
      points={{-59.4,50},{-52,50},{-52,-18.4},{-8.36,-18.4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end IdealEmbeddedHeating;
