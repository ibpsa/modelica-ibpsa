within IDEAS.Buildings.Components.Examples;
model ZoneUnitTest "Unit test for zone model"
  extends Modelica.Icons.Example;
  package Medium = IDEAS.Media.Air;

  inner BoundaryConditions.SimInfoManager sim(computeConservationOfEnergy=true)
                                              "Data reader"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Zone                            zone(
    redeclare package Medium = Medium,
    allowFlowReversal=true,
    V=20,
    nSurf=2)
          "First zone"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Interfaces.ZoneBus propsBus1[2](each numIncAndAziInBus=sim.numIncAndAziInBus,
      each computeConservationOfEnergy=sim.computeConservationOfEnergy)
    annotation (Placement(transformation(extent={{8,-26},{48,14}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor(R=0.002)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor1(R=0.001)
    annotation (Placement(transformation(extent={{-40,-2},{-20,18}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                         fixedTemperature1
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=290)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Modelica.Blocks.Sources.Constant A(k=10)
    annotation (Placement(transformation(extent={{-58,72},{-38,92}})));
  Modelica.Blocks.Sources.Constant eps(k=0.9)
    annotation (Placement(transformation(extent={{-58,38},{-38,58}})));
  Modelica.Blocks.Sources.Constant angles(k=0)
    annotation (Placement(transformation(extent={{80,60},{60,80}})));
  Interfaces.WeaBus weaBus1(numSolBus=sim.numIncAndAziInBus, outputAngles=sim.outputAngles)
    annotation (Placement(transformation(extent={{-90,28},{-70,48}})));
  Modelica.Blocks.Sources.Constant power(k=0)
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
equation
  connect(zone.propsBus, propsBus1) annotation (Line(
      points={{60,-6},{44,-6},{28,-6}},
      color={255,204,51},
      thickness=0.5));
  connect(thermalResistor.port_b, propsBus1[1].surfCon) annotation (Line(points=
         {{-20,-30},{-8,-30},{0,-30},{0,-5.95},{28.1,-5.95}}, color={191,0,0}));
  connect(thermalResistor1.port_b, propsBus1[2].surfCon)
    annotation (Line(points={{-20,8},{28.1,8},{28.1,-5.85}}, color={191,0,0}));
  connect(thermalResistor.port_a, fixedTemperature1.port)
    annotation (Line(points={{-40,-30},{-80,-30}},           color={191,0,0}));
  connect(thermalResistor.port_a, thermalResistor1.port_a)
    annotation (Line(points={{-40,-30},{-40,8},{-40,8}}, color={191,0,0}));
  connect(fixedTemperature1.port, propsBus1[1].surfRad) annotation (Line(points={{-80,-30},
          {-80,-30},{-64,-30},{-64,-6},{28.1,-6},{28.1,-5.95}},
                                                        color={191,0,0}));
  connect(fixedTemperature.port, propsBus1[2].surfRad) annotation (Line(points={{-80,10},
          {-64,10},{-64,-4},{28.1,-4},{28.1,-5.85}},          color={191,0,0}));
  connect(A.y, propsBus1[1].area) annotation (Line(points={{-37,82},{28.1,82},{28.1,
          -5.95}}, color={0,0,127}));
  connect(A.y, propsBus1[2].area) annotation (Line(points={{-37,82},{28.1,82},{28.1,
          -5.85}}, color={0,0,127}));
  connect(eps.y, propsBus1[1].epsLw) annotation (Line(points={{-37,48},{28.1,48},
          {28.1,-5.95}}, color={0,0,127}));
  connect(eps.y, propsBus1[2].epsLw) annotation (Line(points={{-37,48},{28.1,48},
          {28.1,-5.85}}, color={0,0,127}));
  connect(eps.y, propsBus1[1].epsSw) annotation (Line(points={{-37,48},{28.1,48},
          {28.1,-5.95}}, color={0,0,127}));
  connect(eps.y, propsBus1[2].epsSw) annotation (Line(points={{-37,48},{28.1,48},
          {28.1,-5.85}}, color={0,0,127}));
  connect(angles.y, propsBus1[1].inc) annotation (Line(points={{59,70},{46,70},{
          28.1,70},{28.1,-5.95}}, color={0,0,127}));
  connect(angles.y, propsBus1[2].inc) annotation (Line(points={{59,70},{28.1,70},
          {28.1,-5.85}}, color={0,0,127}));
  connect(angles.y, propsBus1[1].azi) annotation (Line(points={{59,70},{28.1,70},
          {28.1,-5.95}}, color={0,0,127}));
  connect(angles.y, propsBus1[2].azi) annotation (Line(points={{59,70},{28.1,70},
          {28.1,-5.85}}, color={0,0,127}));
  connect(power.y, propsBus1[1].QTra_design) annotation (Line(points={{59,30},{
          28,30},{28,-5.95},{28.1,-5.95}}, color={0,0,127}));
  connect(power.y, propsBus1[2].QTra_design) annotation (Line(points={{59,30},{
          28.1,30},{28.1,-5.85}}, color={0,0,127}));
  connect(sim.weaBus, weaBus1) annotation (Line(
      points={{-84,92.8},{-76,92.8},{-76,92},{-76,38},{-80,38}},
      color={255,204,51},
      thickness=0.5));
  connect(fixedTemperature1.T, weaBus1.Te) annotation (Line(points={{-102,-30},
          {-126,-30},{-126,38.05},{-79.95,38.05}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1000),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Components/Examples/ZoneUnitTest.mos"
        "Simulate and plot"));
end ZoneUnitTest;
