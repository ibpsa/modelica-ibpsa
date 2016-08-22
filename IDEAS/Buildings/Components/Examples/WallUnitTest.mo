within IDEAS.Buildings.Components.Examples;
model WallUnitTest "Unit test for verifying results for all wall components"
  extends Modelica.Icons.Example;
  BoundaryWall boundaryWall(
    redeclare Data.Constructions.CavityWall constructionType,
    insulationThickness=0.1,
    redeclare Data.Insulation.Rockwool insulationType,
    inc=IDEAS.Types.Tilt.Wall,
    azi=IDEAS.Types.Azimuth.S,
    AWall=2,
    use_T_in=true)
             "Boundary wall example"
    annotation (Placement(transformation(extent={{-36,60},{-26,80}})));
  InternalWall internalWall(
    inc=IDEAS.Types.Tilt.Wall,
    azi=IDEAS.Types.Azimuth.S,
    AWall=2,
    redeclare Data.Constructions.EpcSolidWall2 constructionType,
    redeclare Data.Insulation.Eps insulationType,
    insulationThickness=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
                             "Internal wall example"
    annotation (Placement(transformation(extent={{-36,20},{-24,40}})));
  OuterWall outerWall(
    inc=IDEAS.Types.Tilt.Wall,
    azi=IDEAS.Types.Azimuth.S,
    AWall=2,
    redeclare Data.Constructions.CavityWallPartialFill constructionType,
    redeclare Data.Insulation.Glasswool insulationType,
    insulationThickness=0.1)
    "Outer wall example"
    annotation (Placement(transformation(extent={{-36,-20},{-26,0}})));
  SlabOnGround slabOnGround(
    inc=IDEAS.Types.Tilt.Floor,
    azi=IDEAS.Types.Azimuth.S,
    AWall=2,
    redeclare Validation.Data.Constructions.HeavyFloor constructionType,
    redeclare Data.Insulation.Pur insulationType,
    insulationThickness=0.1)
             "Slab on ground example"
    annotation (Placement(transformation(extent={{-36,-60},{-26,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Tzone(T=293.15)
    "Fixed dummy zone temperature"
    annotation (Placement(transformation(extent={{80,60},{60,80}})));
protected
  Interfaces.ZoneBus propsBus_a1(numIncAndAziInBus=sim.numIncAndAziInBus, computeConservationOfEnergy=
       sim.computeConservationOfEnergy)                          "If inc = Floor, then propsbus_a should be connected to the zone above this floor.
    If inc = ceiling, then propsbus_a should be connected to the zone below this ceiling.
    If component is an outerWall, porpsBus_a should be connect to the zone."
    annotation (Placement(transformation(extent={{-10,48},{30,88}})));
public
  inner BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
protected
  Interfaces.WeaBus weaBus1(numSolBus=sim.numIncAndAziInBus)
    annotation (Placement(transformation(extent={{-2,88},{18,108}})));
public
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Tzone1(T=293.15)
    "Fixed dummy zone temperature"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
protected
  Interfaces.ZoneBus propsBus_a2(numIncAndAziInBus=sim.numIncAndAziInBus, computeConservationOfEnergy=
       sim.computeConservationOfEnergy)                          "If inc = Floor, then propsbus_a should be connected to the zone above this floor.
    If inc = ceiling, then propsbus_a should be connected to the zone below this ceiling.
    If component is an outerWall, porpsBus_a should be connect to the zone."
    annotation (Placement(transformation(extent={{-10,8},{30,48}})));
public
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Tzone2(T=293.15)
    "Fixed dummy zone temperature"
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));
protected
  Interfaces.ZoneBus propsBus_a3(numIncAndAziInBus=sim.numIncAndAziInBus, computeConservationOfEnergy=
       sim.computeConservationOfEnergy)                          "If inc = Floor, then propsbus_a should be connected to the zone above this floor.
    If inc = ceiling, then propsbus_a should be connected to the zone below this ceiling.
    If component is an outerWall, porpsBus_a should be connect to the zone."
    annotation (Placement(transformation(extent={{-10,-32},{30,8}})));
public
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Tzone3(T=293.15)
    "Fixed dummy zone temperature"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
protected
  Interfaces.ZoneBus propsBus_a4(numIncAndAziInBus=sim.numIncAndAziInBus, computeConservationOfEnergy=
       sim.computeConservationOfEnergy)                          "If inc = Floor, then propsbus_a should be connected to the zone above this floor.
    If inc = ceiling, then propsbus_a should be connected to the zone below this ceiling.
    If component is an outerWall, porpsBus_a should be connect to the zone."
    annotation (Placement(transformation(extent={{-10,-72},{30,-32}})));
public
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature Tzone4(T=296.15)
    "Fixed dummy zone temperature"
    annotation (Placement(transformation(extent={{-100,22},{-80,42}})));
protected
  Interfaces.ZoneBus propsBus_a5(numIncAndAziInBus=sim.numIncAndAziInBus, computeConservationOfEnergy=
       sim.computeConservationOfEnergy)                          "If inc = Floor, then propsbus_a should be connected to the zone above this floor.
    If inc = ceiling, then propsbus_a should be connected to the zone below this ceiling.
    If component is an outerWall, porpsBus_a should be connect to the zone."
    annotation (Placement(transformation(extent={{-40,12},{-80,52}})));
public
  Modelica.Blocks.Sources.Constant Tconst(k=300)
    "Constant temperature boundary condition"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(boundaryWall.propsBus_a, propsBus_a1) annotation (Line(
      points={{-26,72},{10,72},{10,68}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone.port, propsBus_a1.surfCon) annotation (Line(points={{60,70},{10.1,
          70},{10.1,68.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone.port, propsBus_a1.surfRad) annotation (Line(points={{60,70},{10.1,
          70},{10.1,68.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone.port, propsBus_a1.iSolDir) annotation (Line(points={{60,70},{10.1,
          70},{10.1,68.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone.port, propsBus_a1.iSolDif) annotation (Line(points={{60,70},{10.1,
          70},{10.1,68.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(sim.weaBus, weaBus1) annotation (Line(
      points={{-84,92.8},{-60,92.8},{-60,98},{8,98}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus1, propsBus_a1.weaBus) annotation (Line(
      points={{8,98},{8,68.1},{10.1,68.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(Tzone1.port, propsBus_a2.surfCon) annotation (Line(points={{60,30},{10.1,
          30},{10.1,28.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone1.port, propsBus_a2.surfRad) annotation (Line(points={{60,30},{10.1,
          30},{10.1,28.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone1.port, propsBus_a2.iSolDir) annotation (Line(points={{60,30},{10.1,
          30},{10.1,28.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone1.port, propsBus_a2.iSolDif) annotation (Line(points={{60,30},{10.1,
          30},{10.1,28.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone2.port, propsBus_a3.surfCon) annotation (Line(points={{60,-10},{10.1,
          -10},{10.1,-11.9}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone2.port, propsBus_a3.surfRad) annotation (Line(points={{60,-10},{10.1,
          -10},{10.1,-11.9}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone2.port, propsBus_a3.iSolDir) annotation (Line(points={{60,-10},{10.1,
          -10},{10.1,-11.9}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone2.port, propsBus_a3.iSolDif) annotation (Line(points={{60,-10},{10.1,
          -10},{10.1,-11.9}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone3.port, propsBus_a4.surfCon) annotation (Line(points={{60,-50},{10.1,
          -50},{10.1,-51.9}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone3.port, propsBus_a4.surfRad) annotation (Line(points={{60,-50},{10.1,
          -50},{10.1,-51.9}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone3.port, propsBus_a4.iSolDir) annotation (Line(points={{60,-50},{10.1,
          -50},{10.1,-51.9}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone3.port, propsBus_a4.iSolDif) annotation (Line(points={{60,-50},{10.1,
          -50},{10.1,-51.9}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(internalWall.propsBus_a, propsBus_a2) annotation (Line(
      points={{-25,32},{10,32},{10,28}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(outerWall.propsBus_a, propsBus_a3) annotation (Line(
      points={{-26,-8},{10,-8},{10,-12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(slabOnGround.propsBus_a, propsBus_a4) annotation (Line(
      points={{-26,-48},{10,-48},{10,-52}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus1, propsBus_a2.weaBus) annotation (Line(
      points={{8,98},{8,98},{8,28.1},{10.1,28.1}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus1, propsBus_a3.weaBus) annotation (Line(
      points={{8,98},{8,98},{8,-11.9},{10.1,-11.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus1, propsBus_a4.weaBus) annotation (Line(
      points={{8,98},{8,-51.9},{10.1,-51.9}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(Tzone4.port, propsBus_a5.surfCon) annotation (Line(points={{-80,32},{-60.1,
          32},{-60.1,32.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone4.port, propsBus_a5.surfRad) annotation (Line(points={{-80,32},{-60.1,
          32},{-60.1,32.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone4.port, propsBus_a5.iSolDir) annotation (Line(points={{-80,32},{-60.1,
          32},{-60.1,32.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tzone4.port, propsBus_a5.iSolDif) annotation (Line(points={{-80,32},{-60.1,
          32},{-60.1,32.1}}, color={191,0,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(propsBus_a5, internalWall.propsBus_b) annotation (Line(
      points={{-60,32},{-56,32},{-35,32}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus_a5.weaBus, weaBus1) annotation (Line(
      points={{-60.1,32.1},{-60.1,98},{8,98}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=1,
      extent={{6,3},{6,3}}));
  connect(Tconst.y, boundaryWall.T) annotation (Line(points={{-59,70},{-48,70},{
          -48,72},{-41.4,72}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1e+06),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Buildings/Components/Examples/WallUnitTest.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example contains an instance of each opaque surface model. 
They are not connected to a zone such that a change in any of 
these models can easily be attributed to a single model in the unit tests. 
For windows see other examples.
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end WallUnitTest;
