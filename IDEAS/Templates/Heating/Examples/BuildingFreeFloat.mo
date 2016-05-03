within IDEAS.Templates.Heating.Examples;
model BuildingFreeFloat "Dummy building without heating"
  import IDEAS;

  extends Modelica.Icons.Example;
  final parameter Integer  nZones = 2 "Number of zones";

  DummyBuilding dummyBuilding(nZones=nZones, nEmb=2)
    annotation (Placement(transformation(extent={{-74,-10},{-44,10}})));
  inner SimInfoManager sim
    annotation (Placement(transformation(extent={{-90,74},{-70,94}})));
  IDEAS.Templates.Ventilation.None none(nZones=nZones, VZones=ones(nZones) .*
        36) annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  IDEAS.Templates.Interfaces.BaseClasses.CausalInhomeFeeder causalInhomeFeeder
    annotation (Placement(transformation(extent={{54,0},{74,20}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={96,-20})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{86,-70},{106,-50}})));
equation
  connect(dummyBuilding.TSensor,none. TSensor) annotation (Line(
      points={{-43.4,-6},{-36,-6},{-36,54},{-10.2,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyBuilding.flowPort_In,none. flowPort_Out) annotation (Line(
      points={{-57,10},{-56,10},{-56,60},{-10,60},{-10,58}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.flowPort_Out,none. flowPort_In) annotation (Line(
      points={{-61,10},{-60,10},{-60,64},{-10,64},{-10,62}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(none.plugLoad,causalInhomeFeeder. nodeSingle) annotation (Line(
      points={{10,60},{42,60},{42,10},{54,10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(causalInhomeFeeder.pinSingle,voltageSource. pin_n) annotation (Line(
      points={{74,10},{96,10},{96,-10}},
      color={85,170,255},
      smooth=Smooth.None));
    connect(voltageSource.pin_p,ground. pin) annotation (Line(
        points={{96,-30},{96,-50}},
        color={85,170,255},
        smooth=Smooth.None));
end BuildingFreeFloat;
