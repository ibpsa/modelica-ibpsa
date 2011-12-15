within IDEAS.Buildings.Components;
model OuterWall "Opaque building envelope construction"

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

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb
    "port for gains by embedded active layers"
  annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

protected
  IDEAS.Climate.Meteo.Solar.RadSol  radSol(inc=inc,azi=azi,A=AWall)
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
  IDEAS.Buildings.Components.BaseClasses.MultiLayerOpaque layMul(
    A=AWall,
    inc=inc,
    nLay=constructionType.nLay,
    mats=constructionType.mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorConvection extCon(A=AWall)
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-20,-60},{-40,-40}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection intCon(A=AWall, inc=inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorSolarAbsorption solAbs(A=AWall)
    "determination of absorbed solar radiation by wall based on incident radiation"
 annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorHeatRadidation extRad(A=AWall, inc=
        inc)
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-20,-20},{-40,0}})));

public
  Modelica.Blocks.Sources.Constant const(k=AWall)
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,10})));
equation
  connect(radSol.solDir, solAbs.solDir) annotation (Line(
      points={{-50,-24},{-40,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDif, solAbs.solDif) annotation (Line(
      points={{-50,-28},{-40,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extCon.port_a, layMul.port_a)          annotation (Line(
      points={{-20,-50},{-16,-50},{-16,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solAbs.port_a, layMul.port_a)        annotation (Line(
      points={{-20,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extRad.port_a, layMul.port_a)        annotation (Line(
      points={{-20,-10},{-16,-10},{-16,-30},{-10,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, intCon.port_a)
                                      annotation (Line(
      points={{10,-30},{20,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_a, solAbs.epsSw) annotation (Line(
      points={{-10,-26},{-14,-26},{-14,-24},{-20,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_a,extRad. epsLw) annotation (Line(
      points={{-10,-22},{-14,-22},{-14,-4},{-20,-4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(port_emb, layMul.port_gain[constructionType.locGain]) annotation (Line(
      points={{0,-100},{0,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon.port_b, surfCon_a) annotation (Line(
      points={{40,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, surfRad_a) annotation (Line(
      points={{10,-30},{16,-30},{16,-60},{50,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw_a) annotation (Line(
      points={{10,-22},{14,-22},{14,30},{56,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw_a) annotation (Line(
      points={{10,-26},{16,-26},{16,0},{56,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, area_a) annotation (Line(
      points={{6.73556e-016,21},{6.73556e-016,60},{56,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},
            {50,100}}),
                   graphics={
        Polygon(
          points={{-50,60},{-30,60},{-30,80},{50,80},{50,100},{-50,100},{-50,60}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-30,-70},{-50,-20}},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(
          points={{-50,60},{-50,66},{-50,100},{50,100}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-30,60},{-30,80},{50,80}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-30,-20},{-30,-70},{-30,-70},{52,-70}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-50,-90},{50,-90}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-44,60},{-30,60},{-30,80},{-28,80},{50,80}},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-44,-20},{-30,-20},{-30,-70}},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-44,60},{-44,-20}},
          smooth=Smooth.None,
          color={175,175,175})}),Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}),
                                         graphics));
end OuterWall;
