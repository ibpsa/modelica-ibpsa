within IDEAS.Buildings.Components.Interfaces;
partial model PartialOpaqueSurface
  "Partial component for the opaque surfaces of the building envelope"

  replaceable parameter IDEAS.Buildings.Data.Constructions.CavityWall constructionType
    constrainedby IDEAS.Buildings.Data.Interfaces.Construction(
      final insulationType=insulationType,
      final insulationTickness=insulationThickness)
    "Building component material structure" annotation (
    __Dymola_choicesAllMatching=true,
    Placement(transformation(extent={{-34,78},{-30,82}})),
    Dialog(group="Construction details"));
  extends IDEAS.Buildings.Components.Interfaces.PartialSurface(
    E(y=layMul.E),
    Qgai(y=layMul.port_b.Q_flow + (if sim.openSystemConservationOfEnergy
         then 0 else sum(port_emb.Q_flow))),
    intCon_a(A=AWall),
    layMul(final A=AWall,
      final nLay=constructionType.nLay,
      final mats=constructionType.mats,
      T_start=ones(constructionType.nLay)*T_start,
      nGain=constructionType.nGain));

  replaceable parameter IDEAS.Buildings.Data.Insulation.Rockwool insulationType
    constrainedby IDEAS.Buildings.Data.Interfaces.Insulation(
      final d=insulationThickness)
    "Thermal insulation type, propagated into constructionType" annotation (
    __Dymola_choicesAllMatching=true,
    Placement(transformation(extent={{-34,90},{-30,94}})),
    Dialog(group="Construction details"));

  parameter Modelica.SIunits.Area AWall
    "Component surface area";
  parameter Modelica.SIunits.Length insulationThickness
    "Thermal insulation thickness"
    annotation (Dialog(group="Construction details"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_emb[constructionType.nGain]
    "Port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDir(final Q_flow=0);
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow iSolDif(final Q_flow=0);

initial equation
  assert(IDEAS.Utilities.Math.Functions.isAngle(constructionType.incLastLay, IDEAS.Types.Tilt.Other) or
    constructionType.incLastLay >= inc - Modelica.Constants.pi/3 - Modelica.Constants.eps and
    constructionType.incLastLay <= inc + Modelica.Constants.pi/3 + Modelica.Constants.eps,
    "The inclination of a wall, a floor or a ceiling does not correspond to its record.");

equation
  connect(iSolDif.port, propsBus_a.iSolDif);
  connect(iSolDir.port, propsBus_a.iSolDir);

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
February 10, 2016, by Filip Jorissen and Damien Picard:<br/>
Revised implementation: cleaned up connections and partials.
</li>
<li>
February 6, 2016 by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialOpaqueSurface;
