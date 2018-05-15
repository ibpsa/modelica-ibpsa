within IDEAS.LIDEAS.Components.BaseClasses;
expandable connector Prescribed
  extends Modelica.Icons.SignalBus;
  parameter Integer nZones=2;
  Modelica.SIunits.HeatFlowRate QCon[nZones](each start=100);
  Modelica.SIunits.HeatFlowRate QRad[nZones](each start=100);
end Prescribed;
