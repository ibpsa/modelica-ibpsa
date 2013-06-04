within IDEAS.Thermal.Components;
package Distribution "Not verified, not validated"

  extends Modelica.Icons.Package;

  model Manifold "Radiant manifold"

    parameter Thermal.Data.Interfaces.Medium medium=Data.Interfaces.Medium()
      "Medium in the component"
      annotation(choicesAllMatching=true);

  parameter Boolean[6] open = {true, true, true, true, true, true};

    IDEAS.Thermal.Components.Interfaces.FlowPort_a
                          flowPort_a(medium=medium)
      annotation (Placement(transformation(extent={{-110,40},{-90,60}},
            rotation=0), iconTransformation(extent={{-110,40},{-90,60}})));

    IDEAS.Thermal.Components.Interfaces.FlowPort_b
                          flowPort_b1(medium=medium) if open[1]
      annotation (Placement(transformation(extent={{-48,-50},{-28,-30}},
            rotation=0), iconTransformation(extent={{-80,-50},{-60,-30}})));

   IDEAS.Thermal.Components.Interfaces.FlowPort_b
                          flowPort_b2(medium=medium) if open[2]
      annotation (Placement(transformation(extent={{-30,-50},{-10,-30}},
            rotation=0), iconTransformation(extent={{-40,-50},{-20,-30}})));

    IDEAS.Thermal.Components.Interfaces.FlowPort_b
                          flowPort_b3(medium=medium) if open[3]
      annotation (Placement(transformation(extent={{-10,-50},{10,-30}},
            rotation=0), iconTransformation(extent={{0,-50},{20,-30}})));

    IDEAS.Thermal.Components.Interfaces.FlowPort_b
                          flowPort_b4(medium=medium) if open[4]
      annotation (Placement(transformation(extent={{10,-50},{30,-30}},
            rotation=0), iconTransformation(extent={{40,-50},{60,-30}})));

    IDEAS.Thermal.Components.Interfaces.FlowPort_b
                          flowPort_b5(medium=medium) if open[5]
      annotation (Placement(transformation(extent={{30,-50},{50,-30}},
            rotation=0), iconTransformation(extent={{80,-50},{100,-30}})));

    IDEAS.Thermal.Components.Interfaces.FlowPort_b
                          flowPort_b6(medium=medium) if open[6]
      annotation (Placement(transformation(extent={{50,-50},{70,-30}},
            rotation=0), iconTransformation(extent={{120,-50},{140,-30}})));
  equation
    connect(flowPort_a, flowPort_b1) annotation (Line(
        points={{-100,50},{-100,-40},{-38,-40}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(flowPort_a, flowPort_b2) annotation (Line(
        points={{-100,50},{-20,50},{-20,-40}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(flowPort_a, flowPort_b3) annotation (Line(
        points={{-100,50},{0,50},{0,-40},{0,-40}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(flowPort_a, flowPort_b4) annotation (Line(
        points={{-100,50},{20,50},{20,-40}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(flowPort_a, flowPort_b5) annotation (Line(
        points={{-100,50},{40,50},{40,-40}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(flowPort_a, flowPort_b6) annotation (Line(
        points={{-100,50},{60,50},{60,-40}},
        color={255,0,0},
        smooth=Smooth.None));
    annotation (Icon(coordinateSystem(extent={{-100,-40},{160,60}},
            preserveAspectRatio=true),
                     graphics={
          Line(
            points={{-30,-16},{-30,-40}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{-40,30},{-20,30},{-40,-10},{-20,-10},{-40,30}},
            color={100,100,100},
            smooth=Smooth.None),
          Line(
            points={{-40,-16},{-20,-16}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{-40,36},{-20,36}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{-100,50},{160,50}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{-30,36},{-30,50}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{10,36},{10,50}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{0,36},{20,36}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{0,30},{20,30},{0,-10},{20,-10},{0,30}},
            color={100,100,100},
            smooth=Smooth.None),
          Line(
            points={{0,-16},{20,-16}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{10,-16},{10,-40}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{50,36},{50,50}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{40,36},{60,36}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{40,30},{60,30},{40,-10},{60,-10},{40,30}},
            color={100,100,100},
            smooth=Smooth.None),
          Line(
            points={{40,-16},{60,-16}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{50,-16},{50,-40}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{90,36},{90,50}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{80,36},{100,36}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{80,30},{100,30},{80,-10},{100,-10},{80,30}},
            color={100,100,100},
            smooth=Smooth.None),
          Line(
            points={{80,-16},{100,-16}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{90,-16},{90,-40}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{130,36},{130,50}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{120,36},{140,36}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{120,30},{140,30},{120,-10},{140,-10},{120,30}},
            color={100,100,100},
            smooth=Smooth.None),
          Line(
            points={{120,-16},{140,-16}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{130,-16},{130,-40}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{-70,36},{-70,50}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{-80,36},{-60,36}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{-80,30},{-60,30},{-80,-10},{-60,-10},{-80,30}},
            color={100,100,100},
            smooth=Smooth.None),
          Line(
            points={{-80,-16},{-60,-16}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{-70,-16},{-70,-40}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{160,60},{160,40}},
            color={0,0,127},
            smooth=Smooth.None)}),                         Diagram(
          coordinateSystem(extent={{-100,-40},{160,60}}),          graphics));
  end Manifold;

  model ThreeWayValve "Temperature based ideal mixer"

    parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

  public
    Thermal.Components.Interfaces.FlowPort_a flowPort_a(medium=medium, h(
        start=293.15*medium.cp,
        min=1140947,
        max=1558647))
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
          iconTransformation(extent={{-110,-10},{-90,10}})));

    Thermal.Components.Interfaces.FlowPort_a flowPort_b2(medium=medium, h(
        start=293.15*medium.cp,
        min=1140947,
        max=1558647))
      annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
          iconTransformation(extent={{-10,-110},{10,-90}})));

    Thermal.Components.Interfaces.FlowPort_a flowPort_b1(medium=medium, h(
        start=293.15*medium.cp,
        min=1140947,
        max=1558647))
      annotation (Placement(transformation(extent={{90,-10},{110,10}}),
          iconTransformation(extent={{90,-10},{110,10}})));

  equation
    connect(flowPort_a, flowPort_b1) annotation (Line(
        points={{-100,0},{100,0}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(flowPort_a, flowPort_b2) annotation (Line(
        points={{-100,0},{0,0},{0,-100}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (Diagram(graphics), Icon(graphics={
          Polygon(
            points={{-60,30},{-60,-30},{0,0},{-60,30}},
            lineColor={100,100,100},
            smooth=Smooth.None),
          Polygon(
            points={{60,30},{60,-30},{0,0},{60,30}},
            lineColor={100,100,100},
            smooth=Smooth.None),
          Polygon(
            points={{-30,30},{-30,-30},{30,0},{-30,30}},
            lineColor={100,100,100},
            smooth=Smooth.None,
            origin={0,-30},
            rotation=90),
          Line(
            points={{-70,30},{-70,-30}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{70,30},{70,-30}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{-30,-70},{30,-70}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{-70,0},{-100,0}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{70,0},{100,0}},
            color={0,0,127},
            smooth=Smooth.None),
          Line(
            points={{0,-70},{0,-100}},
            color={0,0,127},
            smooth=Smooth.None)}));
  end ThreeWayValve;
end Distribution;
