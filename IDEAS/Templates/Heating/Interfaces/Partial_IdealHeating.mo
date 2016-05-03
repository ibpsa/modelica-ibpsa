within IDEAS.Templates.Heating.Interfaces;
partial model Partial_IdealHeating
  "Ideal, non-hydraulic heating with limited power"
  parameter Integer nZones(min=1)
    "Number of conditioned thermal zones in the building";
  parameter Real fractionRad[nZones]=0.3*ones(nZones)
    "Fraction of radiative to total power";
  parameter Real COP=3 "virtual COP to get a PEl as output";
  parameter SI.Time t=10 "Time needed to reach temperature setpoint";
  parameter Modelica.SIunits.Power[nZones] QNom(each min=0) = ones(nZones)*5000
    "Nominal power, can be seen as the max power of the emission system per zone";
  parameter Real[nZones] VZones = 50*ones(nZones)
    "Conditioned volumes of the zones";
  final parameter Modelica.SIunits.HeatCapacity[nZones] C=1012*1.204*VZones*5
    "Heat capacity of the conditioned zones (air capacity with a correction factor of 5)";
  SI.Power[nZones] QHeatZone;
end Partial_IdealHeating;
