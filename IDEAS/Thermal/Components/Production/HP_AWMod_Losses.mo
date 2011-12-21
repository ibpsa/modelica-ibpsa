within IDEAS.Thermal.Components.Production;
model HP_AWMod_Losses "Modulating AW HP with losses to environment"

  extends
    Thermal.Components.Production.Auxiliaries.PartialDynamicHeaterWithLosses(
      final heaterType=IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.HP_AW);

  Real COP "Instanteanous COP";
  parameter Real betaFactor = 0.8
    "Relative sizing compared to design heat load";

public
  Thermal.Components.Production.Auxiliaries.HP_CondensationPower_Losses heatSource(
    medium=medium,
    QDesign=QNom,
    TEvaporator=sim.Te,
    TCondensor_in=heatedFluid.T_a,
    TCondensor_set=TSet,
    m_flowCondensor=heatedFluid.flowPort_a.m_flow,
    TEnvironment=heatPort.T,
    UALoss=UALoss)
    annotation (Placement(transformation(extent={{-46,-46},{-26,-26}})));
  outer Commons.SimInfoManager sim
    annotation (Placement(transformation(extent={{-82,66},{-62,86}})));

equation
  PFuel = 0;
  PEl = heatSource.PEl;
  COP = if noEvent(PEl > 0) then heatedFluid.heatPort.Q_flow / PEl else 0;

  connect(heatSource.heatPort, heatedFluid.heatPort)
                                                 annotation (Line(
      points={{-26,-36},{-20,-36},{-20,6.12323e-016}},
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
end HP_AWMod_Losses;
