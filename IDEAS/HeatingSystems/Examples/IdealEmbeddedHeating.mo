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
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=-90,
        origin={-35,29})));
  IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.NakedTabs[nZones]
                        nakedTabs1(
                                  radSlaCha=radSlaCha_ValidationEmpa)
    annotation (Placement(transformation(extent={{-26,-10},{-46,10}})));
  IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.RadSlaCha_ValidationEmpa
                                       radSlaCha_ValidationEmpa
    annotation (Placement(transformation(extent={{-80,-86},{-60,-66}})));
  inner IDEAS.SimInfoManager sim(redeclare
      IDEAS.Occupants.Extern.Interfaces.Occ_Files occupants)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
equation
  convectionTabs.Gc = 11*nakedTabs.FHChars.A_Floor;

  connect(heating.TSet, TOpSet.y) annotation (Line(
      points={{9.82,-22.36},{9.82,-50},{-17.4,-50}},
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
  connect(convectionTabs.fluid, dummyBuilding.heatPortEmb) annotation (Line(
      points={{-35,36},{-36,36},{-36,62},{-60,62}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.TSensor, heating.TSensor) annotation (Line(
      points={{-59.4,50},{-52,50},{-52,-18.4},{-8.36,-18.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convectionTabs.solid, nakedTabs1.port_a) annotation (Line(
      points={{-35,22},{-36,22},{-36,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs1.portCore, heating.heatPortEmb) annotation (Line(
      points={{-26,0},{-20,0},{-20,-2},{-12,-2},{-12,-7.6},{-8,-7.6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs1.port_b, convectionTabs.solid) annotation (Line(
      points={{-36,-9.8},{-36,-8},{-46,-8},{-46,16},{-35,16},{-35,22}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end IdealEmbeddedHeating;
