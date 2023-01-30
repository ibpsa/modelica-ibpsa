within IBPSA.Fluid.HeatPumps.Examples;
model ReversibleAirToWater2D_OneRoomRadiator
  "Reversible heat pump with EN 2D data connected to a simple room model with radiator"
  extends BaseClasses.PartialOneRoomRadiator(sin(nPorts=1), booToReaPumEva(
        realTrue=revCarWitLosHeaPum.mEva_flow_nominal),
    constTSetRooHea(k=293.15),
    constTSetRooCoo(k=296.15),
    PIDHea(yMin=0),
    PIDCoo(yMin=0));

  ReversibleAirToWaterEuropeanNorm2D
                             revCarWitLosHeaPum(
    redeclare package MediumCon = MediumW,
    redeclare package MediumEva = MediumW,
    QUse_flow_nominal=Q_flow_nominal,
    y_nominal=1,
    use_internalSafetyControl=true,
    TCon_nominal=TRadSup_nominal,
    dpCon_nominal(displayUnit="Pa") = 2000,
    TEva_nominal=sou.T,
    dpEva_nominal(displayUnit="Pa") = 2000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare
      IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.DefaultSafetyControl
      safCtrlPar(
      use_minRunTime=false,
      use_minLocTime=true,
      use_runPerHou=true,
      use_antFre=true,
      TAntFre=275.15),
    redeclare
      IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.EN14511.Vitocal200AWO201
      datTabHea,
    redeclare
      IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2DData.EN14511.Vitocal200AWO201
      datTabCoo)
                "Reversible heat pump with losses and carnot approach"
    annotation (Placement(transformation(extent={{20,-160},{0,-136}})));
  Modelica.Blocks.Sources.BooleanConstant conPumAlwOn(final k=true)
    "Let the pumps always run, due to inertia of the heat pump" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-148,-150})));
equation
  connect(revCarWitLosHeaPum.port_b2, sin.ports[1]) annotation (Line(points={{20,
          -154},{38,-154},{38,-200},{60,-200}}, color={0,127,255}));
  connect(revCarWitLosHeaPum.port_a2, pumHeaPumSou.port_b) annotation (Line(
        points={{0,-154},{-30,-154},{-30,-170}}, color={0,127,255}));
  connect(revCarWitLosHeaPum.port_b1, pumHeaPum.port_a) annotation (Line(points=
         {{0,-142},{-70,-142},{-70,-120}}, color={0,127,255}));
  connect(revCarWitLosHeaPum.port_a1, temRet.port_b) annotation (Line(points={{20,
          -142},{60,-142},{60,-30}}, color={0,127,255}));
  connect(conPumAlwOn.y, booToReaPumCon.u) annotation (Line(points={{-137,-150},
          {-128,-150},{-128,-110},{-122,-110}}, color={255,0,255}));
  connect(conPumAlwOn.y, booToReaPumEva.u) annotation (Line(points={{-137,-150},
          {-130,-150},{-130,-180},{-122,-180}}, color={255,0,255}));
  connect(swiYSet.y, revCarWitLosHeaPum.ySet) annotation (Line(points={{40,-123},
          {40,-146},{21.6,-146}}, color={0,0,127}));
  connect(not1.y, revCarWitLosHeaPum.revSet) annotation (Line(points={{-99,-80},
          {-86,-80},{-86,-166},{26,-166},{26,-157},{21.6,-157}}, color={255,0,
          255}));
end ReversibleAirToWater2D_OneRoomRadiator;
