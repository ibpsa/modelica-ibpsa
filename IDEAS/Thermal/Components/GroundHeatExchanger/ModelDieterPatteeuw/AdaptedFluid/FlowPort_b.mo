within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.AdaptedFluid;
connector FlowPort_b "Hollow flow port (used downstream)"
  extends FlowPort;
annotation (Documentation(info="<HTML>
Same as FlowPort, but icon allows to differentiate direction of flow.
</HTML>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),           Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
        graphics));
end FlowPort_b;
