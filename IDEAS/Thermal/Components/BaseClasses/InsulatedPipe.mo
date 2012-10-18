within IDEAS.Thermal.Components.BaseClasses;
model InsulatedPipe

parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
    "Medium in the component"
    annotation(choicesAllMatching=true);
parameter SI.ThermalConductance UA "Thermal conductance of the insulation";
  HeatedPipe heatedPipe
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        UA) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-26})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
      Placement(transformation(extent={{-10,-60},{10,-40}}), iconTransformation(
          extent={{-10,-60},{10,-40}})));
  Interfaces.FlowPort_a flowPort_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.FlowPort_b flowPort_b
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation
  connect(heatedPipe.heatPort, thermalConductor.port_b) annotation (Line(
      points={{0,-10},{0,-16},{6.12323e-016,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_a, heatPort) annotation (Line(
      points={{-6.12323e-016,-36},{0,-36},{0,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatedPipe.flowPort_a, flowPort_a) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(heatedPipe.flowPort_b, flowPort_b) annotation (Line(
      points={{10,0},{100,0}},
      color={0,128,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
                              Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={255,255,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-100,40},{100,20}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Backward,
          fillColor={186,89,76}),
        Rectangle(
          extent={{-100,-20},{100,-40}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Backward,
          fillColor={186,89,76})}));
end InsulatedPipe;
