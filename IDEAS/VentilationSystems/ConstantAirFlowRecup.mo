within IDEAS.VentilationSystems;
model ConstantAirFlowRecup
  "Ventilation System with constant airflow rate and recuperation efficiency"

  extends IDEAS.Interfaces.BaseClasses.VentilationSystem(nLoads=1);

  parameter Real[nZones] n "Air change rate (Air changes per hour ACH)";
  parameter Real recupEff(
    min=0,
    max=1) = 0.84 "Efficiency of heat recuperation";

  parameter Modelica.SIunits.Pressure sysPres=150
    "Total static and dynamic pressure drop, Pa";
  parameter Modelica.SIunits.Efficiency fanEff(
    min=0,
    max=1) = 0.85 "Fan efficiency";
  parameter Modelica.SIunits.Efficiency motEff(
    min=0,
    max=1) = 0.80 "Motor efficiency";

equation
  wattsLawPlug.P[1] = sum(n .* VZones/3600)*sysPres/fanEff/motEff;
  wattsLawPlug.Q[1] = 0;

  for i in 1:nZones loop
    heatPortCon[i].Q_flow = (TSensor[i] - sim.Te)*(n[i])*1012*1.204*VZones[i]/
      3600*(1 - recupEff);
  end for;

end ConstantAirFlowRecup;
