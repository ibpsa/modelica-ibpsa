within IDEAS.Buildings.Validation.BaseClasses.VentilationSystem;
model None "None"
  extends IDEAS.Interfaces.BaseClasses.VentilationSystem(final nLoads=1);

equation
  wattsLawPlug.P[1] = 0;
  wattsLawPlug.Q[1] = 0;
  for i in 1:nZones loop
    heatPortCon[i].Q_flow = 0;
  end for;
  annotation (Diagram(graphics));
end None;
