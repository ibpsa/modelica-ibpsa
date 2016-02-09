within IDEAS.Buildings.Components.Interfaces;
partial model PartialOpaqueSurface
  "Partial component for the opaque surfaces of the building envelope"

  replaceable IDEAS.Buildings.Data.Constructions.CavityWall constructionType
    constrainedby Data.Constructions.CavityWall(final insulationType=
        insulationType, final insulationTickness=insulationThickness)
    "Type of building construction" annotation (
    __Dymola_choicesAllMatching=true,
    Placement(transformation(extent={{-34,78},{-30,82}})),
    Dialog(group="Construction details"));
  extends IDEAS.Buildings.Components.Interfaces.PartialSurface(
    intCon_a(A=AWall),
    layMul(final A=AWall,
      final nLay=constructionType.nLay,
      final mats=constructionType.mats,
      T_start=ones(constructionType.nLay)*T_start,
      nGain=constructionType.nGain));

  parameter Modelica.SIunits.Area AWall "Total wall area";

  parameter Modelica.SIunits.Length insulationThickness
    "Thermal insulation thickness"
    annotation (Dialog(group="Construction details"));

  replaceable Data.Insulation.Rockwool                 insulationType
    constrainedby Data.Insulation.Rockwool(  final d=insulationThickness)
    "Type of thermal insulation" annotation (
    __Dymola_choicesAllMatching=true,
    Placement(transformation(extent={{-34,90},{-30,94}})),
    Dialog(group="Construction details"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb[constructionType.nGain]
    "Port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDir(final Q_flow=0);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDif(final Q_flow=0);
  Modelica.Blocks.Sources.RealExpression E(y=layMul.E) if
       sim.computeConservationOfEnergy "Model internal energy";
  IDEAS.Buildings.Components.BaseClasses.PrescribedEnergy prescribedHeatFlowE if
       sim.computeConservationOfEnergy
    "Component for computing conservation of energy";
  Modelica.Blocks.Sources.RealExpression Qgai(y=layMul.port_a.Q_flow + (if sim.openSystemConservationOfEnergy
         then 0 else sum(port_emb.Q_flow))) if
     sim.computeConservationOfEnergy "Heat gains across model boundary";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlowQgai if
     sim.computeConservationOfEnergy
    "Component for computing conservation of energy";

initial equation
  assert(constructionType.incLastLay == IDEAS.Types.Tilt.Other or
    constructionType.incLastLay >= inc - Modelica.Constants.pi/3 - Modelica.Constants.eps and
    constructionType.incLastLay <= inc + Modelica.Constants.pi/3 + Modelica.Constants.eps,
    "The inclination of a wall, a floor or a ceiling does not correspond to its record.");

equation
  connect(iSolDif.port, propsBus_a.iSolDif);
  connect(iSolDir.port, propsBus_a.iSolDir);
  connect(prescribedHeatFlowE.port, propsBus_a.E);
  connect(Qgai.y,prescribedHeatFlowQgai. Q_flow);
  connect(prescribedHeatFlowQgai.port, propsBus_a.Qgai);
  connect(E.y,prescribedHeatFlowE. E);
  for i in 1:constructionType.nGain loop
    connect(layMul.port_gain[constructionType.locGain[i]], port_emb[i])
    annotation (Line(points={{0,-10},{0,-10},{0,-100}}, color={191,0,0}));
  end for;

    annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-60,-100},{60,100}})),
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
end PartialOpaqueSurface;
