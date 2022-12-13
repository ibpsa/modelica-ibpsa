within IBPSA.Fluid.HeatPumps.Examples;
model ReversibleCarnotWithLosses_OneRoomRadiator
  "Reversible heat pump with carnot approach connected to a simple room model with radiator"
  extends BaseClasses.PartialOneRoomRadiator(sin(nPorts=1), booToReaPumEva(
        realTrue=revCarWitLosHeaPum.mEva_flow_nominal));
  parameter Real perHeaLos=0.1
    "Percentage of heat losses in the heat exchangers to the nominal heating power";
  ReversibleCarnotWithLosses revCarWitLosHeaPum(
    redeclare package MediumCon = MediumW,
    redeclare package MediumEva = MediumW,
    QUse_flow_nominal=Q_flow_nominal,
    y_nominal=1,
    use_rev=true,
    use_internalSafetyControl=true,
    TCon_nominal=TRadSup_nominal,
    dTCon_nominal=TRadSup_nominal - TRadRet_nominal,
    mCon_flow_nominal=mHeaPum_flow_nominal,
    dpCon_nominal(displayUnit="Pa") = 2000,
    CCon=5000,
    GConOut=perHeaLos*Q_flow_nominal/(TRadSup_nominal - temAmbBas.k),
    GConIns=20000,
    TEva_nominal=sou.T,
    dTEva_nominal=5,
    mEva_flow_nominal=mHeaPum_flow_nominal,
    dpEva_nominal(displayUnit="Pa") = 2000,
    CEva=5000,
    GEvaOut=perHeaLos*Q_flow_nominal/(temAmbBas.k - sou.T),
    GEvaIns=20000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare
      IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.DefaultSafetyControl
      safCtrlPar,
    quaGra=0.4,
    refIneFre_constant=0.003,
    nthOrder=3) "Reversible heat pump with losses and carnot approach"
    annotation (Placement(transformation(extent={{20,-160},{0,-136}})));
  Modelica.Blocks.Sources.Constant temAmbBas(final k=273.15 + 18)
    "Ambient temperature in basement of building" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-190})));
  Modelica.Blocks.Sources.BooleanConstant conPumAlwOn(final k=true)
    "Let the pumps always run, due to inertia of the heat pump" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-148,-150})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaCoo
    "Prescribed heat flow to trigger cooling"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Modelica.Blocks.Sources.Pulse    temAmbBas1(
    amplitude=Q_flow_nominal,
    width=10,
    period=86400,
    startTime=86400/2)
    "Ambient temperature in basement of building" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,80})));
  Modelica.Blocks.Logical.Not not1
    "If cooling demand, heat pump must turn to false"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-30,-70})));
equation
  connect(revCarWitLosHeaPum.port_b2, sin.ports[1]) annotation (Line(points={{20,
          -154},{38,-154},{38,-200},{60,-200}}, color={0,127,255}));
  connect(revCarWitLosHeaPum.port_a2, pumHeaPumSou.port_b) annotation (Line(
        points={{0,-154},{-30,-154},{-30,-170}}, color={0,127,255}));
  connect(revCarWitLosHeaPum.port_b1, pumHeaPum.port_a) annotation (Line(points=
         {{0,-142},{-70,-142},{-70,-120}}, color={0,127,255}));
  connect(revCarWitLosHeaPum.port_a1, temRet.port_b) annotation (Line(points={{20,
          -142},{60,-142},{60,-30}}, color={0,127,255}));
  connect(booToReaPum1.y, revCarWitLosHeaPum.ySet) annotation (Line(points={{40,
          -121},{40,-146},{21.6,-146}}, color={0,0,127}));
  connect(temAmbBas.y, revCarWitLosHeaPum.TEvaAmb) annotation (Line(points={{10,
          -179},{10,-166},{-6,-166},{-6,-158},{-1,-158}}, color={0,0,127}));
  connect(temAmbBas.y, revCarWitLosHeaPum.TConAmb) annotation (Line(points={{10,
          -179},{10,-166},{-6,-166},{-6,-138},{-1,-138}}, color={0,0,127}));
  connect(conPumAlwOn.y, booToReaPumCon.u) annotation (Line(points={{-137,-150},
          {-128,-150},{-128,-110},{-122,-110}}, color={255,0,255}));
  connect(conPumAlwOn.y, booToReaPumEva.u) annotation (Line(points={{-137,-150},
          {-130,-150},{-130,-180},{-122,-180}}, color={255,0,255}));
  connect(preHeaCoo.port, heaCap.port) annotation (Line(points={{-120,80},{-100,
          80},{-100,96},{50,96},{50,50},{70,50}},
                                             color={191,0,0}));
  connect(temAmbBas1.y, preHeaCoo.Q_flow)
    annotation (Line(points={{-159,80},{-140,80}}, color={0,0,127}));
  connect(not1.u, hysCoo.y)
    annotation (Line(points={{-42,-70},{-179,-70}}, color={255,0,255}));
  connect(not1.y, revCarWitLosHeaPum.revSet) annotation (Line(points={{-19,-70},
          {90,-70},{90,-157},{21.6,-157}}, color={255,0,255}));
end ReversibleCarnotWithLosses_OneRoomRadiator;
