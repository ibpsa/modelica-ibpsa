within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Interface;
partial model PartialSingleBoreholeSerie
  extends PartialBoreHoleElement;
  extends PartialTWall;
   extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface;
  //  (redeclare package
//       Medium =                                                                                   Medium);
  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(
      computeFlowResistance=false, linearizeFlowResistance=false);
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(T_start=gen.T_start);

    replaceable Interface.PartialSingleBoreHole[
                                  gen.nbSer] borHol(
    each final m_flow_nominal=m_flow_nominal,
    each final T_start=T_start,
    each final dp_nominal=dp_nominal,
    each final soi=soi,
    each final fil=fil,
    each final gen=gen,
    each final show_T=show_T,
    each final computeFlowResistance=computeFlowResistance,
    each final from_dp=from_dp,
    each final linearizeFlowResistance=linearizeFlowResistance,
    each final deltaM=deltaM,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p_start=p_start,
    each final X_start=X_start,
    each final C_start=C_start,
    redeclare each final package Medium = Medium,
    each final C_nominal=C_nominal,
    each final dynFil=dynFil,
    each final mSenFac=mSenFac,
    each final use_TWall=use_TWall) constrainedby
    Interface.PartialSingleBoreHole(
    each  m_flow_nominal=m_flow_nominal,
    each  T_start=T_start,
    each  dp_nominal=dp_nominal,
    each  soi=soi,
    each  fil=fil,
    each  gen=gen,
    each  show_T=show_T,
    each  computeFlowResistance=computeFlowResistance,
    each  from_dp=from_dp,
    each  linearizeFlowResistance=linearizeFlowResistance,
    each  deltaM=deltaM,
    each  energyDynamics=energyDynamics,
    each  massDynamics=massDynamics,
    each  p_start=p_start,
    each  X_start=X_start,
    each  C_start=C_start,
    redeclare each package Medium =  Medium,
    each  C_nominal=C_nominal,
    each  dynFil=dynFil,
    each  mSenFac=mSenFac,
    each  use_TWall=use_TWall) "Borehole heat exchanger"                 annotation (Placement(
        transformation(extent={{-16,-16},{16,16}}, rotation=0)));

  Modelica.SIunits.Temperature TWallAve "Average borehole temperature";

equation
    connect(port_a, borHol[1].port_a) annotation (Line(
      points={{-100,0},{-16,0}},
      color={0,127,255},
      smooth=Smooth.None));
    connect(borHol[gen.nbSer].port_b, port_b) annotation (Line(
      points={{16,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
    for i in 1:gen.nbSer - 1 loop
      connect(borHol[i].port_b, borHol[i + 1].port_a) annotation (Line(
      points={{16,0},{16,28},{-16,28},{-16,0}},
      color={0,127,255},
      smooth=Smooth.None));
      if use_TWall then
        connect(TWall, borHol[1].TWall)
        annotation (Line(points={{0,110},{0,17.6}},          color={0,0,127}));
      end if;
    end for;
    connect(TWall, borHol[gen.nbSer].TWall)
      annotation (Line(points={{0,110},{0,17.6}},          color={0,0,127}));

  TWallAve = sum(borHol.TWallAve)/gen.nbSer;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(
        graphics={
        Rectangle(
          extent={{-66,62},{-58,-78}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-38,62},{-30,-78}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{34,62},{42,-78}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{62,62},{70,-78}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-38,-70},{-58,-78}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{62,-70},{42,-78}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-54,70},{-50,-70}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-46,70},{-42,-70}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,70},{58,-70}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,70},{50,-70}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,15},{2,-15}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={-31,68},
          rotation=90),
        Rectangle(
          extent={{-2,15},{2,-15}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={35,68},
          rotation=90),
        Rectangle(
          extent={{-2,15},{2,-15}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={69,68},
          rotation=90),
        Rectangle(
          extent={{-2,15},{2,-15}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={-65,68},
          rotation=90),
        Line(
          points={{2,82},{-18,22},{2,-38},{-10,-80},{-10,-80}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{14,82},{-6,22},{14,-38},{2,-80},{2,-80}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Text(
          extent={{-28,104},{40,68}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          textString="nbSer")}));
end PartialSingleBoreholeSerie;
