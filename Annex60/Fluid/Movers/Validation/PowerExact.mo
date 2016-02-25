within Annex60.Fluid.Movers.Validation;
model PowerExact
  extends PowerSimplified(pump_dp(use_record=true), pump_m_flow(use_record=true));
  annotation (
    experiment(StopTime=200),
    __Dymola_experimentSetupOutput,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    __Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Fluid/Movers/Validation/PowerExact.mos"
        "Simulate and plot"));
end PowerExact;
