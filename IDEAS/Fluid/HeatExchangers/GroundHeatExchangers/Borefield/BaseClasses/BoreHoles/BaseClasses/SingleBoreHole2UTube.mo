within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses;
model SingleBoreHole2UTube "Single 2U-tube borehole heat exchanger"

  extends Interface.PartialSingleBoreHole(
    T_start=gen.T_start);

  BoreHoleSegmentEightPort borHolSeg[gen.nVer](
    redeclare each final package Medium = Medium,
    each final soi=soi,
    each final fil=fil,
    each final gen=gen,
    final dp_nominal={if i == 1 and gen.parallel2UTube then dp_nominal elseif i
         == 1 and not gen.parallel2UTube then dp_nominal/2 else 0 for i in 1:
        gen.nVer},
    each final TExt_start=T_start,
    each final TFil_start=T_start,
    each final show_T=show_T,
    each final computeFlowResistance=computeFlowResistance,
    each final from_dp=from_dp,
    each final linearizeFlowResistance=linearizeFlowResistance,
    each final deltaM=deltaM,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final X_start=X_start,
    each final C_start=C_start,
    each final C_nominal=C_nominal,
    each final m1_flow_nominal=if gen.parallel2UTube then m_flow_nominal/2
         else m_flow_nominal,
    each final m2_flow_nominal=if gen.parallel2UTube then m_flow_nominal/2
         else m_flow_nominal,
    each final m3_flow_nominal=if gen.parallel2UTube then m_flow_nominal/2
         else m_flow_nominal,
    each final m4_flow_nominal=if gen.parallel2UTube then m_flow_nominal/2
         else m_flow_nominal,
    each final m1_flow_small=if gen.parallel2UTube then gen.m_flow_small/2
         else gen.m_flow_small,
    each final m2_flow_small=if gen.parallel2UTube then gen.m_flow_small/2
         else gen.m_flow_small,
    each final m3_flow_small=if gen.parallel2UTube then gen.m_flow_small/2
         else gen.m_flow_small,
    each final m4_flow_small=if gen.parallel2UTube then gen.m_flow_small/2
         else gen.m_flow_small,
    each final dynFil=dynFil,
    each final mSenFac=mSenFac,
    each final use_TWall=use_TWall) "Discretized borehole segments"
    annotation (Placement(transformation(extent={{-10,-30},{10,10}})));

