within IBPSA.Experimental.Pipe;
model PipeTemplate "Pipe model with geometric data from catalog"
  extends IBPSA.Fluid.Interfaces.PartialTwoPort_vector;
  PipeHeatLossMod pipeHeatLossMod(nPorts=nPorts)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  replaceable parameter
    BaseClasses.SinglePipeConfig.IsoPlusSingleRigidStandard.IsoPlusKRE50S
    pipeData constrainedby BaseClasses.SinglePipeConfig.SinglePipeData
    annotation (choicesAllMatching=True, Placement(transformation(extent={{-40,-80},{-20,-60}})));
equation
  connect(port_a, pipeHeatLossMod.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pipeHeatLossMod.ports_b[:], ports_b[:])
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(pipeHeatLossMod.heatPort, heatPort)
    annotation (Line(points={{0,10},{0,100}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={170,255,85}),
        Rectangle(
          extent={{-100,-40},{100,-50}},
          lineColor={175,175,175},
          fillColor={238,46,47},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,50},{100,40}},
          lineColor={175,175,175},
          fillColor={238,46,47},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,30},{100,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={170,170,255}),
        Rectangle(
          extent={{-30,30},{28,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187}),
        Polygon(
          points={{0,100},{40,62},{20,62},{20,38},{-20,38},{-20,62},{-40,62},{0,
              100}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PipeTemplate;
