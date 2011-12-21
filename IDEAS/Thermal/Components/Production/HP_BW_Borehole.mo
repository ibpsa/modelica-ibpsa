within IDEAS.Thermal.Components.Production;
model HP_BW_Borehole "BW HP with borehole included"

  extends
    Thermal.Components.Production.Auxiliaries.PartialDynamicHeaterWithLosses(
      final heaterType=IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.HP_BW);
  parameter Modelica.SIunits.Power QNom "Nominal power at 2/35";
  parameter Thermal.Data.Interfaces.Medium mediumEvap=Data.Media.Water()
    "Medium in the evaporator";
  parameter Thermal.Data.Interfaces.Medium mediumBorehole=Data.Media.Water();

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
  Thermal.Components.VerticalGroundHeatExchanger.VerticalHeatExchangerModels.BoreHole
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
end HP_BW_Borehole;
