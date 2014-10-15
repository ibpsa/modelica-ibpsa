within IDEAS.HeatingSystems.Examples;
model Heating_Radiators
  "Example and test for basic heating system with radiators"
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  extends Modelica.Icons.Example;
  final parameter Integer nZones=1 "Number of zones";
  IDEAS.HeatingSystems.Heating_Radiators heating(
    redeclare package Medium = Medium,
      nZones=nZones,
     dTSupRetNom=10,
     redeclare IDEAS.Fluid.Production.Boiler heater,
    corFac_val=7,
    TSupNom=273.15 + 55,
    nLoads=0,
    QNom={100000 for i in 1:nZones})
    annotation (Placement(transformation(extent={{-8,-22},{28,-4}})));
  IDEAS.HeatingSystems.Examples.DummyBuilding building(nZones=nZones, nEmb=0)
    annotation (Placement(transformation(extent={{-78,-22},{-48,-2}})));
  inner SimInfoManager       sim
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{64,84},{78,94}})));
  VentilationSystems.None       none(nZones=nZones, VZones=building.VZones)
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Occupants.Standards.ISO13790 occ(
    nZones=building.nZones,
    AFloor=building.AZones,
    nLoads=0) annotation (Placement(transformation(extent={{0,-54},{20,-34}})));
equation
  connect(building.heatPortCon, heating.heatPortCon) annotation (Line(
      points={{-48,-10},{-28,-10},{-28,-11.2},{-8,-11.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortRad, heating.heatPortRad) annotation (Line(
      points={{-48,-14},{-28,-14},{-28,-14.8},{-8,-14.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, heating.TSensor) annotation (Line(
      points={{-47.4,-18},{-28,-18},{-28,-18.4},{-8.36,-18.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(none.flowPort_In, building.flowPort_Out) annotation (Line(
      points={{-20,42},{-65,42},{-65,-2}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(none.flowPort_Out, building.flowPort_In) annotation (Line(
      points={{-20,38},{-61,38},{-61,-2}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(building.TSensor,none. TSensor) annotation (Line(
      points={{-47.4,-18},{-42,-18},{-42,34},{-20.4,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.TSet, heating.TSet) annotation (Line(
      points={{10,-34},{10,-22.18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.mDHW60C, heating.mDHW60C) annotation (Line(
      points={{16,-34},{16,-22.18},{15.4,-22.18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.heatPortRad, building.heatPortRad) annotation (Line(
      points={{0,-46},{-32,-46},{-32,-14},{-48,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(occ.heatPortCon, building.heatPortCon) annotation (Line(
      points={{0,-42},{-10,-42},{-10,-40},{-30,-40},{-30,-10},{-48,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end Heating_Radiators;
