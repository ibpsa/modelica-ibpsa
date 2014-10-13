within IDEAS.HeatingSystems.Examples;
model Heating_Embedded
  "Example and test for heating system with embedded emission"
  import IDEAS;
  extends Modelica.Icons.Example;
  final parameter Integer nZones=2 "Number of zones";
  parameter
    IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.RadSlaCha_ValidationEmpa[        nZones]
                                       radSlaCha_ValidationEmpa
    annotation (Placement(transformation(extent={{-94,-98},{-74,-78}})));
  IDEAS.HeatingSystems.Heating_Embedded     heating(
    nZones=nZones,
    dTSupRetNom=5,
    redeclare IDEAS.Fluid.Production.HP_AirWater heater,
    each RadSlaCha = radSlaCha_ValidationEmpa,
    QNom={8000 for i in 1:nZones},
    TSupNom=273.15 + 45,
    corFac_val=5,
    AEmb=dummyBuilding.AZones,
    use_DHW=false)
          annotation (Placement(transformation(extent={{12,-16},{50,2}})));
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
  IDEAS.HeatingSystems.Examples.DummyBuilding dummyBuilding(nZones=nZones,
    AZones=ones(nZones)*40,
    VZones=dummyBuilding.AZones*3,
    UA_building=150,
    nEmb=nZones)
    annotation (Placement(transformation(extent={{-96,-16},{-64,4}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-48,0})));
  IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.NakedTabs[nZones] nakedTabs(radSlaCha=
       radSlaCha_ValidationEmpa, A_floor=dummyBuilding.AZones)
    annotation (Placement(transformation(extent={{-6,-12},{-26,8}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.RealExpression[nZones] realExpression(y=11*
        dummyBuilding.AZones)
    annotation (Placement(transformation(extent={{-20,30},{-40,50}})));
  IDEAS.VentilationSystems.None none(nZones=nZones, VZones=dummyBuilding.VZones)
    annotation (Placement(transformation(extent={{-42,64},{-22,84}})));
equation
  connect(heating.TSet, TOpSet.y) annotation (Line(
      points={{30.81,-16.36},{30.81,-50},{21,-50}},
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
      points={{50,-7},{52,-7},{52,-10},{64,-10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{12,-1.6},{1.5,-1.6},{1.5,-2},{-6,-2}},
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
      points={{-63.36,-12},{-58,-12},{-58,-28},{0,-28},{0,-12.4},{11.62,-12.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, convectionTabs.Gc) annotation (Line(
      points={{-41,40},{-48,40},{-48,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dummyBuilding.TSensor,none. TSensor) annotation (Line(
      points={{-63.36,-12},{-58,-12},{-58,68},{-42.4,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(none.flowPort_Out, dummyBuilding.flowPort_In) annotation (Line(
      points={{-42,72},{-77.8667,72},{-77.8667,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(none.flowPort_In, dummyBuilding.flowPort_Out) annotation (Line(
      points={{-42,76},{-82.1333,76},{-82.1333,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(none.plugLoad, dummyInHomeGrid.nodeSingle) annotation (Line(
      points={{-22,74},{56,74},{56,-10},{64,-10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.heatPortCon, dummyBuilding.heatPortCon) annotation (Line(
      points={{12,-5.2},{6,-5.2},{6,-6},{-6,-6},{-6,-20},{-56,-20},{-56,-4},{
          -64,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating.heatPortRad, dummyBuilding.heatPortRad) annotation (Line(
      points={{12,-8.8},{4,-8.8},{4,-8},{-4,-8},{-4,-22},{-58,-22},{-58,-8},{
          -64,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end Heating_Embedded;
