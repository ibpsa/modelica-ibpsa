within IDEAS.VentilationSystems;
model None "No ventilation system"
  extends IDEAS.VentilationSystems.ConstantAirFlowRecup(final n = zeros(nZones), final recupEff=1,
    hex(m1_flow_nominal=1, m2_flow_nominal=1));

end None;
