within IDEAS.HeatingSystems.Examples;
model IdealRadiatorHeating "Example and test for ideal heating with radiators"
  import IDEAS;
  extends Modelica.Icons.Example;
  final parameter Integer nZones = 1 "Number of zones";
  IDEAS.HeatingSystems.IdealRadiatorHeating heating(
    final nZones=nZones,
    VZones={75*2.7 for i in 1:nZones},
    QNom={20000 for i in 1:nZones},
    t=1) annotation (Placement(transformation(extent={{-16,-10},{22,12}})));
  Modelica.Blocks.Sources.Pulse[nZones] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289)
    annotation (Placement(transformation(extent={{-36,-56},{-24,-44}})));
  inner IDEAS.SimInfoManager sim(redeclare
      IDEAS.Occupants.Extern.Interfaces.Occ_Files occupants)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={86,-54})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{76,-92},{96,-72}})));
  IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder dummyInHomeGrid
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  IDEAS.HeatingSystems.Examples.DummyBuilding dummyBuilding(nZones=nZones)
    annotation (Placement(transformation(extent={{-86,-10},{-52,12}})));
equation
  connect(TOpSet.y, heating.TSet) annotation (Line(
      points={{-23.4,-50},{2.81,-50},{2.81,-10.44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyBuilding.heatPortCon, heating.heatPortCon) annotation (Line(
      points={{-52,3.2},{-16,3.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.heatPortRad, heating.heatPortRad) annotation (Line(
      points={{-52,-1.2},{-16,-1.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.TSensor, heating.TSensor) annotation (Line(
      points={{-51.32,-5.6},{-16.38,-5.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(voltageSource.pin_p,ground. pin) annotation (Line(
      points={{86,-64},{86,-72}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(dummyInHomeGrid.pinSingle,voltageSource. pin_n) annotation (Line(
      points={{80,0},{86,0},{86,-44}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.plugLoad,dummyInHomeGrid. nodeSingle) annotation (Line(
      points={{22,1},{48,1},{48,0},{60,0}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end IdealRadiatorHeating;
