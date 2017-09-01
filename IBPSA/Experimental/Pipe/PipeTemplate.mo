within IBPSA.Experimental.Pipe;
model PipeTemplate "Pipe model with geometric data from catalog"
  extends IBPSA.Fluid.Interfaces.PartialTwoPort_vector;

  replaceable parameter
    BaseClasses.SinglePipeConfig.IsoPlusSingleRigidStandard.IsoPlusKRE50S
    pipeData(H=H) constrainedby BaseClasses.SinglePipeConfig.SinglePipeData
    annotation (choicesAllMatching=True, Placement(transformation(extent={{-40,
            -80},{-20,-60}})));
  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.Length H=2 "Buried depth of pipe";

  Fluid.FixedResistances.PlugFlow pipe(
    nPorts=nPorts,
    diameter=pipeData.Di,
    length=length,
    thicknessIns=(pipeData.Do - pipeData.Di)/2,
    R=pipeData.hInvers/(pipeData.lambdaI*2*Modelica.Constants.pi),
    final lambdaI=pipeData.lambdaI,
    final walCap=pipeData.CW,
    final cpipe=pipeData.cW,
    final rho_wall=pipeData.rhoW,
    final thickness=pipeData.s,
    redeclare package Medium = Medium,
    C=pipe.rho_default*Modelica.Constants.pi*(pipeData.Di/2)^2*pipe.cp_default)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

equation
  connect(port_a, pipe.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pipe.ports_b[:], ports_b[:])
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(pipe.heatPort, heatPort)
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
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end PipeTemplate;
