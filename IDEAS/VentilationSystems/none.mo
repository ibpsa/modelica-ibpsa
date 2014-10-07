within IDEAS.VentilationSystems;
model None "No ventilation"
  extends IDEAS.VentilationSystems.Ideal(final m_flow=zeros(nZones), final TSet = 22*.ones(nZones) .+ 273.15);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end None;
