within IBPSA.Fluid.HeatPumps.Examples;
model ReversibleAirToWater2D_OneRoomRadiator
  "Reversible heat pump with EN 2D data connected to a simple room model with radiator"
  extends BaseClasses.PartialOneRoomRadiator(
    mEva_flow_nominal=revCarWitLosHeaPum.mEva_flow_nominal,
    mCon_flow_nominal=revCarWitLosHeaPum.mCon_flow_nominal,
    sin(nPorts=1, redeclare package Medium = MediumAir),
    booToReaPumEva(realTrue=revCarWitLosHeaPum.mEva_flow_nominal),
    pumHeaPumSou(
      redeclare package Medium = MediumAir),
    sou(redeclare package Medium = MediumAir));

  IBPSA.Fluid.HeatPumps.ReversibleAirToWaterEuropeanNorm2D revCarWitLosHeaPum(
    redeclare package MediumCon = MediumWat,
    redeclare package MediumEva = MediumAir,
    QUse_flow_nominal=Q_flow_nominal,
    y_nominal=1,
    use_intSafCtr=true,
    TCon_nominal=TRadSup_nominal,
    mCon_flow_nominal=0.717225,
    dpCon_nominal(displayUnit="Pa") = 2000,
    TEva_nominal=sou.T,
    mEva_flow_nominal=2.3116,
    dpEva_nominal(displayUnit="Pa") = 2000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare
      IBPSA.Fluid.HeatPumps.Data.EuropeanNorm2D.EN14511.Vitocal200AWO201
      datTabHea,
    redeclare IBPSA.Fluid.Chillers.Data.EuropeanNorm2D.EN14511.Vitocal200AWO201
      datTabCoo,
    redeclare
      IBPSA.Fluid.HeatPumps.Controls.Safety.RecordsCollection.DefaultHeatPumpSafetyControl
      safCtrParEurNor(
        use_minRunTime=false,
        use_minLocTime=true,
        use_runPerHou=true,
        use_antFre=true,
        TAntFre=275.15))
                 "Reversible heat pump with losses and carnot approach"
    annotation (Placement(transformation(extent={{20,-160},{0,-136}})));
equation
  connect(revCarWitLosHeaPum.port_b2, sin.ports[1]) annotation (Line(points={{20,
          -154},{38,-154},{38,-200},{60,-200}}, color={0,127,255}));
  connect(revCarWitLosHeaPum.port_a2, pumHeaPumSou.port_b) annotation (Line(
        points={{0,-154},{-30,-154},{-30,-170}}, color={0,127,255}));
  connect(revCarWitLosHeaPum.port_b1, pumHeaPum.port_a) annotation (Line(points=
         {{0,-142},{-70,-142},{-70,-120}}, color={0,127,255}));
  connect(revCarWitLosHeaPum.port_a1, temRet.port_b) annotation (Line(points={{20,
          -142},{60,-142},{60,-30}}, color={0,127,255}));
  connect(oneRooRadHeaPumCtr.ySet, revCarWitLosHeaPum.ySet) annotation (Line(
        points={{-139,-66},{-112,-66},{-112,-62},{21.6,-62},{21.6,-146}}, color=
         {0,0,127}));
  connect(revCarWitLosHeaPum.hea, oneRooRadHeaPumCtr.hea) annotation (Line(
        points={{21.6,-157},{24,-157},{24,-152},{26,-152},{26,-80},{-14,-80},{-14,
          -86},{-134,-86},{-134,-76},{-139,-76}}, color={255,0,255}));
  annotation (
   __Dymola_Commands(file=
     "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/ReversibleAirToWater2D_OneRoomRadiator.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-08),
    Documentation(info="<html>
<p>
  This example demonstrates how to use the 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ReversibleAirToWaterEuropeanNorm2D\">
  IBPSA.Fluid.HeatPumps.ReversibleAirToWaterEuropeanNorm2D</a> 
  heat pump model. Please check the associated documentation for
  further information.
</p>
<p>
  Please check the documentation of 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.Examples.BaseClasses.PartialOneRoomRadiator\">
  IBPSA.Fluid.HeatPumps.Examples.BaseClasses.PartialOneRoomRadiator</a>
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
