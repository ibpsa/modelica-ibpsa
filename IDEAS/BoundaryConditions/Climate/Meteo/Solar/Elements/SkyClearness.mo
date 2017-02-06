within IDEAS.BoundaryConditions.Climate.Meteo.Solar.Elements;
block SkyClearness
  extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput angZen(
    quantity="Angle",
    unit="rad",
    displayUnit="degreeC") "zenith angle"
    annotation (Placement(transformation(extent={{-120,40},{-80,80}})));
  Modelica.Blocks.Interfaces.RealOutput skyCle "sky clearness"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  outer IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-80,72},{-60,92}})));

protected
final parameter Real kappa = 1.041 "original kappa of 1.014 but for degrees";
Real solDifHor "smoothed horizontal difuse radiation";

algorithm
  solDifHor := IDEAS.BaseClasses.Math.MaxSmooth(
    sim.solDifHor,
    1e-4,
    1e-5);
skyCle := smooth(1, if noEvent(sim.solGloHor < 1) then 1 else ((sim.solGloHor)/solDifHor + kappa*angZen^3) / (1 + kappa*angZen^3));

    annotation (Diagram(graphics));
end SkyClearness;
