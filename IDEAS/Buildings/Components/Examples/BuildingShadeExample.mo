within IDEAS.Buildings.Components.Examples;
model BuildingShadeExample
  extends Modelica.Icons.Example;
  Shading.BuildingShade buildingShade(
    azi=0,
    L=30,
    dh=10,
    hWin=1)
    annotation (Placement(transformation(extent={{-22,-20},{-12,0}})));
  inner SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,-12},{-80,8}})));
protected
  Interfaces.WeaBus                  weaBus(numSolBus=sim.numAzi + 1)
    annotation (Placement(transformation(extent={{-64,24},{-44,44}})));
public
  Shading.None none(azi=0)
    annotation (Placement(transformation(extent={{-22,6},{-12,26}})));
equation
  connect(sim.weaBus, weaBus) annotation (Line(
      points={{-88.6,5.2},{-88.6,34},{-54,34}},
      color={255,204,51},
      thickness=0.5));
  connect(buildingShade.solDir, weaBus.solBus[2].iSolDir) annotation (Line(points={{-22,-4},
          {-53.95,-4},{-53.95,34.05}},          color={0,0,127}));
  connect(buildingShade.solDif, weaBus.solBus[2].iSolDif) annotation (Line(points={{-22,-8},
          {-53.95,-8},{-53.95,34.05}},          color={0,0,127}));
  connect(buildingShade.angInc, weaBus.solBus[2].angInc) annotation (Line(points={{-22,-14},
          {-53.95,-14},{-53.95,34.05}},          color={0,0,127}));
  connect(buildingShade.angAzi, weaBus.solBus[2].angAzi) annotation (Line(points={{-22,-18},
          {-53.95,-18},{-53.95,34.05}},          color={0,0,127}));
  connect(buildingShade.angZen, weaBus.solBus[2].angZen) annotation (Line(points={{-22,-16},
          {-34,-16},{-53.95,-16},{-53.95,34.05}},          color={0,0,127}));
  connect(none.solDir, buildingShade.solDir) annotation (Line(points={{-22,22},{
          -38,22},{-38,-4},{-22,-4}}, color={0,0,127}));
  connect(none.solDif, buildingShade.solDif) annotation (Line(points={{-22,18},{
          -36,18},{-36,-8},{-22,-8}}, color={0,0,127}));
  connect(none.angInc, buildingShade.angInc) annotation (Line(points={{-22,12},{
          -28,12},{-34,12},{-34,-14},{-22,-14}}, color={0,0,127}));
  connect(none.angAzi, buildingShade.angAzi) annotation (Line(points={{-22,8},{-30,
          8},{-30,-18},{-22,-18}}, color={0,0,127}));
  connect(none.angZen, buildingShade.angZen) annotation (Line(points={{-22,10},{
          -32,10},{-32,-16},{-22,-16}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(
      StartTime=2e+06,
      StopTime=3e+06,
      __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Components/Examples/BuildingShadeExample.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
June 12, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model demonstrates the impact of the BuildingShade component on the solar radiation.
</p>
</html>"));
end BuildingShadeExample;
