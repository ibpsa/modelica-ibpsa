within IDEAS.Buildings.Components.Interfaces;
partial model StateShading "Window shading"

  parameter Boolean controlled=true;

  parameter Modelica.SIunits.Angle azi "window azimuth";

  Modelica.Blocks.Interfaces.RealInput solDir
    "direct solar illuminance on surface se" annotation (Placement(
        transformation(extent={{-80,30},{-40,70}}), iconTransformation(extent={
            {-60,50},{-40,70}})));
  Modelica.Blocks.Interfaces.RealInput solDif
    "diffuse solar illuminance on surface s" annotation (Placement(
        transformation(extent={{-80,-10},{-40,30}}), iconTransformation(extent=
            {{-60,10},{-40,30}})));
  Modelica.Blocks.Interfaces.RealInput angZen "angle of incidence" annotation (
      Placement(transformation(extent={{-80,-90},{-40,-50}}),
        iconTransformation(extent={{-60,-70},{-40,-50}})));
  Modelica.Blocks.Interfaces.RealOutput iSolDir
    "direct solar illuminance on surface se" annotation (Placement(
        transformation(extent={{20,30},{60,70}}), iconTransformation(extent={{
            40,50},{60,70}})));
  Modelica.Blocks.Interfaces.RealOutput iSolDif
    "diffuse solar illuminance on surface s" annotation (Placement(
        transformation(extent={{20,-10},{60,30}}), iconTransformation(extent={{
            40,10},{60,30}})));
  Modelica.Blocks.Interfaces.RealOutput iAngInc
    "angle of incidence after transmittance through shading (or not)"
    annotation (Placement(transformation(extent={{20,-70},{60,-30}}),
        iconTransformation(extent={{40,-50},{60,-30}})));

  Modelica.Blocks.Interfaces.RealInput angInc "angle of incidence" annotation (
      Placement(transformation(extent={{-80,-70},{-40,-30}}),
        iconTransformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Interfaces.RealInput angAzi "angle of incidence" annotation (
      Placement(transformation(extent={{-80,-110},{-40,-70}}),
        iconTransformation(extent={{-60,-90},{-40,-70}})));
  Modelica.Blocks.Interfaces.RealInput Ctrl if controlled
    "Control signal between 0 and 1, i.e. 1 is fully closed" annotation (
      Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-10,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-100})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-50,-100},{50,100}}), graphics={
        Polygon(
          points={{-50,80},{0,60},{4,60},{4,-20},{-50,0},{-50,80}},
          smooth=Smooth.None,
          pattern=LinePattern.None,
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{4,40},{50,20},{50,-32},{20,-20},{4,-20},{4,40}},
          smooth=Smooth.None,
          pattern=LinePattern.None,
          fillColor={179,179,179},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{0,60},{20,60},{20,80},{50,80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{0,-20},{20,-20},{20,-70},{20,-70},{50,-70}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{0,60},{0,66},{0,100},{50,100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{0,-20},{0,-90},{50,-90}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{4,60},{4,-20}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None)}));
end StateShading;
