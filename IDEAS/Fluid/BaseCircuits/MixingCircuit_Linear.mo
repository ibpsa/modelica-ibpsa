within IDEAS.Fluid.BaseCircuits;
model MixingCircuit_Linear "Mixing circuit with linear three way valve"
  extends Interfaces.PartialMixingCircuit(redeclare
      Actuators.Valves.ThreeWayLinear partialThreeWayValve);
  extends IDEAS.Fluid.BaseCircuits.Interfaces.ValveParametersTop;

end MixingCircuit_Linear;
