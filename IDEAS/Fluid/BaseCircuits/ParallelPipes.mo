within IDEAS.Fluid.BaseCircuits;
model ParallelPipes
  "Model to split a fluid inlet into multiple outlets and back"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component";

  //Parameters
  parameter Integer nPipes(min=1) "Number of outgoing connections";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal flow rate";
  parameter Modelica.SIunits.Volume V "Volume of the piping";

  //Components
  Modelica.Fluid.Interfaces.FluidPort_b port_bN[n](
    redeclare final package Medium = Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,50},{110,70}},
            rotation=0), iconTransformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aN[n](
    redeclare final package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-70},{90,-50}},rotation=
             0), iconTransformation(extent={{110,-70},{90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium =Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}},
          rotation=0), iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}},
                                                                      rotation=0),
        iconTransformation(extent={{-90,-70},{-110,-50}})));
  IDEAS.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nPorts=n + 1,
    V=V) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={14,14})));
equation
  for i in 1:nPipes loop
    connect(port_bN[i], port_a);
  end for;

  connect(port_aN, vol.ports[1:nPipes]);
  connect(port_b, vol.ports[end]);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
                                 Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
                                   Line(
          points={{-100,60},{100,60}},
          color={0,0,127},
          smooth=Smooth.None), Line(
          points={{-100,-60},{100,-60}},
          color={0,0,127},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Text(
          extent={{-20,-40},{-80,40}},
          lineColor={0,0,255},
          textString="1"),
        Text(
          extent={{80,-40},{20,40}},
          lineColor={0,0,255},
          textString="n")}));

end ParallelPipes;
