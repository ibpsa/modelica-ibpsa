within IDEAS.Buildings.Components;
model InternalWall "interior opaque wall between two zones"

extends IDEAS.Buildings.Components.Interfaces.StateWall;

replaceable Data.Interfaces.Construction constructionType(insulationType=insulationType, insulationTickness=insulationThickness)
    "Type of building construction" annotation (choicesAllMatching = true, Placement(transformation(extent={{-38,72},
            {-34,76}})));
replaceable Data.Interfaces.Insulation insulationType(d=insulationThickness)
    "Type of thermal insulation" annotation (choicesAllMatching = true, Placement(transformation(extent={{-38,84},
            {-34,88}})));
parameter Modelica.SIunits.Length insulationThickness
    "Thermal insulation thickness";
parameter Modelica.SIunits.Area AWall "Total wall area";
parameter Modelica.SIunits.Angle inc
    "Inclination of the wall, i.e. 90° denotes vertical";
parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0° denotes South";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surfCon_b
    "convective nod on the inside"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b surfRad_b
    "rad.node on the inside"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsLw_b
    annotation (Placement(transformation(extent={{-46,20},{-66,40}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsSw_b
    "output of the interior emissivity for radiative heat losses"
    annotation (Placement(transformation(extent={{-46,-10},{-66,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb
    "port for gains by embedded active layers"
  annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Interfaces.RealOutput area_b "output of the area"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-56,60})));

protected
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection intCon_b(A=AWall, inc=
        inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection intCon_a(A=AWall, inc=
        inc + Modelica.Constants.pi)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.MultiLayerOpaque layMul(
    A=AWall,
    inc=inc,
    nLay=constructionType.nLay,
    mats=constructionType.mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{10,-40},{-10,-20}})));

equation
  connect(layMul.port_a, surfRad_a) annotation (Line(
      points={{10,-30},{14,-30},{14,-60},{50,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, surfRad_b) annotation (Line(
      points={{-10,-30},{-12,-30},{-12,-60},{-50,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(surfCon_b, intCon_b.port_b) annotation (Line(
      points={{-50,-30},{-40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(surfCon_a, intCon_a.port_b) annotation (Line(
      points={{50,-30},{40,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_gain[constructionType.locGain], port_emb) annotation (Line(
      points={{0,-40},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon_b.port_a, layMul.port_b) annotation (Line(
      points={{-20,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_a, intCon_a.port_a) annotation (Line(
      points={{10,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_a, iEpsLw_a) annotation (Line(
      points={{10,-22},{14,-22},{14,30},{56,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_a, iEpsSw_a) annotation (Line(
      points={{10,-26},{16,-26},{16,0},{56,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw_b) annotation (Line(
      points={{-10,-22},{-14,-22},{-14,30},{-56,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw_b) annotation (Line(
      points={{-10,-26},{-16,-26},{-16,0},{-56,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.area, area_b) annotation (Line(
      points={{0,-20},{0,60},{-56,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.area, area_a) annotation (Line(
      points={{0,-20},{0,60},{56,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},
            {50,100}}), graphics={
        Rectangle(
          extent={{-10,80},{10,-70}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{-50,80},{50,80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-70},{50,-70}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-90},{50,-90}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,100},{50,100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-10,80},{-10,-70}},
          smooth=Smooth.None,
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{10,80},{10,-70}},
          smooth=Smooth.None,
          color={0,0,0},
          thickness=0.5)}),      Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-100},{50,100}}), graphics));
end InternalWall;
