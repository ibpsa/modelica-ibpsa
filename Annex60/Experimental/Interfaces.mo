within Annex60.Experimental;
package Interfaces "Interfaces for district heating network"
  // Originally at https://github.com/arnoutaertgeerts/DistrictHeating
  // First implementation by Arnout Aertgeerts
  extends Modelica.Icons.InterfacesPackage;

  model DHConnection

    //Extensions
    extends IDEAS.Fluid.BaseCircuits.Interfaces.CircuitInterface(
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState);
    extends DistrictHeating.Pipes.BaseClasses.DistrictHeatingPipeParameters;

    extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(
      dp_nominal=dp_nominal_meter*L);

    //Parameters
    parameter DistrictHeating.Pipes.Types.PressurePerLength dp_nominal_meter=20
      "Nominal pressure drop/meter over the pipe";
    parameter Integer tau = 120 "Time constant of the temperature sensors";

    Modelica.SIunits.Energy QLosses;

    //Components
    replaceable DistrictHeating.Pipes.BaseClasses.PartialDistrictHeatingPipe districtHeatingPipe(
      redeclare package Medium = Medium,
      final L=L,
      final H=H,
      final E=E,
      final Do=Do,
      final Di=Di,
      final Dc=Dc,
      final lambdaG=lambdaG,
      final lambdaI=lambdaI,
      final lambdaGS=lambdaGS,
      final massDynamics=massDynamics,
      final energyDynamics=energyDynamics,
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=dp_nominal,
      computeFlowResistance=computeFlowResistance,
      from_dp=from_dp,
      linearizeFlowResistance=linearizeFlowResistance,
      deltaM=deltaM,
      allowFlowReversal=allowFlowReversal) constrainedby
      DistrictHeating.Pipes.BaseClasses.PartialDistrictHeatingPipe(
      redeclare package Medium = Medium,
      massDynamics=massDynamics,
      energyDynamics=energyDynamics,
      L=L,
      H=H,
      E=E,
      Do=Do,
      Di=Di,
      Dc=Dc,
      lambdaG=lambdaG,
      lambdaI=lambdaI,
      lambdaGS=lambdaGS,
      m_flow_nominal=m_flow_nominal,
      dp_nominal=dp_nominal) annotation (Placement(transformation(extent={{-50,40},
              {-30,68}})), choicesAllMatching=true);

    Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Tground)
      annotation (Placement(transformation(extent={{-14,10},{-34,30}})));
    outer IDEAS.SimInfoManager sim
      annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_a3(redeclare package Medium =
          Medium)
      "Fluid connector a2 (positive design flow direction is from port_a2 to port_b2)"
      annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_b3(redeclare package Medium =
          Medium)
      "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
      annotation (Placement(transformation(extent={{10,90},{30,110}})));
  equation

    QLosses = districtHeatingPipe.Q1 + districtHeatingPipe.Q2;

    connect(realExpression.y, districtHeatingPipe.Tg) annotation (Line(
        points={{-35,20},{-40,20},{-40,39.8}},
        color={0,0,127},
        smooth=Smooth.None));

    connect(port_a1, districtHeatingPipe.port_a1) annotation (Line(
        points={{-100,60},{-50,60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(districtHeatingPipe.port_b1, port_b1) annotation (Line(
        points={{-30,60},{100,60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(districtHeatingPipe.port_a2, port_a2) annotation (Line(
        points={{-30,48},{0,48},{0,-60},{100,-60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(districtHeatingPipe.port_b2, port_b2) annotation (Line(
        points={{-50,48},{-60,48},{-60,-60},{-100,-60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(port_a2, port_a2) annotation (Line(
        points={{100,-60},{100,-60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(port_a2, port_a3) annotation (Line(
        points={{100,-60},{0,-60},{0,48},{-20,48},{-20,100}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(port_b1, port_b1) annotation (Line(
        points={{100,60},{100,60}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(port_b1, port_b3) annotation (Line(
        points={{100,60},{20,60},{20,100}},
        color={0,127,255},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), Icon(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                 graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={135,135,135},
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255}),
          Polygon(
            points={{15,11},{-15,1},{15,-11},{15,11}},
            smooth=Smooth.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.HorizontalCylinder,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            origin={-19,-45},
            rotation=90),
          Polygon(
            points={{15,11},{-15,1},{15,-11},{15,11}},
            smooth=Smooth.None,
            fillColor={0,0,255},
            fillPattern=FillPattern.HorizontalCylinder,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            origin={-75,-61},
            rotation=360),
          Polygon(
            points={{11,7},{-11,1},{11,-7},{11,7}},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.HorizontalCylinder,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            origin={-19,-41},
            rotation=90),
          Polygon(
            points={{-15,9},{15,-1},{-15,-11},{-15,9}},
            smooth=Smooth.None,
            fillColor={255,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            origin={75,61},
            rotation=360),
          Polygon(
            points={{-11,5},{9,-1},{-11,-7},{-11,5}},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.HorizontalCylinder,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            origin={-71,59},
            rotation=180),
          Polygon(
            points={{-15,9},{15,-1},{-15,-11},{-15,9}},
            smooth=Smooth.None,
            fillColor={255,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            origin={19,77},
            rotation=90),
          Polygon(
            points={{-11,5},{9,-1},{-11,-7},{-11,5}},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.HorizontalCylinder,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            origin={19,73},
            rotation=90),
          Line(
            points={{20,100},{20,60}},
            color={255,0,0},
            smooth=Smooth.None),
          Polygon(
            points={{11,7},{-11,1},{11,-7},{11,7}},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.HorizontalCylinder,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            origin={-71,-61},
            rotation=360),
          Line(
            points={{-20,100},{-20,20}},
            color={0,0,255},
            smooth=Smooth.None),
          Line(
            points={{102,-60},{-100,-60}},
            color={0,0,255},
            smooth=Smooth.None),
          Ellipse(
            extent={{18,62},{22,58}},
            lineColor={255,0,0},
            fillColor={255,0,0},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-22,-58},{-18,-62}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-42,-18},{114,14}},
            lineColor={135,135,135},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="%L m
"),       Polygon(
            points={{11,7},{-11,1},{11,-7},{11,7}},
            smooth=Smooth.None,
            fillColor={255,255,255},
            fillPattern=FillPattern.HorizontalCylinder,
            pattern=LinePattern.None,
            lineColor={0,0,0},
            origin={67,61},
            rotation=180),
          Line(
            points={{-94,60},{90,60}},
            color={255,0,0},
            smooth=Smooth.None),
          Line(
            points={{-20,20},{-20,-60}},
            color={0,0,255},
            smooth=Smooth.None)}));
  end DHConnection;

end Interfaces;
