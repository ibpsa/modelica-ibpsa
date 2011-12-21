within IDEAS.Thermal.HeatingSystems;
model IdealFloorHeating "Ideal heating, no DHW, with floor heating"

  import IDEAS.Thermal.Components.HeatEmission.Auxiliaries.EmissionType;
  extends Partial_HeatingSystem(emissionType = EmissionType.FloorHeating);

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
  heatPortFH[i].Q_flow = - QHeatZone[i];
end for;

QHeatTotal = sum(QHeatZone);
P = QHeatTotal/COP;
Q = 0;

end IdealFloorHeating;
