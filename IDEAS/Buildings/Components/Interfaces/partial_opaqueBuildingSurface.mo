within IDEAS.Buildings.Components.Interfaces;
partial model partial_opaqueBuildingSurface
  "Partial component for the opaque surfaces of the building envelope"
  extends partial_buildingSurface(intCon_a(A=AWall));

  parameter Modelica.SIunits.Area AWall "Total wall area";

  parameter Modelica.SIunits.Length insulationThickness
    "Thermal insulation thickness"
    annotation (Dialog(group="Construction details"));
  replaceable Data.Constructions.CavityWall                 constructionType
    constrainedby Data.Constructions.CavityWall(
                                               final insulationType=
        insulationType, final insulationTickness=insulationThickness)
    "Type of building construction" annotation (
    __Dymola_choicesAllMatching=true,
    Placement(transformation(extent={{-34,78},{-30,82}})),
    Dialog(group="Construction details"));
  replaceable Data.Insulation.Rockwool                 insulationType
    constrainedby Data.Insulation.Rockwool(  final d=insulationThickness)
    "Type of thermal insulation" annotation (
    __Dymola_choicesAllMatching=true,
    Placement(transformation(extent={{-34,90},{-30,94}})),
    Dialog(group="Construction details"));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDir(Q_flow=0)
    annotation (Placement(transformation(extent={{82,66},{62,86}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDif(Q_flow=0)
    annotation (Placement(transformation(extent={{82,84},{62,104}})));
protected
  BaseClasses.MultiLayerOpaque                layMul(
    final inc=inc,
    final A=AWall,
    final nLay=constructionType.nLay,
    final mats=constructionType.mats,
    final locGain=constructionType.locGain,
    T_start=ones(constructionType.nLay)*T_start,
      nGain=constructionType.nGain)
    "declaration of array of resistances and capacitances for wall simulation"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));

  Modelica.Blocks.Sources.RealExpression E(y=layMul.E) if
       sim.computeConservationOfEnergy "Internal energy model"
    annotation (Placement(transformation(extent={{-16,84},{4,104}})));
  BaseClasses.PrescribedEnergy                            prescribedHeatFlowE if
       sim.computeConservationOfEnergy
    "Component for computing conservation of energy"
    annotation (Placement(transformation(extent={{14,84},{34,104}})));
  Modelica.Blocks.Sources.RealExpression Qgai(y=layMul.port_a.Q_flow + (if sim.openSystemConservationOfEnergy
         then 0 else sum(port_emb.Q_flow))) if
     sim.computeConservationOfEnergy "Heat gains in model"
    annotation (Placement(transformation(extent={{-16,66},{4,86}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlowQgai if
     sim.computeConservationOfEnergy
    "Component for computing conservation of energy"
    annotation (Placement(transformation(extent={{14,66},{34,86}})));
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb[constructionType.nGain]
    "Port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Sources.RealExpression incExp(y=inc) "Inclination angle"
    annotation (Placement(transformation(extent={{84,118},{64,138}})));
  Modelica.Blocks.Sources.RealExpression aziExp(y=azi)
    "Azimuth angle expression"
    annotation (Placement(transformation(extent={{84,104},{64,124}})));
equation
      connect(layMul.port_a, propsBus_a.surfRad) annotation (Line(
      points={{10,0},{14,0},{14,39.9},{50.1,39.9}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(layMul.port_a,intCon_a. port_a) annotation (Line(
      points={{10,0},{20,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(layMul.iEpsSw_a, propsBus_a.epsSw) annotation (Line(
      points={{10,4},{18,4},{18,39.9},{50.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(layMul.iEpsLw_a, propsBus_a.epsLw) annotation (Line(
      points={{10,8},{14,8},{14,39.9},{50.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(layMul.area, propsBus_a.area) annotation (Line(
      points={{0,10},{0,39.9},{50.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(iSolDif.port, propsBus_a.iSolDif) annotation (Line(
      points={{62,94},{50,94},{50,39.9},{50.1,39.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(iSolDir.port, propsBus_a.iSolDir) annotation (Line(
      points={{62,76},{50,76},{50,39.9},{50.1,39.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlowE.port, propsBus_a.E) annotation (Line(points={{34,94},
          {50,94},{50,39.9},{50.1,39.9}},     color={191,0,0}));
  connect(Qgai.y,prescribedHeatFlowQgai. Q_flow)
    annotation (Line(points={{5,76},{5,76},{14,76}},
                                              color={0,0,127}));
  connect(prescribedHeatFlowQgai.port, propsBus_a.Qgai)
    annotation (Line(points={{34,76},{50.1,76},{50.1,39.9}}, color={191,0,0}));
  connect(E.y,prescribedHeatFlowE. E)
    annotation (Line(points={{5,94},{14,94}},         color={0,0,127}));
  connect(port_emb, layMul.port_gain)
    annotation (Line(points={{0,-100},{0,-100},{0,-10}}, color={191,0,0}));
  connect(aziExp.y, propsBus_a.azi) annotation (Line(
      points={{63,114},{50.1,114},{50.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incExp.y, propsBus_a.inc) annotation (Line(
      points={{63,128},{50.1,128},{50.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-60,-100},{60,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-50,-100},{50,100}}),
        graphics),
    Documentation(revisions="<html>
<ul>
<li>
February 6, 2016 by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end partial_opaqueBuildingSurface;
