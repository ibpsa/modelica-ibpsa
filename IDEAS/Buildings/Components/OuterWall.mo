within IDEAS.Buildings.Components;
model OuterWall "Opaque building envelope construction"

extends IDEAS.Buildings.Components.Interfaces.StateWall;

replaceable Data.Interfaces.Construction constructionType(insulationType=insulationType, insulationTickness=insulationTickness)
    "Type of building construction" annotation (choicesAllMatching = true, Placement(transformation(extent={{-38,72},
            {-34,76}})));
replaceable Data.Interfaces.Insulation insulationType
    "Type of thermal insulation" annotation (choicesAllMatching = true, Placement(transformation(extent={{-38,84},
            {-34,88}})));

parameter Modelica.SIunits.Length insulationTickness
    "Thermal insulation thickness";
parameter Modelica.SIunits.Area AWall "Total wall area";
parameter Modelica.SIunits.Angle inc
    "Inclination of the wall, i.e. 90° denotes vertical";
parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0° denotes South";

public
  IDEAS.Buildings.Components.BaseClasses.SummaryWall summary(Qloss=-surfCon_a.Q_flow
         - surfRad_a.Q_flow, QSolIrr=radSol.solDir/AWall + radSol.solDif/AWall)
    "Summary of the thermal response";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb
    "port for gains by embedded active layers"
  annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

protected
  IDEAS.Climate.Meteo.Solar.RadSol  radSol(inc=inc,azi=azi,A=AWall)
    "determination of incident solar radiation on wall based on inclination and azimuth"
    annotation (Placement(transformation(extent={{-48,-42},{-36,-30}})));
  IDEAS.Buildings.Components.BaseClasses.MultiLayerOpaque layMul(
    A=AWall,
    inc=inc,
    nLay=constructionType.nLay,
    mats=constructionType.mats)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{-2,-40},{18,-20}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorConvection extCon(A=AWall)
    "convective surface heat transimission on the exterior side of the wall"
    annotation (Placement(transformation(extent={{-18,-60},{-30,-48}})));
  IDEAS.Buildings.Components.BaseClasses.InteriorConvection intCon(A=AWall, inc=inc)
    "convective surface heat transimission on the interior side of the wall"
    annotation (Placement(transformation(extent={{28,-36},{40,-24}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorSolarAbsorption solAbs(A=AWall)
    "determination of absorbed solar radiation by wall based on incident radiation"
 annotation (Placement(transformation(extent={{-18,-42},{-30,-30}})));
  IDEAS.Buildings.Components.BaseClasses.ExteriorHeatRadidation extRad(A=AWall, inc=
        inc)
    "determination of radiant heat exchange with the environment and sky"
    annotation (Placement(transformation(extent={{-18,-24},{-30,-12}})));

public
  Modelica.Blocks.Sources.Constant const(k=AWall)
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={8,-2})));
equation
  connect(radSol.solDir, solAbs.solDir) annotation (Line(
      points={{-36,-32.4},{-34,-32},{-34,-32.4},{-30,-32.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radSol.solDif, solAbs.solDif) annotation (Line(
      points={{-36,-34.8},{-30,-34.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extCon.port_a, layMul.port_a)          annotation (Line(
      points={{-18,-54},{-8,-54},{-8,-30},{-2,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(solAbs.port_a, layMul.port_a)        annotation (Line(
      points={{-18,-36},{-8,-36},{-8,-30},{-2,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(extRad.port_a, layMul.port_a)        annotation (Line(
      points={{-18,-18},{-8,-18},{-8,-30},{-2,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, intCon.port_a)
                                      annotation (Line(
      points={{18,-30},{28,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_a, solAbs.epsSw) annotation (Line(
      points={{-2,-26},{-14,-26},{-14,-32.4},{-18,-32.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_a,extRad. epsLw) annotation (Line(
      points={{-2,-22},{-14,-22},{-14,-14.4},{-18,-14.4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(port_emb, layMul.port_gain[constructionType.locGain]) annotation (Line(
      points={{0,-100},{0,-60},{8,-60},{8,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(intCon.port_b, surfCon_a) annotation (Line(
      points={{40,-30},{50,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.port_b, surfRad_a) annotation (Line(
      points={{18,-30},{24,-30},{24,-60},{50,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsLw_b, iEpsLw_a) annotation (Line(
      points={{18,-22},{20,-22},{20,-22},{24,-22},{24,30},{56,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_b, iEpsSw_a) annotation (Line(
      points={{18,-26},{26,-26},{26,0},{56,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, area_a) annotation (Line(
      points={{8,9},{8,60},{56,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-50,-100},
            {50,100}}),
                   graphics={
        Line(
          points={{-50,60},{-38,60},{-38,88},{50,88}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,60},{-50,66},{-50,100},{50,100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-50,-100},{50,-100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-20},{-38,-20},{-38,-88},{-36,-88},{50,-88}},
          color={95,95,95},
          smooth=Smooth.None),
        Rectangle(
          extent={{-38,-20},{-50,-88}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,60},{-50,100}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,88},{50,100}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-46,60},{-46,-20}},
          color={95,95,95},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=true,
          extent={{-50,-100},{50,100}}), graphics));
end OuterWall;
