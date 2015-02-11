within IDEAS.Buildings.Components.Interfaces;
partial model StateWallNoSol
  "Partial model for building envelope components without solar gains"
  parameter Modelica.SIunits.Angle inc
    "Inclination of the window, i.e. 90deg denotes vertical";
  parameter Modelica.SIunits.Angle azi
    "Azimuth of the wall, i.e. 0deg denotes South";
  parameter Modelica.SIunits.Length insulationThickness
    "Thermal insulation thickness"
    annotation (Dialog(group="Construction details"));
  replaceable IDEAS.Buildings.Data.Constructions.CavityWall constructionType
    constrainedby Data.Interfaces.Construction(final insulationType=
        insulationType, final insulationTickness=insulationThickness)
    "Type of building construction" annotation (
    __Dymola_choicesAllMatching=true,
    Placement(transformation(extent={{-38,72},{-34,76}})),
    Dialog(group="Construction details"));
  replaceable IDEAS.Buildings.Data.Insulation.Rockwool insulationType
    constrainedby Data.Interfaces.Insulation(final d=insulationThickness)
    "Type of thermal insulation" annotation (
    __Dymola_choicesAllMatching=true,
    Placement(transformation(extent={{-38,84},{-34,88}})),
    Dialog(group="Construction details"));
  ZoneBus propsBus_a annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={50,40})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDir(Q_flow=0)
    annotation (Placement(transformation(extent={{80,54},{60,74}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDif(Q_flow=0)
    annotation (Placement(transformation(extent={{80,72},{60,92}})));
  Modelica.Blocks.Sources.RealExpression incExp(y=inc) "Inclination angle"
    annotation (Placement(transformation(extent={{100,42},{80,62}})));
  Modelica.Blocks.Sources.RealExpression aziExp(y=azi)
    "Azimuth angle expression"
    annotation (Placement(transformation(extent={{100,26},{80,46}})));
equation
  connect(iSolDif.port, propsBus_a.iSolDif) annotation (Line(
      points={{60,82},{46,82},{46,40},{50,40}},
      color={191,0,0},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(iSolDir.port, propsBus_a.iSolDir) annotation (Line(
      points={{60,64},{56,64},{56,40},{50,40}},
      color={191,0,0},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(aziExp.y, propsBus_a.azi) annotation (Line(
      points={{79,36},{50,36},{50,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incExp.y, propsBus_a.inc) annotation (Line(
      points={{79,52},{50,52},{50,40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-50,-100},{50,100}}), graphics));
end StateWallNoSol;
