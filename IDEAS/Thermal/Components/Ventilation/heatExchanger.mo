within IDEAS.Thermal.Components.Ventilation;
model HeatExchanger

  Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort_a flowPort_a annotation (
      Placement(transformation(extent={{-110,60},{-90,80}}), iconTransformation(
          extent={{-110,60},{-90,80}})));
  Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort_a flowPort_a1 annotation (
      Placement(transformation(extent={{90,-80},{110,-60}}), iconTransformation(
          extent={{90,-80},{110,-60}})));
  Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort_b flowPort_b annotation (
      Placement(transformation(extent={{-110,-80},{-90,-60}}),
        iconTransformation(extent={{-110,-80},{-90,-60}})));
  Modelica.Thermal.FluidHeatFlow.Interfaces.FlowPort_b flowPort_b1 annotation (
      Placement(transformation(extent={{90,60},{110,80}}), iconTransformation(
          extent={{90,60},{110,80}})));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          pattern=LinePattern.None,
          lineColor={95,95,95}),
        Polygon(
          points={{-100,80},{-40,60},{-20,60},{-60,20},{-60,40},{-100,60},{-100,
              80}},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{100,-60},{60,-40},{60,-20},{20,-60},{40,-60},{100,-80},{100,
              -60}},
          smooth=Smooth.None,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{20,60},{40,60},{100,80},{100,60},{60,40},{60,20},{20,60}},
          smooth=Smooth.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-100,-80},{-40,-60},{-20,-60},{-60,-20},{-60,-40},{-100,-60},
              {-100,-80}},
          smooth=Smooth.None,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-80,0},{0,80},{80,0},{0,-80},{-80,0}},
          lineColor={95,95,95},
          smooth=Smooth.None)}));
end HeatExchanger;
