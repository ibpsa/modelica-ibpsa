within IDEAS.Templates.Heating.Examples;
model Heating_Radiators
  "Example and test for basic heating system with radiators"
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  extends Modelica.Icons.Example;
  final parameter Integer nZones=1 "Number of zones";
  IDEAS.Templates.Heating.Heating_Radiators heating(
    redeclare package Medium = Medium,
    nZones=nZones,
    dTSupRetNom=10,
    Q_design=heating.QNom,
    redeclare IDEAS.Fluid.Production.Boiler heater,
    corFac_val=7,
    TSupNom=273.15 + 55,
    nLoads=0,
    QNom={100000 for i in 1:nZones})
    annotation (Placement(transformation(extent={{0,-20},{40,0}})));
  IDEAS.Templates.Heating.Examples.DummyBuilding building(nZones=nZones, nEmb=0)
    annotation (Placement(transformation(extent={{-78,-20},{-48,0}})));
  inner IDEAS.BoundaryConditions.SimInfoManager       sim
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Templates.Ventilation.None none(nZones=nZones, VZones=building.VZones)
    annotation (Placement(transformation(extent={{0,20},{40,40}})));
  IDEAS.BoundaryConditions.Occupants.Standards.ISO13790 occ(
    nZones=building.nZones,
    AFloor=building.AZones,
    nLoads=0) annotation (Placement(transformation(extent={{0,-60},{40,-40}})));
equation
  connect(building.heatPortCon, heating.heatPortCon) annotation (Line(
      points={{-48,-8},{0,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortRad, heating.heatPortRad) annotation (Line(
      points={{-48,-12},{0,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, heating.TSensor) annotation (Line(
      points={{-47.4,-16},{-0.4,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(none.port_a, building.port_b) annotation (Line(
      points={{0,32},{-65,32},{-65,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(none.port_b, building.port_a) annotation (Line(
      points={{0,28},{-61,28},{-61,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(building.TSensor,none. TSensor) annotation (Line(
      points={{-47.4,-16},{-42,-16},{-42,24},{-0.4,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.TSet, heating.TSet) annotation (Line(
      points={{20,-40},{20,-20.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.mDHW60C, heating.mDHW60C) annotation (Line(
      points={{26,-40},{26,-20.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.heatPortRad, building.heatPortRad) annotation (Line(
      points={{0,-52},{-32,-52},{-32,-12},{-48,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(occ.heatPortCon, building.heatPortCon) annotation (Line(
      points={{0,-48},{-30,-48},{-30,-40},{-30,-40},{-30,-8},{-48,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
    <p>Model demonstrating the use of the radiator heating system template.</p>
    </html>", revisions="<html>
    <ul>
    <li>
    January 23, 2017 by Glenn Reynders:<br/>
    Revised
    </li>
    </ul>
    </html>"),
    __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Templates/Heating/Examples/Heating_Radiators.mos"
        "Simulate and Plot"));
end Heating_Radiators;
