within IDEAS.Thermal.HeatingSystems;
model IdealRadiatorHeating "Ideal heating, no DHW, with radiators"

  import IDEAS.Thermal.Components.HeatEmission.Auxiliaries.EmissionType;
  extends Partial_HeatingSystem(emissionType = EmissionType.Radiators);

parameter Real fractionRad[n_C] = {0.3 for i in 1:n_C}
    "Fraction of radiative to total power";
parameter Real COP = 3 "virtual COP to get a PEl as output";
Modelica.SIunits.Power[n_C] QHeatZone(each start=0);
parameter Modelica.SIunits.Time t=10
    "Time needed to reach temperature setpoint";

equation
for i in 1:n_C loop
  if noEvent((TOpAsked[i]-TOp[i]) > 0) then
      QHeatZone[i] = min(C[i] * (TOpAsked[i]-TOp[i]) / t,  QNom[i]);
  else
      QHeatZone[i] = 0;
  end if;
  heatPortRad[i].Q_flow = - fractionRad[i] * QHeatZone[i];
  heatPortConv[i].Q_flow = - (1-fractionRad[i]) * QHeatZone[i];
end for;

QHeatTotal = sum(QHeatZone);
P = QHeatTotal/COP;
Q = 0;

end IdealRadiatorHeating;