equation
  TWallAve = sum(borHolSeg[:].intHEX.port.T)/gen.nVer;

  // Couple borehole port_a and port_b to first borehole segment.
  connect(port_a, borHolSeg[1].port_a1) annotation (Line(
      points={{-100,5.55112e-016},{-52,5.55112e-016},{-52,6},{-10,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, borHolSeg[1].port_b4) annotation (Line(
      points={{100,5.55112e-016},{28,5.55112e-016},{28,-40},{-32,-40},{-32,-27},
          {-10,-27}},
      color={0,127,255},
      smooth=Smooth.None));
  if gen.parallel2UTube then
    connect(port_a, borHolSeg[1].port_a3) annotation (Line(
        points={{-100,5.55112e-016},{-52,5.55112e-016},{-52,-16.4},{-10,-16.4}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(port_b, borHolSeg[1].port_b2) annotation (Line(
        points={{100,5.55112e-016},{28,5.55112e-016},{28,-40},{-32,-40},{-32,-4},
            {-10,-4}},
        color={0,127,255},
        smooth=Smooth.None));
  else
    // U-tube in serie: couple both U-tube to each other.
    connect(borHolSeg[1].port_b2, borHolSeg[1].port_a3) annotation (Line(
        points={{-10,-4},{-24,-4},{-24,-16},{-18,-16},{-18,-16.4},{-10,-16.4}},
        color={0,127,255},
        smooth=Smooth.None));
  end if;

  // Couple each layer to the next one
  for i in 1:gen.nVer - 1 loop
    connect(borHolSeg[i].port_b1, borHolSeg[i + 1].port_a1) annotation (Line(
        points={{10,6},{10,10},{-10,10},{-10,6}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(borHolSeg[i].port_a2, borHolSeg[i + 1].port_b2) annotation (Line(
        points={{10,-4},{10,0},{-10,0},{-10,-4}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(borHolSeg[i].port_b3, borHolSeg[i + 1].port_a3) annotation (Line(
        points={{10,-16.2},{10,-12},{-10,-12},{-10,-16.4}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(borHolSeg[i].port_a4, borHolSeg[i + 1].port_b4) annotation (Line(
        points={{10,-26},{10,-22},{-10,-22},{-10,-27}},
        color={0,127,255},
        smooth=Smooth.None));
    if use_TWall then
      connect(TWall, borHolSeg[i].TWall) annotation (Line(points={{0,110},{0,12}},        color={0,0,127}));
    end if;
  end for;

  // Close U-tube at bottom layer
  connect(borHolSeg[gen.nVer].port_b1, borHolSeg[gen.nVer].port_a2) annotation (
     Line(
      points={{10,6},{16,6},{16,-4},{10,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(borHolSeg[gen.nVer].port_b3, borHolSeg[gen.nVer].port_a4) annotation (
     Line(
      points={{10,-16.2},{14,-16.2},{14,-16},{18,-16},{18,-26},{10,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TWall, borHolSeg[gen.nVer].TWall) annotation (Line(points={{0,110},{0,
          12}},                                                                              color={0,0,127}));

  annotation (
    Dialog(group="Borehole"),
    Dialog(group="Borehole"),
    defaultComponentName="borehole",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5)),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={Text(
          extent={{60,72},{84,58}},
          lineColor={0,0,255},
          textString=""), Text(
          extent={{50,-32},{90,-38}},
          lineColor={0,0,255},
          textString="")}),
    Documentation(info="<html>
<p>
Model of a single U-tube borehole heat exchanger. 
The borehole heat exchanger is vertically discretized into <i>n<sub>seg</sub></i>
elements of height <i>h=h<sub>Bor</sub>&frasl;n<sub>seg</sub></i>.
each final segment contains a model for the heat transfer in the borehole, 
for heat transfer in the soil and for the far-field boundary condition.
</p>
<p>
The heat transfer in the borehole is computed using a convective heat transfer coefficient
that depends on the fluid velocity, a heat resistance between the two pipes, and
a heat resistance between the pipes and the circumference of the borehole.
The heat capacity of the fluid, and the heat capacity of the grout, is taken into account.
All thermal mass is assumed to be at the two bulk temperatures of the down-flowing 
and up-flowing fluid.
</p>
<p>
The heat transfer in the soil is computed using transient heat conduction in cylindrical
coordinates for the spatial domain <i>r<sub>bor</sub> &le; r &le; r<sub>ext</sub></i>. 
In the radial direction, the spatial domain is discretized into 
<i>n<sub>hor</sub></i> segments with uniform material properties.
Thermal properties can be specified separately for each final horizontal layer.
The vertical heat flow is assumed to be zero, and there is assumed to be 
no ground water flow. 
</p>
<p>
The far-field temperature, i.e., the temperature at the radius 
<i>r<sub>ext</sub></i>, is kept constant because this model is only use to compute the short-term
temperature response of the borehole.
</p>

<h4>Implementation</h4>
<p>
each final horizontal layer is modeled using an instance of
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.BoreHoleSegmentFourPort\">
IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.BoreHoleSegmentFourPort</a>.
This model is composed of the model
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.SingleUTubeInternalHEX\">
IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.SingleUTubeInternalHEX</a> which computes
the heat transfer in the pipes and the borehole filling, and
of the model
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.CylindricalGroundLayer\">
IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.CylindricalGroundLayer</a> which computes
the heat transfer in the soil.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end SingleBoreHole2UTube;
