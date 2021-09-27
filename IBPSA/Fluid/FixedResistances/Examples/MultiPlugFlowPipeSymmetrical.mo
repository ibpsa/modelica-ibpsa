within IBPSA.Fluid.FixedResistances.Examples;
model MultiPlugFlowPipeSymmetrical
  extends IBPSA.Fluid.FixedResistances.Examples.MultiPlugFlowPipe(
    redeclare IBPSA.Fluid.FixedResistances.PlugFlowPipeSymmetrical pip[numPip]);
  annotation (
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/MultiPlugFlowPipeSymmetrical.mos"
        "Simulate and Plot"),
    experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MultiPlugFlowPipeSymmetrical;
