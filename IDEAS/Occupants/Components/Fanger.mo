within IDEAS.Occupants.Components;
block Fanger "Fanger model"

  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  parameter Boolean Linear=true;

  Modelica.Blocks.Interfaces.RealOutput PMV "predicted mean vote"
    annotation (Placement(transformation(extent={{90,18},{110,38}})));

  Modelica.Blocks.Interfaces.RealOutput PPD "predicted percentage dissatisfied"
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));

  Modelica.Blocks.Interfaces.RealInput Tair "zone air temperature" annotation (
      Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-100,30})));
  Modelica.Blocks.Interfaces.RealInput Trad "zone radiative temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-20})));

protected
  IDEAS.Occupants.Components.BaseClasses.PredictedPercentageDissatisfied ppd
    "PPD calculated"
    annotation (Placement(transformation(extent={{60,-36},{80,-16}})));
  IDEAS.Occupants.Components.BaseClasses.CloValue cloValue
    "clothing calculation"
    annotation (Placement(transformation(extent={{-54,60},{-34,80}})));
  IDEAS.Occupants.Components.BaseClasses.CloTemperature cloTemperature(Linear=
        Linear) "clothing surface temperature"
    annotation (Placement(transformation(extent={{-26,26},{-6,46}})));
  IDEAS.Occupants.Components.BaseClasses.PredictedMeanVote pmv(Linear=Linear)
    "pmv calculation"
    annotation (Placement(transformation(extent={{8,26},{28,46}})));
equation
  connect(ppd.PPD, PPD) annotation (Line(
      points={{80,-20},{100,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cloTemperature.Tclo, pmv.Tclo) annotation (Line(
      points={{-6,40},{8,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cloValue.CloFrac, cloTemperature.CloFrac) annotation (Line(
      points={{-34,68},{-14,68},{-14,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cloValue.CloFrac, pmv.CloFrac) annotation (Line(
      points={{-34,68},{20,68},{20,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pmv.PMV, ppd.PMV) annotation (Line(
      points={{28,40},{40,40},{40,-20},{60,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pmv.PMV, PMV) annotation (Line(
      points={{28,40},{64,40},{64,28},{100,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tair, cloTemperature.Tair) annotation (Line(
      points={{-100,30},{-40,30},{-40,-2},{-20,-2},{-20,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tair, pmv.Tair) annotation (Line(
      points={{-100,30},{-40,30},{-40,-2},{14,-2},{14,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Trad, cloTemperature.Trad) annotation (Line(
      points={{-100,-20},{-40,-20},{-40,-40},{-14,-40},{-14,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Trad, pmv.Trad) annotation (Line(
      points={{-100,-20},{-40,-20},{-40,-40},{20,-40},{20,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cloValue.RClo, cloTemperature.RClo) annotation (Line(
      points={{-34,74},{-20,74},{-20,46}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(graphics={Line(points={{-84,4},{-4,4}}, color={191,0,0}),
          Line(points={{-30,64},{-2,64}}, color={0,0,0}),Line(points={{-30,24},
          {-2,24}}, color={0,0,0}),Line(points={{-30,-16},{-2,-16}}, color={0,0,
          0}),Polygon(
          points={{-2,44},{-2,84},{0,90},{4,92},{10,94},{16,92},{20,90},{22,84},
            {22,44},{-2,44}},
          lineColor={0,0,0},
          lineThickness=0.5),Ellipse(
          extent={{-10,-94},{30,-56}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-2,44},{22,-64}},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),Line(
          points={{22,44},{22,-60}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-2,44},{-2,-60}},
          color={0,0,0},
          thickness=0.5)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end Fanger;
