within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses;
model BoreHoleSegmentFourPort "Vertical segment of a borehole"
  extends Interface.PartialBoreHoleSegment;

  extends IDEAS.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final m1_flow_small=gen.m_flow_small,
    final m2_flow_small=gen.m_flow_small,
    final allowFlowReversal1=gen.allowFlowReversal,
    final allowFlowReversal2=gen.allowFlowReversal);

  InternalHEXUTube intHEX(
    redeclare final package Medium = Medium,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=0,
    final from_dp1=from_dp,
    final from_dp2=from_dp,
    final linearizeFlowResistance1=linearizeFlowResistance,
    final linearizeFlowResistance2=linearizeFlowResistance,
    final deltaM1=deltaM,
    final deltaM2=deltaM,
    final m1_flow_small=gen.m_flow_small,
    final m2_flow_small=gen.m_flow_small,
    final soi=soi,
    final fil=fil,
    final gen=gen,
    final allowFlowReversal1=gen.allowFlowReversal,
    final allowFlowReversal2=gen.allowFlowReversal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p1_start=p_start,
    final T1_start=T_start,
    final X1_start=X_start,
    final C1_start=C_start,
    final C1_nominal=C_nominal,
    final p2_start=p_start,
    final T2_start=T_start,
    final X2_start=X_start,
    final C2_start=C_start,
    final C2_nominal=C_nominal,
    final T_start=T_start,
    final dynFil=dynFil,
    final mSenFac=mSenFac,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal)
    "Internal part of the borehole including the pipes and the filling material"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

equation
  connect(intHEX.port_b1, port_b1) annotation (Line(
      points={{-50,6.36364},{-40,6.36364},{-40,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intHEX.port_a2, port_a2) annotation (Line(
      points={{-50,-4.54545},{-40,-4.54545},{-40,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intHEX.port_b2, port_b2) annotation (Line(
      points={{-70,-4.54545},{-80,-4.54545},{-80,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a1, intHEX.port_a1) annotation (Line(
      points={{-100,60},{-80,60},{-80,6.36364},{-70,6.36364}},
      color={0,127,255},
      smooth=Smooth.None));
  if not use_TWall then
    connect(intHEX.port, soilLay.port_a)
    annotation (Line(points={{-60,10},{-60,10},{-60,30}},color={191,0,0}));
  else
    connect(TBouCon.port, intHEX.port) annotation (Line(points={{-60,60},{-46,
            60},{-46,10},{-60,10}},
                                  color={191,0,0}));
  end if;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(graphics={
        Rectangle(
          extent={{-72,80},{68,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{88,54},{-88,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{88,-64},{-88,-54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,80},{68,68}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-72,-68},{68,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward)}),
    Documentation(info="<html>
<p>
Horizontal layer that is used to model a U-tube borehole heat exchanger. 
This model combines three models, each simulating a different aspect 
of a borehole heat exchanger. 
</p>
<p>
The instance <code>intHEX</code> computes the heat transfer in the pipes and the filling material. 
This computation is done using the model
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.SingleUTubeInternalHEX\">
IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.SingleUTubeInternalHEX</a>.
</p>
<p>
The instance <code>soiLay</code> computes transient and steady state heat transfer in the soil using a vertical cylinder.
The computation is done using the model <a href=\"modelica://IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.CylindricalGroundLayer\">
IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.CylindricalGroundLayer</a>.
</p>
<p>
The model <code>TBouCon</code> is a constant temperature equal to the initial ground temperature.</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end BoreHoleSegmentFourPort;
