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
          lineColor={95,95,95})}));
end HeatExchanger;
