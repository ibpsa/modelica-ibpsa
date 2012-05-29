within IDEAS.Thermal.HeatingSystems;
model IdealFloorHeating "Ideal heating, no DHW, with floor heating"

  import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;
  extends IDEAS.Interfaces.HeatingSystem(
    emissionType = EmissionType.FloorHeating,
    nLoads=1);

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
  heatPortEmb[i].Q_flow = - QHeatZone[i];
end for;

QHeatTotal = sum(QHeatZone); // useful output, QHeatTotal defined in partial
P[1] = QHeatTotal/COP;
Q[1] = 0;

end IdealFloorHeating;
