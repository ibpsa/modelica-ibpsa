within IDEAS.Templates.Interfaces.BaseClasses;
partial model InhomeFeeder

  extends Modelica.Icons.ObsoleteModel;

  parameter Integer nHeatingLoads(min=1)
    "number of electric loads for the heating system";
  parameter Integer nVentilationLoads(min=1)
    "number of electric loads for the ventilation system";
  parameter Integer nOccupantLoads(min=1)
    "number of electric loads for the occupants";
  parameter Integer numberOfPhazes=1
    "The number of phazes connected in the home" annotation (choices(choice=1
        "Single phaze grid connection", choice=4
        "threephaze (4 line) grid connection"));

  inner outer IDEAS.BoundaryConditions.SimInfoManager sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin
    plugFeeder[numberOfPhazes]
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[
    nVentilationLoads] plugVentilationLoad
    "Electricity connection for the ventilaiton system"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[
    nHeatingLoads] plugHeatingLoad
    "Electricity connection for the heating system"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug[
    nOccupantLoads] plugOccupantLoad "Electricity connection for the occupants"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  annotation (Icon(graphics), Diagram(graphics));

end InhomeFeeder;
