within IDEAS.Thermal.Components.Production;
model HP_BW_Borehole "BW HP with borehole included"

  extends
    IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses(
      final heaterType=IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.HP_BW);
  parameter Modelica.SIunits.Power QNom "Nominal power at 2/35";
  parameter Thermal.Data.Interfaces.Medium mediumEvap=Data.Media.Water()
    "Medium in the evaporator";
  parameter Thermal.Data.Interfaces.Medium mediumBorehole=Data.Media.Water();

  Real COP "Instanteanous COP";

  IDEAS.Thermal.Components.Production.BaseClasses.HP_BW_CondensationPower_Losses
                                                                           heatSource(
    medium=medium,
    mediumEvap=mediumEvap,
    QDesign=QNom,
    TCondensor_in=heatedFluid.T_a,
    TCondensor_set=TSet,
    m_flowCondensor=heatedFluid.flowPort_a.m_flow,
    TEnvironment=heatPort.T,
    UALoss=UALoss)
    annotation (Placement(transformation(extent={{-48,-46},{-28,-26}})));
  outer IDEAS.SimInfoManager         sim
    annotation (Placement(transformation(extent={{-82,66},{-62,86}})));
  IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.VerticalHeatExchangerModels.BoreHole
    boreHole(medium=mediumBorehole)
    annotation (Placement(transformation(extent={{36,-70},{56,-50}})));
  Thermal.Components.BaseClasses.Pump pumpBorehole(
    medium=mediumBorehole,
    m=0,
    useInput=true,
    m_flowNom=0.5,
    dpFix=80000)
            annotation (Placement(transformation(extent={{-4,-68},{12,-52}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        mediumBorehole, p=300000)
    annotation (Placement(transformation(extent={{68,-46},{80,-34}})));
equation
  PFuel = 0;
  PEl = heatSource.PEl + pumpBorehole.PEl;
  COP = if noEvent(heatSource.PEl > 0) then heatedFluid.heatPort.Q_flow / PEl else 0;
  pumpBorehole.m_flowSet = if noEvent(heatSource.PEl > 0) then 1 else 0;
  connect(heatSource.heatPort, heatedFluid.heatPort)
                                                 annotation (Line(
      points={{-28,-36},{-20,-36},{-20,6.12323e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatSource.flowPort_b, pumpBorehole.flowPort_a)
                                                  annotation (Line(
      points={{-36,-46},{-36,-60},{-4,-60}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pumpBorehole.flowPort_b, boreHole.flowPort_a)
                                                annotation (Line(
      points={{12,-60},{24.1,-60},{24.1,-60.2},{36.2,-60.2}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatSource.flowPort_a, boreHole.flowPort_b) annotation (Line(
      points={{-42,-46},{-42,-88},{82,-88},{82,-60},{55.8,-60}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, boreHole.flowPort_b) annotation (Line(
      points={{68,-40},{55.8,-40},{55.8,-60}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Line(
          points={{-100,30},{-100,10}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-100,-30},{-100,-50}},
          color={85,85,255},
          smooth=Smooth.None),
        Line(
          points={{80,30},{80,10}},
          color={128,0,255},
          smooth=Smooth.None),
        Line(
          points={{100,20},{84,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{100,-40},{84,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{80,-30},{80,-50}},
          color={128,0,255},
          smooth=Smooth.None),
        Ellipse(extent={{-80,50},{-20,-10}},  lineColor={100,100,100}),
        Line(
          points={{-100,20},{-68,20},{-40,32},{-60,8},{-32,20},{-20,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(extent={{0,-10},{60,-70}},    lineColor={100,100,100}),
        Line(
          points={{0,-40},{12,-40},{40,-28},{20,-52},{48,-40},{80,-40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-104,30},{-104,10}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-104,-30},{-104,-50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{84,-30},{84,-50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{84,30},{84,10}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-20,20},{-10,20},{-30,-40},{-100,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{0,-40},{-10,-40},{10,20},{80,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-20,-72},{-20,-88},{0,-72},{0,-88},{-20,-72}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-10},{-50,-80},{-20,-80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{0,-80},{30,-80},{30,-70}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,50},{-50,100},{-30,100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{30,-10},{30,80},{10,80}},
          color={95,95,95},
          smooth=Smooth.None),
        Polygon(
          points={{-20,120},{0,120},{8,118},{10,110},{10,70},{8,62},{0,60},{-20,
              60},{-28,62},{-30,70},{-30,110},{-28,118},{-20,120}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,100},{10,110}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-224,-80},{-114,-220}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-224,-80},{-114,-80}},
          color={95,95,95},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-104,-40},{-144,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-104,20},{-144,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-144,-40},{-144,-178},{-164,-198},{-184,-178},{-184,10},{-184,
              10}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-154,-40},{-154,-180},{-174,-198},{-194,-180},{-194,20},{-144,
              20}},
          color={0,0,127},
          smooth=Smooth.None)}));
end HP_BW_Borehole;
