within IDEAS.Templates.Heating.Examples;
model IdealEmbeddedHeating
  "Example and test for ideal heating with embedded emission"
  import IDEAS;
  extends Modelica.Icons.Example;
  final parameter Integer nZones=1 "Number of zones";
  IDEAS.Templates.Heating.IdealEmbeddedHeating heating(
    nZones=nZones,
    QNom={20000 for i in 1:nZones},
    t=10,
    VZones=building.VZones)
    annotation (Placement(transformation(extent={{14,-22},{42,2}})));
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
  IDEAS.Templates.Interfaces.BaseClasses.CausalInhomeFeeder dummyInHomeGrid
    annotation (Placement(transformation(extent={{64,-20},{84,0}})));
  IDEAS.Templates.Heating.Examples.DummyBuilding building(nZones=nZones, nEmb=
        nZones)
    annotation (Placement(transformation(extent={{-96,-16},{-64,4}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-48,0})));
  IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.NakedTabs[nZones] nakedTabs(radSlaCha=
       radSlaCha_ValidationEmpa, A_floor=building.AZones)
    annotation (Placement(transformation(extent={{-6,-12},{-26,8}})));
  IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.RadSlaCha_ValidationEmpa[nZones]
                                       radSlaCha_ValidationEmpa
    annotation (Placement(transformation(extent={{-94,-98},{-74,-78}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.RealExpression[nZones] realExpression(y=11*
        building.AZones)
    annotation (Placement(transformation(extent={{-18,28},{-38,48}})));
  IDEAS.Templates.Ventilation.None none(nZones=nZones, VZones=building.VZones)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  IDEAS.Occupants.Standards.ISO13790 iSO13790_1(
    nZones=building.nZones,
    nLoads=0,
    AFloor=building.AZones)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
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
      points={{42,-10},{64,-10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{14,-2.8},{1.5,-2.8},{1.5,-2},{-6,-2}},
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
  connect(building.heatPortEmb, convectionTabs.fluid) annotation (Line(
      points={{-64,0},{-56,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, heating.TSensor) annotation (Line(
      points={{-63.36,-12},{-58,-12},{-58,-28},{0,-28},{0,-17.2},{13.72,-17.2}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(realExpression.y, convectionTabs.Gc) annotation (Line(
      points={{-39,38},{-48,38},{-48,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(none.flowPort_In, building.flowPort_Out) annotation (Line(
      points={{-40,72},{-82.1333,72},{-82.1333,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(none.flowPort_Out, building.flowPort_In) annotation (Line(
      points={{-40,68},{-77.8667,68},{-77.8667,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, none.TSensor) annotation (Line(
      points={{-63.36,-12},{-58,-12},{-58,64},{-40.2,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(none.plugLoad, dummyInHomeGrid.nodeSingle) annotation (Line(
      points={{-20,70},{30,70},{30,72},{60,72},{60,-10},{64,-10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(iSO13790_1.TSet, heating.TSet) annotation (Line(
      points={{30,-40},{30,-22.24},{28,-22.24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iSO13790_1.mDHW60C, heating.mDHW60C) annotation (Line(
      points={{33,-40},{34,-40},{34,-22.24},{32.2,-22.24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(iSO13790_1.heatPortRad, building.heatPortRad) annotation (Line(
      points={{20,-52},{-2,-52},{-2,-22},{-56,-22},{-56,-8},{-64,-8}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(iSO13790_1.heatPortCon, building.heatPortCon) annotation (Line(
      points={{20,-48},{-4,-48},{-4,-20},{-56,-20},{-56,-4},{-64,-4}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(iSO13790_1.plugLoad, dummyInHomeGrid.nodeSingle) annotation (Line(
      points={{40,-50},{60,-50},{60,-10},{64,-10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.heatPortRad, building.heatPortRad) annotation (Line(
      points={{14,-12.4},{-31,-12.4},{-31,-8},{-64,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating.heatPortCon, building.heatPortCon) annotation (Line(
      points={{14,-7.6},{-29,-7.6},{-29,-4},{-64,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end IdealEmbeddedHeating;
