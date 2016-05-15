within IDEAS.BoundaryConditions.Climate.Interfaces;
expandable connector PropsBus "Bus to transfer wall properties"
  extends Modelica.Icons.SignalBus;

  Modelica.SIunits.Area area;
  Modelica.SIunits.Emissivity epsLw;
  Modelica.SIunits.Emissivity epsSw;

end PropsBus;
