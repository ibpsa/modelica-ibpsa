within IDEAS.HeatingSystems.Examples;
model IdealEmbeddedHeating
  "Example and test for ideal heating with embedded emission"
  import IDEAS;
  extends Modelica.Icons.Example;
  final parameter Integer nZones=1 "Number of zones";
  IDEAS.HeatingSystems.IdealEmbeddedHeating heating(
    nZones=nZones,
    VZones={75*2.7 for i in 1:nZones},
    QNom={20000 for i in 1:nZones},
    t=10) annotation (Placement(transformation(extent={{20,-22},{38,2}})));
  Modelica.Blocks.Sources.Pulse[nZones] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289,
    startTime={3600*7,3600*9})
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
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
    annotation (Placement(transformation(extent={{64,-20},{84,0}})));
  IDEAS.HeatingSystems.Examples.DummyBuilding dummyBuilding(nZones=nZones)
    annotation (Placement(transformation(extent={{-96,-16},{-64,4}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-48,0})));
  IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.NakedTabs[nZones] nakedTabs(radSlaCha=
       radSlaCha_ValidationEmpa)
    annotation (Placement(transformation(extent={{-6,-12},{-26,8}})));
  IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.RadSlaCha_ValidationEmpa[nZones]
                                       radSlaCha_ValidationEmpa(A_Floor=
        dummyBuilding.AZones)
    annotation (Placement(transformation(extent={{-94,-98},{-74,-78}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.RealExpression[nZones] realExpression(y=11*
        radSlaCha_ValidationEmpa.A_Floor)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(heating.TSet, TOpSet.y) annotation (Line(
      points={{28.82,-22.48},{28.82,-50},{21,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(voltageSource.pin_p, ground.pin) annotation (Line(
      points={{90,-74},{90,-82}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(dummyInHomeGrid.pinSingle, voltageSource.pin_n) annotation (Line(
      points={{84,-10},{90,-10},{90,-54}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.plugLoad, dummyInHomeGrid.nodeSingle) annotation (Line(
      points={{47,-10},{64,-10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{11,-2.8},{1.5,-2.8},{1.5,-2},{-6,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs.port_a, convectionTabs.solid) annotation (Line(
      points={{-16,8},{-16,14},{-34,14},{-34,0},{-40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs.port_b, convectionTabs.solid) annotation (Line(
      points={{-16,-11.8},{-16,-18},{-34,-18},{-34,0},{-40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.heatPortEmb, convectionTabs.fluid) annotation (Line(
      points={{-64,0},{-56,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.TSensor, heating.TSensor) annotation (Line(
      points={{-63.36,-12},{-58,-12},{-58,-28},{0,-28},{0,-17.2},{10.64,-17.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, convectionTabs.Gc) annotation (Line(
      points={{-59,40},{-48,40},{-48,8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end IdealEmbeddedHeating;
