within IDEAS.Thermal.HeatingSystems;
model IdealRadiatorHeating "Ideal heating, no DHW, with radiators"

  import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
  extends IDEAS.Interfaces.HeatingSystem(
    emissionType = EmissionType.Radiators,
    nLoads=1);

parameter Real fractionRad[nZones] = {0.3 for i in 1:nZones}
    "Fraction of radiative to total power";
parameter Real COP = 3 "virtual COP to get a PEl as output";
SI.Power[nZones] QHeatZone(each start=0);
parameter SI.Time t=10 "Time needed to reach temperature setpoint";

equation
for i in 1:nZones loop
  if noEvent((TSet[i]-TSensor[i]) > 0) then
      QHeatZone[i] = min(C[i] * (TSet[i]-TSensor[i]) / t,  QNom[i]);
  else
      QHeatZone[i] = 0;
  end if;
  heatPortRad[i].Q_flow = - fractionRad[i] * QHeatZone[i];
  heatPortCon[i].Q_flow = - (1-fractionRad[i]) * QHeatZone[i];
end for;

QHeatTotal = sum(QHeatZone); // useful output, QHeatTotal defined in partial
P[1] = QHeatTotal/COP;
Q[1] = 0;

end IdealRadiatorHeating;
