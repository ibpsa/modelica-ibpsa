within IDEAS.Thermal.Components.Production;
model HP_BW "BW HP with losses to environment"

  extends
    Thermal.Components.Production.Auxiliaries.PartialDynamicHeaterWithLosses(
      final heaterType=IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.HP_BW);
  parameter Modelica.SIunits.Power QNom "Nominal power at 2/35";
  parameter Thermal.Data.Interfaces.Medium mediumEvap=Data.Media.Water()
    "Medium in the evaporator";

  Real COP "Instanteanous COP";

  Thermal.Components.Production.Auxiliaries.HP_BW_CondensationPower_Losses heatSource(
    medium=medium,
    mediumEvap=mediumEvap,
    QDesign=QNom,
    TCondensor_in=heatedFluid.T_a,
    TCondensor_set=TSet,
    m_flowCondensor=heatedFluid.flowPort_a.m_flow,
    TEnvironment=heatPort.T,
    UALoss=UALoss)
    annotation (Placement(transformation(extent={{-48,-46},{-28,-26}})));
  outer Commons.SimInfoManager sim
    annotation (Placement(transformation(extent={{-82,66},{-62,86}})));
  Thermal.Components.Interfaces.FlowPort_a flowPortEvap_a(medium=mediumEvap)
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  Thermal.Components.Interfaces.FlowPort_b flowPortEvap_b(medium=mediumEvap)
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
equation
  PFuel = 0;
  PEl = heatSource.PEl;
  COP = if noEvent(PEl > 0) then heatedFluid.heatPort.Q_flow / PEl else 0;
  connect(flowPortEvap_a, heatSource.flowPort_a)
                                             annotation (Line(
      points={{-40,-100},{-42,-100},{-42,-46}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatSource.flowPort_b, flowPortEvap_b)
                                             annotation (Line(
      points={{-36,-46},{-34,-46},{-34,-72},{20,-72},{20,-100}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatSource.heatPort, heatedFluid.heatPort)
                                                 annotation (Line(
      points={{-28,-36},{-20,-36},{-20,6.12323e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Line(
          points={{-28,72},{-50,-30}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{0,70},{-22,-32}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{36,68},{14,-34}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{34,68},{42,64},{46,64},{56,56},{56,54},{62,40},{62,38},{64,
              32},{64,30},{60,24},{58,22},{54,20},{52,18},{46,16},{40,16},{34,
              16},{28,16},{18,16}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{-46,24},{-44,24},{2,24}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None)}));
end HP_BW;
