within IDEAS.Templates.Heating.Examples;
model Heating_Embedded
  "Example and test for heating system with embedded emission"
  extends Modelica.Icons.Example;
  final parameter Integer nZones=2 "Number of zones";
  parameter
    IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.RadSlaCha_ValidationEmpa[        nZones]
                                       radSlaCha_ValidationEmpa
    annotation (Placement(transformation(extent={{-94,-98},{-74,-78}})));
  replaceable
  IDEAS.Templates.Heating.Heating_Embedded heating(
    nZones=nZones,
    dTSupRetNom=5,
    redeclare IDEAS.Fluid.Production.HP_AirWater_TSet heater,
    each RadSlaCha=radSlaCha_ValidationEmpa,
    QNom={8000 for i in 1:nZones},
    Q_design=heating.QNom,
    TSupNom=273.15 + 45,
    corFac_val=5,
    AEmb=building.AZones,
    nLoads=0,
    InInterface=false)
              annotation (Placement(transformation(extent={{20,-20},{60,0}})));
  IDEAS.Templates.Heating.Examples.DummyBuilding building(
    nZones=nZones,
    AZones=ones(nZones)*40,
    VZones=building.AZones*3,
    UA_building=150,
    nEmb=nZones)
    annotation (Placement(transformation(extent={{-100,-20},{-68,0}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-48,0})));
  IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.NakedTabs[nZones] nakedTabs(radSlaCha=
       radSlaCha_ValidationEmpa, A_floor=building.AZones)
    annotation (Placement(transformation(extent={{-6,-12},{-26,8}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.RealExpression[nZones] hA(y=11*building.AZones)
    "Combined heat transfer coefficient"
    annotation (Placement(transformation(extent={{-20,14},{-40,34}})));
  IDEAS.Templates.Ventilation.None none(nZones=nZones, VZones=building.VZones)
    annotation (Placement(transformation(extent={{20,40},{60,60}})));
  IDEAS.BoundaryConditions.Occupants.Standards.ISO13790 occ(
    nZones=building.nZones,
    nLoads=0,
    AFloor=building.AZones)
    annotation (Placement(transformation(extent={{20,-60},{60,-40}})));
equation
  connect(heating.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{20,-4},{1.5,-4},{1.5,-2},{-6,-2}},
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
      points={{-68,-4},{-60,-4},{-60,0},{-56,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(hA.y, convectionTabs.Gc) annotation (Line(
      points={{-41,24},{-48,24},{-48,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(building.TSensor,none. TSensor) annotation (Line(
      points={{-67.36,-16},{-58,-16},{-58,44},{19.6,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(none.port_b, building.port_a) annotation (Line(
      points={{20,48},{-81.8667,48},{-81.8667,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(none.port_a, building.port_b) annotation (Line(
      points={{20,52},{-86.1333,52},{-86.1333,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(heating.heatPortCon, building.heatPortCon) annotation (Line(
      points={{20,-8},{6,-8},{6,-6},{-6,-6},{-6,-20},{-56,-20},{-56,-8},{-68,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating.heatPortRad, building.heatPortRad) annotation (Line(
      points={{20,-12},{4,-12},{4,-8},{-4,-8},{-4,-22},{-58,-22},{-58,-12},{-68,
          -12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(occ.TSet, heating.TSet) annotation (Line(
      points={{40,-40},{40,-20.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.mDHW60C, heating.mDHW60C) annotation (Line(
      points={{46,-40},{46,-20.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occ.heatPortRad, building.heatPortRad) annotation (Line(
      points={{20,-52},{-68,-52},{-68,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(occ.heatPortCon, building.heatPortCon) annotation (Line(
      points={{20,-48},{-60,-48},{-60,-8},{-68,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, heating.TSensor) annotation (Line(points={{-67.36,
          -16},{19.6,-16},{19.6,-16}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput,Documentation(info="<html>
    <p>Model demonstrating the use of the embedded heating system template.</p>
    </html>", revisions="<html>
    <ul>
    <li>
    January 23, 2017 by Glenn Reynders:<br/>
    Revised
    </li>
    </ul>
    </html>"),
    __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Templates/Heating/Examples/Heating_Embedded.mos"
        "Simulate and Plot"));
end Heating_Embedded;
