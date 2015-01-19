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
    redeclare IDEAS.Fluid.Production.HP_AirWater_TSet heater,
    each RadSlaCha = radSlaCha_ValidationEmpa,
    QNom={8000 for i in 1:nZones},
    TSupNom=273.15 + 45,
    corFac_val=5,
    AEmb=building.AZones,
    nLoads=0)
          annotation (Placement(transformation(extent={{12,-16},{50,2}})));
  IDEAS.HeatingSystems.Examples.DummyBuilding building(nZones=nZones,
    AZones=ones(nZones)*40,
    VZones=building.AZones*3,
    UA_building=150,
    nEmb=nZones)
    annotation (Placement(transformation(extent={{-96,-16},{-64,4}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-48,0})));
  IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.NakedTabs[nZones] nakedTabs(radSlaCha=
       radSlaCha_ValidationEmpa, A_floor=building.AZones)
    annotation (Placement(transformation(extent={{-6,-12},{-26,8}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.RealExpression[nZones] realExpression(y=11*
        building.AZones)
    annotation (Placement(transformation(extent={{-20,30},{-40,50}})));
  IDEAS.VentilationSystems.None none(nZones=nZones, VZones=building.VZones)
    annotation (Placement(transformation(extent={{-42,64},{-22,84}})));
  IDEAS.Occupants.Standards.ISO13790 occ(
    nZones=building.nZones,
    nLoads=0,
    AFloor=building.AZones)
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
equation
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
  connect(building.heatPortEmb, convectionTabs.fluid) annotation (Line(
      points={{-64,0},{-56,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, heating.TSensor) annotation (Line(
      points={{-63.36,-12},{-58,-12},{-58,-28},{0,-28},{0,-12.4},{11.62,-12.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, convectionTabs.Gc) annotation (Line(
      points={{-41,40},{-48,40},{-48,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(building.TSensor,none. TSensor) annotation (Line(
      points={{-63.36,-12},{-58,-12},{-58,68},{-42.4,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(none.flowPort_Out, building.flowPort_In) annotation (Line(
      points={{-42,72},{-77.8667,72},{-77.8667,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(none.flowPort_In, building.flowPort_Out) annotation (Line(
      points={{-42,76},{-82.1333,76},{-82.1333,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(heating.heatPortCon, building.heatPortCon) annotation (Line(
      points={{12,-5.2},{6,-5.2},{6,-6},{-6,-6},{-6,-20},{-56,-20},{-56,-4},{
          -64,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating.heatPortRad, building.heatPortRad) annotation (Line(
      points={{12,-8.8},{4,-8.8},{4,-8},{-4,-8},{-4,-22},{-58,-22},{-58,-8},{
          -64,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(occ.TSet, heating.TSet) annotation (Line(
      points={{30,-40},{31,-40},{31,-16.18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.mDHW60C, heating.mDHW60C) annotation (Line(
      points={{36,-40},{36,-16.18},{36.7,-16.18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.heatPortRad, building.heatPortRad) annotation (Line(
      points={{20,-52},{-64,-52},{-64,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(occ.heatPortCon, building.heatPortCon) annotation (Line(
      points={{20,-48},{-60,-48},{-60,-4},{-64,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end Heating_Embedded;
