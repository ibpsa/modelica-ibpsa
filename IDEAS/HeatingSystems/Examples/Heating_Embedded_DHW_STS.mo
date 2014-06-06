within IDEAS.HeatingSystems.Examples;
model Heating_Embedded_DHW_STS
  "Example and test for heating system with embedded emission, DHW and STS"
  import IDEAS;
  extends Modelica.Icons.Example;
  final parameter Integer nZones=2 "Number of zones";
  parameter
    IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.RadSlaCha_ValidationEmpa[        nZones]
                                       radSlaCha_ValidationEmpa(A_Floor=
        dummyBuilding.AZones)
    annotation (Placement(transformation(extent={{-94,-98},{-74,-78}})));
  IDEAS.HeatingSystems.Heating_Embedded_DHW_STS
                                            heating(
    nZones=nZones,
    dTSupRetNom=5,
    redeclare IDEAS.Fluid.Production.HP_AirWater heater,
    each RadSlaCha = radSlaCha_ValidationEmpa,
    QNom={8000 for i in 1:nZones},
    TSupNom=273.15 + 45,
    corFac_val=5)
          annotation (Placement(transformation(extent={{12,-18},{50,0}})));
  Modelica.Blocks.Sources.Pulse[nZones] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289,
    startTime={3600*7,3600*9})
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
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
  IDEAS.HeatingSystems.Examples.DummyBuilding dummyBuilding(nZones=nZones,
    AZones=ones(nZones)*40,
    VZones=dummyBuilding.AZones*3,
    UA_building=150)
    annotation (Placement(transformation(extent={{-96,-16},{-64,4}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-48,0})));
  IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.NakedTabs[nZones] nakedTabs(radSlaCha=
       radSlaCha_ValidationEmpa)
    annotation (Placement(transformation(extent={{-6,-12},{-26,8}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.RealExpression[nZones] realExpression(y=11*
        radSlaCha_ValidationEmpa.A_Floor)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{64,84},{78,94}})));
equation
  connect(voltageSource.pin_p, ground.pin) annotation (Line(
      points={{90,-74},{90,-82}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(dummyInHomeGrid.pinSingle, voltageSource.pin_n) annotation (Line(
      points={{84,-10},{90,-10},{90,-54}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.plugLoad, dummyInHomeGrid.nodeSingle) annotation (Line(
      points={{50,-9},{52,-9},{52,-10},{64,-10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{12,-3.6},{1.5,-3.6},{1.5,-2},{-6,-2}},
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
      points={{-63.36,-12},{-58,-12},{-58,-28},{0,-28},{0,-14.4},{11.62,-14.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, convectionTabs.Gc) annotation (Line(
      points={{-59,40},{-48,40},{-48,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOpSet.y, heating.TSet) annotation (Line(
      points={{1,-50},{30.81,-50},{30.81,-18.36}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end Heating_Embedded_DHW_STS;
