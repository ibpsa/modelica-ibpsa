within IDEAS.HeatingSystems.Examples;
model Heating_Radiators
  "Example and test for basic heating system with radiators"
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  extends Modelica.Icons.Example;
  final parameter Integer nZones=1 "Number of zones";
  IDEAS.HeatingSystems.Heating_Radiators heating(
    redeclare package Medium = Medium,
      nZones=nZones,
     TSupNom=273.15 + 45,
     dTSupRetNom=10,
     redeclare IDEAS.Fluid.Production.Boiler heater,
    QNom={8000 for i in 1:nZones},
    corFac_val=5)
    annotation (Placement(transformation(extent={{-8,-22},{28,-4}})));
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
    annotation (Placement(transformation(extent={{-78,-24},{-48,-4}})));
  inner SimInfoManager       sim
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{64,84},{78,94}})));
equation
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
  connect(dummyBuilding.heatPortCon, heating.heatPortCon) annotation (Line(
      points={{-48,-12},{-28,-12},{-28,-11.2},{-8,-11.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.heatPortRad, heating.heatPortRad) annotation (Line(
      points={{-48,-16},{-28,-16},{-28,-14.8},{-8,-14.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.TSensor, heating.TSensor) annotation (Line(
      points={{-47.4,-20},{-28,-20},{-28,-18.4},{-8.36,-18.4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end Heating_Radiators;
