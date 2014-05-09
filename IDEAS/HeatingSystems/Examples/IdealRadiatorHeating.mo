within IDEAS.HeatingSystems.Examples;
model IdealRadiatorHeating "Example and test for ideal heating with radiators"
  import IDEAS;

  extends Modelica.Icons.Example;

  final parameter Integer nZones = 1 "Number of zones";

  IDEAS.HeatingSystems.IdealRadiatorHeating heating(
    final nZones=nZones,
    VZones={75*2.7 for i in 1:nZones},
    QNom={20000 for i in 1:nZones},
    t=1) annotation (Placement(transformation(extent={{-8,-22},{30,0}})));

  Modelica.Blocks.Sources.Pulse[nZones] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289)
    annotation (Placement(transformation(extent={{-36,-56},{-24,-44}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,-64})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground(pin(final reference))
    annotation (Placement(transformation(extent={{80,-102},{100,-82}})));
  IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder
                             dummyInHomeGrid
    annotation (Placement(transformation(extent={{62,-22},{84,0}})));
  IDEAS.HeatingSystems.Examples.DummyBuilding dummyBuilding(nZones=nZones)
    annotation (Placement(transformation(extent={{-72,-22},{-42,0}})));
  inner IDEAS.SimInfoManager sim(redeclare
      IDEAS.Occupants.Extern.Interfaces.Occ_Files occupants)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation

  connect(voltageSource.pin_p,ground. pin) annotation (Line(
      points={{90,-74},{90,-82}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(dummyInHomeGrid.pinSingle, voltageSource.pin_n) annotation (Line(
      points={{84,-11},{90,-11},{90,-54}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(dummyBuilding.heatPortCon, heating.heatPortCon) annotation (Line(
      points={{-42,-8.8},{-8,-8.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.heatPortRad, heating.heatPortRad) annotation (Line(
      points={{-42,-13.2},{-8,-13.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.TSensor, heating.TSensor) annotation (Line(
      points={{-41.4,-17.6},{-8.38,-17.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOpSet.y, heating.TSet) annotation (Line(
      points={{-23.4,-50},{10.81,-50},{10.81,-22.44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.plugLoad, dummyInHomeGrid.nodeSingle) annotation (Line(
      points={{30,-11},{62,-11}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end IdealRadiatorHeating;
