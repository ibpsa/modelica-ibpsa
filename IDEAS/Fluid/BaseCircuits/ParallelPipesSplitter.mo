within IDEAS.Fluid.BaseCircuits;
model ParallelPipesSplitter
  "Model to split a fluid inlet into multiple outlets and back"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium 1 in the component";

  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState);

  //Parameters
  parameter Integer n(min=1) "Number of outgoing connections";
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
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    nPorts=n + 1,
    V=V) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={14,14})));
equation
  for i in 1:n loop
    connect(port_bN[i], port_a);
  end for;

  connect(port_aN, vol.ports[1:n]);
  connect(port_b, vol.ports[end]);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
                                 Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                   Line(
          points={{-100,60},{100,60}},
          color={0,0,127},
          smooth=Smooth.None), Line(
          points={{-100,-60},{100,-60}},
          color={0,0,127},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Text(
          extent={{-40,-40},{-100,40}},
          lineColor={0,0,255},
          textString="1"),
        Text(
          extent={{100,-40},{40,40}},
          lineColor={0,0,255},
          textString="n"),
        Rectangle(
          extent={{-38,2},{6,-6}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,18},{-2,-22},{38,-2},{-2,18}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>Model to split a fluid inlet into multiple outlets and back</p>
</html>"));
end ParallelPipesSplitter;
