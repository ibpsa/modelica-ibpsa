within IDEAS.Thermal.VentilationSystems;
model ConstantAirFlowRecup
  "Ventilation System with constant airflow rate and recuperation efficiency"
  extends IDEAS.Interfaces.VentilationSystem(nLoads=1);
  parameter Real[nZones] n "air change rate (Air changes per hour ACH)";
  parameter Real recupEff(min=0, max=1)=0.84 "efficiency of recuperation";
equation
wattsLawPlug[1].P = 0;
wattsLawPlug[1].Q = 0;
for i in 1:nZones loop
  heatPortCon[i].Q_flow =  (TSensor[i]-sim.Te)*(n[i])*1012*1.204*VZones[i]/3600*(1-recupEff);
end for;

end ConstantAirFlowRecup;
