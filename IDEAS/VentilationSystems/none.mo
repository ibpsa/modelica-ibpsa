within IDEAS.VentilationSystems;
model None "No ventilation"
  extends IDEAS.VentilationSystems.Ideal(m_flow_val(each final k=0), final nLoads=0);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}}), graphics), Icon(coordinateSystem(extent={{-200,
            -100},{200,100}})));
end None;
