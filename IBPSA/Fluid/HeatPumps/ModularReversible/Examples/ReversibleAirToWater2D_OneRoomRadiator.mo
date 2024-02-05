within IBPSA.Fluid.HeatPumps.ModularReversible.Examples;
model ReversibleAirToWater2D_OneRoomRadiator
  "Reversible heat pump with EN 2D data connected to a simple room model with radiator"
  extends
    IBPSA.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator(
    mEva_flow_nominal=heaPum.mEva_flow_nominal,
    mCon_flow_nominal=heaPum.mCon_flow_nominal,
    sin(nPorts=1, redeclare package Medium = MediumAir),
    booToReaPumEva(realTrue=heaPum.mEva_flow_nominal),
    pumHeaPumSou(redeclare package Medium = MediumAir),
    sou(use_T_in=true,
        redeclare package Medium = MediumAir));

  IBPSA.Fluid.HeatPumps.ModularReversible.ReversibleAirToWaterTableData2D
    heaPum(
    redeclare package MediumCon = MediumWat,
    redeclare package MediumEva = MediumAir,
    TCon_start=TRadSup_nominal,
    QHea_flow_nominal=Q_flow_nominal,
    use_intSafCtr=true,
    TCon_nominal=TRadSup_nominal,
    dpCon_nominal(displayUnit="Pa") = 2000,
    TEva_nominal=sou.T,
    dpEva_nominal(displayUnit="Pa") = 200,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare
      IBPSA.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
      datTabHea,
    redeclare
      IBPSA.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08
      datTabCoo,
    redeclare
      IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
      safCtrParEurNor(
      use_minOnTime=false,
      use_minOffTime=true,
      minOffTime=300,
      use_maxCycRat=true)) "Reversible heat pump based on 2D table data"
    annotation (Placement(transformation(extent={{20,-160},{0,-140}})));
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.Pulse TAirSouSte(
    amplitude=20,
    width=10,
    period=86400,
    offset=283.15,
    startTime=86400/2) if witCoo "Air source temperature step for cooling phase"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-210})));
equation
  connect(heaPum.port_b2, sin.ports[1]) annotation (Line(points={{20,-156},{38,
          -156},{38,-200},{60,-200}},           color={0,127,255}));
  connect(heaPum.port_a2, pumHeaPumSou.port_b) annotation (Line(
        points={{0,-156},{-30,-156},{-30,-170}}, color={0,127,255}));
  connect(heaPum.port_b1, pumHeaPum.port_a) annotation (Line(points={{0,-144},{
          -70,-144},{-70,-120}},           color={0,127,255}));
  connect(heaPum.port_a1, temRet.port_b) annotation (Line(points={{20,-144},{60,
          -144},{60,-30}},           color={0,127,255}));
  connect(oneRooRadHeaPumCtr.ySet, heaPum.ySet) annotation (Line(
        points={{-139.167,-66.6667},{21.2,-66.6667},{21.2,-148}},         color=
         {0,0,127}));
  connect(heaPum.hea, oneRooRadHeaPumCtr.hea) annotation (Line(
        points={{21.1,-151.9},{24,-151.9},{24,-152},{26,-152},{26,-75},{-139.167,
          -75}},                                  color={255,0,255}));
  connect(TAirSouSte.y, sou.T_in) annotation (Line(points={{-139,-210},{-94,-210},
          {-94,-196},{-82,-196}}, color={0,0,127}));
  annotation (
   __Dymola_Commands(file=
     "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/ReversibleAirToWater2D_OneRoomRadiator.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-08),
    Documentation(info="<html>
<p>
  This example demonstrates how to use the
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ReversibleAirToWaterTableData2D\">
  IBPSA.Fluid.HeatPumps.ModularReversible.ReversibleAirToWaterTableData2D</a>
  heat pump model. Please check the associated documentation for
  further information.
</p>
<p>
  Please check the documentation of
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator\">
  IBPSA.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator</a>
  for further information on the example.
</p>
</html>", revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"));
end ReversibleAirToWater2D_OneRoomRadiator;