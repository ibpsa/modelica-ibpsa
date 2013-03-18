within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.AdaptedFluid;
connector FlowPort_a "Filled flow port (used upstream)"
  extends FlowPort;
annotation (Documentation(info="<HTML>
Same as FlowPort, but icon allows to differentiate direction of flow.
</HTML>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),           Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics));
end FlowPort_a;
