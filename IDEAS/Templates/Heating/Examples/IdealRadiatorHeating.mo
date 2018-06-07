within IDEAS.Templates.Heating.Examples;
model IdealRadiatorHeating "Example and test for ideal heating with radiators"
  extends Modelica.Icons.Example;
  final parameter Integer nZones = 1 "Number of zones";
  replaceable
  IDEAS.Templates.Heating.IdealRadiatorHeating heating(
    final nZones=nZones,
    QNom={20000 for i in 1:nZones},
    Q_design=building.Q_design)
    annotation (Placement(transformation(extent={{20,0},{60,22}})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  IDEAS.Templates.Heating.Examples.DummyBuilding building(nZones=nZones, nEmb=0,
    useFluPor=false)
    annotation (Placement(transformation(extent={{-54,0},{-20,22}})));

  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 22)
    "Temperature set point for zone"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
equation
  connect(building.heatPortCon, heating.heatPortCon) annotation (Line(
      points={{-20,13.2},{20,13.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.heatPortRad, heating.heatPortRad) annotation (Line(
      points={{-20,8.8},{20,8.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(building.TSensor, heating.TSensor) annotation (Line(
      points={{-19.32,4.4},{19.6,4.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, heating.TSet[1])
    annotation (Line(points={{21,-30},{40,-30},{40,-0.22}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
Model that demonstrates the use of the 
<a href=\"modelica://IDEAS.Templates.Heating.IdealRadiatorHeating\">
IDEAS.Templates.Heating.IdealRadiatorHeating</a>.
</p>
</html>",     revisions="<html>
<ul>
<li>
June 5, 2018 by Filip Jorissen:<br/>
Cleaned up implementation for
<a href=\"https://github.com/open-ideas/IDEAS/issues/821\">#821</a>.
</li>
<li>
January 23, 2017 by Glenn Reynders:<br/>
Revised
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Templates/Heating/Examples/IdealRadiatorHeating.mos"
        "Simulate and Plot"));
end IdealRadiatorHeating;
