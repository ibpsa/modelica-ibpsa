within IDEAS.Templates.BaseCircuits.Interfaces;
model PartialPumpCircuit

  // Extensions ----------------------------------------------------------------

  extends PartialFlowCircuit(redeclare
      Fluid.Movers.BaseClasses.PartialFlowMachine flowRegulator(
      tau=tauPump,
      energyDynamics=energyDynamics,
      massDynamics=massDynamics,
      dynamicBalance=dynamicBalance,
      addPowerToMedium=addPowerToMedium));

  extends PumpParameters;

  annotation (Icon(graphics={
        Ellipse(extent={{-20,80},{20,40}},lineColor={0,0,127},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,94},{4,80},{0,64}},
          color={0,255,128},
          smooth=Smooth.None),
        Polygon(
          points={{-12,76},{-12,44},{20,60},{-12,76}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PartialPumpCircuit;
