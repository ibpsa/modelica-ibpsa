within IDEAS.Buildings.Components.BaseClasses.ConvectiveHeatTransfer.Examples;
model Convection "Convection model tests"
  extends Modelica.Icons.Example;

  MonoLayerAir monLayAirWal(
    A=10,
    inc=IDEAS.Types.Tilt.Wall,
    epsLw_a=0.9,
    epsLw_b=0.9,
    d=0.1) "Mono layer air model for vertical inclination"
    annotation (Placement(transformation(extent={{-20,12},{0,32}})));
  InteriorConvection intConVer(A=10, inc=IDEAS.Types.Tilt.Wall)
    "Interior convection block for vertical inclination"
    annotation (Placement(transformation(extent={{-20,82},{0,102}})));
  ExteriorConvection extCon(A=10) "Exterior convection block"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  inner BoundaryConditions.SimInfoManager sim "Data reader"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature block"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixTem(T=295.15)
    "Fixed temperature boundary condition corresponding to zone temperature"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  MonoLayerAir monLayAirHor(
    A=10,
    epsLw_a=0.9,
    epsLw_b=0.9,
    inc=IDEAS.Types.Tilt.Floor,
    d=0.1) "Mono layer air model for horizontal inclination"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Interfaces.WeaBus weaBus1(numSolBus=sim.numIncAndAziInBus)
    annotation (Placement(transformation(extent={{-80,82},{-60,102}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-20,
    duration=1e6,
    offset=305.15) "Input signal"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  InteriorConvection intConVerLin(
    A=10,
    inc=IDEAS.Types.Tilt.Wall,
    linearise=true)
    "Interior convection block for vertical inclination: linearised"
    annotation (Placement(transformation(extent={{-20,62},{0,82}})));
  InteriorConvection intConFlo(A=10, inc=IDEAS.Types.Tilt.Floor)
    "Interior convection block for floor inclination"
    annotation (Placement(transformation(extent={{-20,42},{0,62}})));
  ExteriorConvection extConLin(A=10, linearise=true)
    "Linearised exterior convection block"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  MonoLayerAir monLayAirHorLin(
    A=10,
    epsLw_a=0.9,
    epsLw_b=0.9,
    inc=IDEAS.Types.Tilt.Floor,
    d=0.1,
    linearise=true)
    "Mono layer air model for horizontal inclination: linearised"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
equation
  connect(monLayAirWal.port_b, fixTem.port)
    annotation (Line(points={{0,22},{0,0},{40,0}}, color={191,0,0}));
  connect(monLayAirHor.port_b, fixTem.port)
    annotation (Line(points={{0,0},{0,0},{40,0}}, color={191,0,0}));
  connect(preTem.port, monLayAirHor.port_a)
    annotation (Line(points={{-40,0},{-20,0}}, color={191,0,0}));
  connect(monLayAirHor.port_a, monLayAirWal.port_a)
    annotation (Line(points={{-20,0},{-20,22}}, color={191,0,0}));
  connect(sim.weaBus, weaBus1) annotation (Line(
      points={{-84,92.8},{-78,92.8},{-78,92},{-70,92}},
      color={255,204,51},
      thickness=0.5));
  connect(extCon.hConExt, weaBus1.hConExt) annotation (Line(points={{-20,-79},{
          -70,-79},{-70,-76},{-70,8},{-69.95,8},{-69.95,92.05}}, color={0,0,127}));
  connect(extCon.Te, weaBus1.Te) annotation (Line(points={{-20,-74.8},{-70,
          -74.8},{-70,-74},{-69.95,-74},{-69.95,92.05}}, color={0,0,127}));
  connect(ramp.y, preTem.T)
    annotation (Line(points={{-79,0},{-62,0}}, color={0,0,127}));
  connect(intConVerLin.port_a, intConFlo.port_a)
    annotation (Line(points={{-20,72},{-20,62},{-20,52}}, color={191,0,0}));
  connect(intConFlo.port_a, monLayAirWal.port_a)
    annotation (Line(points={{-20,52},{-20,22}}, color={191,0,0}));
  connect(intConVerLin.port_a, intConVer.port_a)
    annotation (Line(points={{-20,72},{-20,92},{-20,92}}, color={191,0,0}));
  connect(intConVer.port_b, intConVerLin.port_b)
    annotation (Line(points={{0,92},{0,72},{0,72}}, color={191,0,0}));
  connect(intConFlo.port_b, monLayAirWal.port_b)
    annotation (Line(points={{0,52},{0,22}}, color={191,0,0}));
  connect(extConLin.hConExt, extCon.hConExt) annotation (Line(points={{-20,-99},
          {-70,-99},{-70,-100},{-70,-79},{-20,-79}}, color={0,0,127}));
  connect(extConLin.Te, extCon.Te) annotation (Line(points={{-20,-94.8},{-70,
          -94.8},{-70,-74.8},{-20,-74.8}}, color={0,0,127}));
  connect(extConLin.port_a, extCon.port_a)
    annotation (Line(points={{-20,-90},{-20,-90},{-20,-70}}, color={191,0,0}));
  connect(intConFlo.port_b, intConVerLin.port_b)
    annotation (Line(points={{0,52},{0,52},{0,72}}, color={191,0,0}));
  connect(monLayAirHorLin.port_b, monLayAirHor.port_b)
    annotation (Line(points={{0,-20},{0,0}}, color={191,0,0}));
  connect(monLayAirHorLin.port_a, monLayAirHor.port_a)
    annotation (Line(points={{-20,-20},{-20,0}}, color={191,0,0}));
  connect(extCon.port_a, monLayAirHorLin.port_a)
    annotation (Line(points={{-20,-70},{-20,-20}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=1e+06),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Buildings/Components/BaseClasses/ConvectiveHeatTransfer/Examples/Convection.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
January 19, 2017 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This model is a unit test for the convective heat transfer models. 
</p>
</html>"));
end Convection;
